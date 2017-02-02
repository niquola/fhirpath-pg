#include "postgres.h"
#include "miscadmin.h"
#include "fmgr.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/json.h"
#include "fhirpath.h"
#include "catalog/pg_type.h"
#include "utils/jsonb.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

void initJsonbValue(JsonbValue *jbv, Jsonb *jb);

void appendJsonbValuePrimitives(StringInfoData *buf, JsonbValue *jbv, char *prefix, char *suffix, char *delim);

static char *jsonbv_to_string(StringInfoData *out, JsonbValue *v);
typedef void (*reduce_fn)(void *acc, JsonbValue *val);
static void reduce_jsonb_array(JsonbValue *arr, void *acc, reduce_fn fn);
static void reduce_jsonb(void *buf, JsonbValue *val);
static void reduce_jsonb_values(JsonbValue *jbv, void *acc, reduce_fn fn);
static void reduce_as_string_values(void *acc, JsonbValue *val);
static void reduce_as_string(void *acc, JsonbValue *val);
static text *get_text_key(JsonbValue *val, char *key);
static void reduce_as_token(void *acc, JsonbValue *val);

PG_FUNCTION_INFO_V1(fhirpath_in);
Datum
fhirpath_in(PG_FUNCTION_ARGS)
{
	char				*in = PG_GETARG_CSTRING(0);
	int32				len = strlen(in);
	FhirpathParseItem	*fhirpath = parsefhirpath(in, len);
	Fhirpath    		*res;
	StringInfoData		buf;

	if (fhirpath != NULL)
	{

		initStringInfo(&buf);
		enlargeStringInfo(&buf, len /* estimation */);
		appendStringInfoSpaces(&buf, VARHDRSZ);

		serializeFhirpathParseItem(&buf, fhirpath);
		res = (Fhirpath*)buf.data;

		SET_VARSIZE(res, buf.len);
		PG_RETURN_FHIRPATH(res);
	} else {
		elog(INFO, "parse error");
		PG_RETURN_NULL();
	}

}


PG_FUNCTION_INFO_V1(fhirpath_out);
Datum
fhirpath_out(PG_FUNCTION_ARGS)
{

	Fhirpath			*in = PG_GETARG_FHIRPATH(0);

	StringInfoData  	buf;
	FhirpathItem		v;

	initStringInfo(&buf);
	enlargeStringInfo(&buf, VARSIZE(in) /* estimation */);

	fpInit(&v, in);

	printFhirpathItem(&buf, &v, false);


	PG_RETURN_CSTRING(buf.data);
}


static JsonbValue
*jsonb_get_key(char *key, JsonbValue *jbv){
	JsonbValue	key_v;
	key_v.type = jbvString;
	key_v.val.string.len = strlen(key);
	key_v.val.string.val = key;

	if(jbv->type == jbvBinary){
		return findJsonbValueFromContainer((JsonbContainer *) jbv->val.binary.data , JB_FOBJECT, &key_v);
	} else {
		return NULL;
	}
}

static bool
checkScalarEquality(FhirpathItem *fpi,  JsonbValue *jb) {
	if (jb->type == jbvString) {
		return (fpi->value.datalen == jb->val.string.len
				&& memcmp(jb->val.string.val, fpi->value.data, fpi->value.datalen) == 0);
	}
	return false;
}


/* this function convert JsonbValue to string, */
/* StringInfoData out buffer is optional */
char *jsonbv_to_string(StringInfoData *out, JsonbValue *v){
	if (out == NULL)
		out = makeStringInfo();

	switch(v->type)
	{
    case jbvNull:
		return NULL;
		break;
    case jbvBool:
		appendStringInfoString(out, (v->val.boolean ? "true" : "false"));
		break;
    case jbvString:
		appendBinaryStringInfo(out, v->val.string.val, v->val.string.len);
		/* appendStringInfoString(out, pnstrdup(v->val.string.val, v->val.string.len)); */
		break;
    case jbvNumeric:
		appendStringInfoString(out, DatumGetCString(DirectFunctionCall1(numeric_out, PointerGetDatum(v->val.numeric))));
		break;
    case jbvBinary:
    case jbvArray:
    case jbvObject:
	{
        (void) JsonbToCString(out, v->val.binary.data, -1);
	}
	break;
    default:
		elog(ERROR, "Wrong jsonb type: %d", v->type);
	}
	return out->data;
}

void
reduce_jsonb_array(JsonbValue *arr, void *acc, reduce_fn fn) {

	/* elog(INFO, "reduce array %s", jsonbv_to_string(NULL, arr)); */

	JsonbIterator *iter;
	JsonbValue	item;
	int next_it;

	if (arr != NULL && arr->type == jbvBinary){

		iter = JsonbIteratorInit((JsonbContainer *) arr->val.binary.data);
		next_it = JsonbIteratorNext(&iter, &item, true);

		if(next_it == WJB_BEGIN_ARRAY){
			while ((next_it = JsonbIteratorNext(&iter, &item, true)) != WJB_DONE){
				if(next_it == WJB_ELEM){
					fn(acc, &item);
				}
			}
		}
	}

}

static long
reduce_fhirpath(JsonbValue *jbv, FhirpathItem *path_item, void *acc, reduce_fn fn)
{

	char *key;

	JsonbValue *next_v = NULL;
	FhirpathItem next_item;

	JsonbIterator *array_it;
	JsonbValue	array_value;
	int next_it;

	long num_results = 0;

	check_stack_depth();

	switch(path_item->type)
	{

	case fpOr:
		/* elog(INFO, "extract fppipe"); */
		fpGetLeftArg(path_item, &next_item);
		num_results = reduce_fhirpath(jbv, &next_item, acc, fn);

		if(num_results == 0){
			fpGetRightArg(path_item, &next_item);
			num_results += reduce_fhirpath(jbv, &next_item, acc, fn);
		}

		break;
	case fpPipe:
		/* elog(INFO, "extract Pipe"); */
		fpGetLeftArg(path_item, &next_item);
		num_results += reduce_fhirpath(jbv, &next_item, acc, fn);

		fpGetRightArg(path_item, &next_item);
		num_results += reduce_fhirpath(jbv, &next_item, acc, fn);

		break;
	case fpEqual:
		fpGetLeftArg(path_item, &next_item);
		key = fpGetString(&next_item, NULL);
		next_v = jsonb_get_key(key, jbv);

		fpGetRightArg(path_item, &next_item);

		if(next_v != NULL &&  checkScalarEquality(&next_item, next_v)){
			if (fpGetNext(path_item, &next_item)) {
				num_results += reduce_fhirpath(jbv, &next_item, acc, fn);
			} else {
				fn(acc, jbv);
				num_results += 1;
			}
		}
		break;
	case fpResourceType:
		key = fpGetString(path_item, NULL);
		next_v = jsonb_get_key("resourceType", jbv);
		/* elog(INFO, "fpResourceType: %s, %s",  key, next_v->val.string.val); */
		if(next_v != NULL && checkScalarEquality(path_item, next_v)){
			if (fpGetNext(path_item, &next_item)) {
				num_results = reduce_fhirpath(jbv, &next_item, acc, fn);
			}
		}
		break;
	case fpKey:
		key = fpGetString(path_item, NULL);
		next_v = jsonb_get_key(key, jbv);


		if (next_v != NULL) {
			/* elog(INFO, "type %d", next_v->type); */
			if(next_v->type == jbvBinary){

				array_it = JsonbIteratorInit((JsonbContainer *) next_v->val.binary.data);
				next_it = JsonbIteratorNext(&array_it, &array_value, true);

				if(next_it == WJB_BEGIN_ARRAY){
					/* elog(INFO, "We are in array"); */
					while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
						if(next_it == WJB_ELEM){
							if(fpGetNext(path_item, &next_item)) {
								num_results += reduce_fhirpath(&array_value, &next_item, acc, fn);
							} else {
								fn(acc, &array_value);
								num_results += 1;
							}
						}
					}
				}
				else if(next_it == WJB_BEGIN_OBJECT){
					/* elog(INFO, "We are in object"); */
					if(fpGetNext(path_item, &next_item)) {
						num_results += reduce_fhirpath(next_v, &next_item, acc, fn);
					} else if (next_v != NULL){
						fn(acc, next_v);
						num_results += 1;

					}
				}
			} else if (next_v != NULL ){
				fn(acc, next_v);
				num_results += 1;
			}

		}
		break;
	case fpValues:
		elog(INFO, "Not impl");
		break;
	default:
		elog(INFO, "TODO extract");
	}
	return num_results;
}



void
initJsonbValue(JsonbValue *jbv, Jsonb *jb) {
	jbv->type = jbvBinary;
	jbv->val.binary.data = &jb->root;
	jbv->val.binary.len = VARSIZE_ANY_EXHDR(jb);
}


void reduce_jsonb(void *buf, JsonbValue *val){
	JsonbInState *result = (JsonbInState *) buf;
	/* elog(INFO, "COLLECT: %s",jsonbv_to_string(NULL, val)); */
	result->res = pushJsonbValue(&result->parseState, WJB_ELEM, val);
}



PG_FUNCTION_INFO_V1(fhirpath_extract);
Datum
fhirpath_extract(PG_FUNCTION_ARGS)
{

	Jsonb       *jb = PG_GETARG_JSONB(0);
	Fhirpath	*fp_in = PG_GETARG_FHIRPATH(1);

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	/* init jsonbvalue from in disck */
	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	JsonbInState result;
	memset(&result, 0, sizeof(JsonbInState));

	result.res = pushJsonbValue(&(result.parseState), WJB_BEGIN_ARRAY, NULL);

	long num_results = reduce_fhirpath(&jbv, &fp, &result, reduce_jsonb);

	result.res = pushJsonbValue(&(result.parseState), WJB_END_ARRAY, NULL);

	/* elog(INFO, "num results %d", num_results); */
	if( num_results > 0 ){
		PG_RETURN_POINTER(JsonbValueToJsonb(result.res));
	} else {
		PG_RETURN_NULL();
	}

}


void
appendJsonbValuePrimitives(StringInfoData *buf, JsonbValue *jbv, char *prefix, char *suffix, char *delim){
	if(jbv != NULL) {
		switch(jbv->type){
		case jbvBinary:
		case jbvArray:
		case jbvObject:
		{
			JsonbValue next;
			JsonbIterator *it = JsonbIteratorInit((JsonbContainer *) jbv->val.binary.data);
			JsonbIteratorToken r = JsonbIteratorNext(&it, &next, true);
			switch(r){
			case WJB_BEGIN_ARRAY:
				while ((r = JsonbIteratorNext(&it, &next, true)) != WJB_DONE) {
					appendJsonbValuePrimitives(buf, &next, prefix, suffix, delim);
				}
				break;
			case WJB_BEGIN_OBJECT:
				elog(INFO, "not impl");
				break;
			default:
				elog(INFO, "not impl");
			}

		}
		case jbvBool:
		case jbvNull:
		case jbvNumeric:
			/* TODO */
		break;
		break;
		case jbvString:
			appendStringInfoString(buf, prefix);
			appendBinaryStringInfo(buf, jbv->val.string.val, jbv->val.string.len);
			appendStringInfoString(buf, suffix);
			appendStringInfoString(buf, delim);
			break;
		}
	}
}


void reduce_jsonb_values(JsonbValue *jbv, void *acc, reduce_fn fn) {

	JsonbIterator *array_it;
	JsonbValue	array_value;
	int next_it;

	if(jbv->type == jbvBinary) {
		array_it = JsonbIteratorInit((JsonbContainer *) jbv->val.binary.data);
		next_it = JsonbIteratorNext(&array_it, &array_value, true);

		if(next_it == WJB_BEGIN_ARRAY || next_it == WJB_BEGIN_OBJECT){
			while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
				if(next_it == WJB_ELEM || next_it == WJB_VALUE){
					reduce_jsonb_values(&array_value, acc, fn);
				}
			}
		}
	} else {
		fn(acc, jbv);
	}
}

typedef struct StringAccumulator {
	char	*element_type;
	StringInfoData *buf;
} StringAccumulator;


void reduce_as_string_values(void *acc, JsonbValue *val) {
	StringAccumulator *sacc = (StringAccumulator *) acc;
	jsonbv_to_string(sacc->buf, val);
	appendStringInfoString(sacc->buf, "$");
}

void reduce_as_string(void *acc, JsonbValue *val){
	reduce_jsonb_values(val, acc, reduce_as_string_values);
}

PG_FUNCTION_INFO_V1(fhirpath_as_string);
Datum
fhirpath_as_string(PG_FUNCTION_ARGS) {

	Jsonb      *jb = PG_GETARG_JSONB(0);
	Fhirpath   *fp_in = PG_GETARG_FHIRPATH(1);
	char       *type = text_to_cstring(PG_GETARG_TEXT_P(2));


	if(jb == NULL){ PG_RETURN_NULL();}

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	StringInfoData		buf;
	initStringInfo(&buf);
	appendStringInfoSpaces(&buf, VARHDRSZ);
	appendStringInfoString(&buf, "$");

	StringAccumulator acc;
	acc.element_type = type;
	acc.buf = &buf;

	long num_results = reduce_fhirpath(&jbv, &fp, &acc, reduce_as_string);

	if( num_results > 0 ){
		SET_VARSIZE(buf.data, buf.len);
		PG_RETURN_TEXT_P(buf.data);
	} else {
		PG_RETURN_NULL();
	}
}

typedef struct TokenAccumulator {
	char	*element_type;
	ArrayBuildState *acc;
} TokenAccumulator;

text *
get_text_key(JsonbValue *val, char *key) {
	JsonbValue *value = jsonb_get_key(key, val);

	if(value!=NULL && value->type == jbvString)
		return cstring_to_text_with_len(value->val.string.val, value->val.string.len);
	else
		return NULL;
}


static void
appendStringInfoText(StringInfo str, const text *t)
{
	appendBinaryStringInfo(str, VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t));
}

static void
append_token(TokenAccumulator *acc, text *token) {
	if( token != NULL )
		acc->acc = accumArrayResult(acc->acc, (Datum)token, false, TEXTOID, CurrentMemoryContext);
}

static void
append_token_pair(TokenAccumulator *tacc, text *a, text *b) {

	if( a != NULL && b != NULL){
		StringInfoData		buf;
		initStringInfo(&buf);
		appendStringInfoSpaces(&buf, VARHDRSZ);
		appendStringInfoText(&buf, a);
		appendStringInfoString(&buf, "|");
		appendStringInfoText(&buf, b);

		SET_VARSIZE(buf.data, buf.len);
		append_token(tacc,  (text *)buf.data);
	}

}



void reduce_as_token(void *acc, JsonbValue *val){
	TokenAccumulator *tacc = (TokenAccumulator *) acc;

	/* elog(INFO, "reduce token [%s] %s",tacc->element_type, jsonbv_to_string(NULL, val)); */

	if(strcmp(tacc->element_type, "Identifier") == 0 ||
	   strcmp(tacc->element_type, "ContactPoint") == 0 ){

		text *value = get_text_key(val, "value");
		append_token(tacc,  value);
		text *system = get_text_key(val, "system");
		append_token(tacc,  system);

		append_token_pair(tacc, system, value);

	} else if (strcmp(tacc->element_type, "code") == 0 || strcmp(tacc->element_type, "string") == 0 || strcmp(tacc->element_type, "uri") == 0) {
		if(val!=NULL && val->type == jbvString)
		  append_token(tacc,  cstring_to_text_with_len(val->val.string.val, val->val.string.len));

	} else if (strcmp(tacc->element_type, "Coding") == 0) {
		text *code = get_text_key(val, "code");
		append_token(tacc, code);
		text *system = get_text_key(val, "system");
		append_token(tacc, system);

		append_token_pair(tacc, system, code);

	} else if (strcmp(tacc->element_type, "CodeableConcept") == 0) {

		JsonbValue *codings = jsonb_get_key("coding", val);

		if(codings != NULL) {

			/* we have to change element type */
			TokenAccumulator tmpacc;
			tmpacc.element_type = "Coding";
			tmpacc.acc = tacc->acc;
			reduce_jsonb_array(codings, &tmpacc, reduce_as_token);
			tacc->acc = tmpacc.acc;

		}


	} else if (strcmp(tacc->element_type, "Quantity") == 0) {

		/* elog(INFO, "quantity %s", jsonbv_to_string(NULL, val)); */

		text *code = get_text_key(val, "code");
		append_token(tacc, code);
		text *unit = get_text_key(val, "unit");
		append_token(tacc, unit);
		text *system = get_text_key(val, "system");
		append_token(tacc, system);

		append_token_pair(tacc, system, code);
		append_token_pair(tacc, system, unit);

	} else if (strcmp(tacc->element_type, "Reference") == 0) {

		/* elog(INFO, "ref %s", jsonbv_to_string(NULL, val)); */
		text *ref = get_text_key(val, "reference");
		append_token(tacc, ref);

	} else {
		elog(ERROR, "Unknown datatype %s", tacc->element_type);
	}
}

PG_FUNCTION_INFO_V1(fhirpath_as_token);
Datum
fhirpath_as_token(PG_FUNCTION_ARGS) {

	Jsonb      *jb = PG_GETARG_JSONB(0);
	Fhirpath   *fp_in = PG_GETARG_FHIRPATH(1);
	char       *type = text_to_cstring(PG_GETARG_TEXT_P(2));


	if(jb == NULL){ PG_RETURN_NULL();}

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	TokenAccumulator acc;
	acc.element_type = type;
	acc.acc = NULL;

	long num_results = reduce_fhirpath(&jbv, &fp, &acc, reduce_as_token);

	if (num_results > 0 && acc.acc != NULL)
		PG_RETURN_ARRAYTYPE_P(makeArrayResult(acc.acc, CurrentMemoryContext));
	else
		PG_RETURN_NULL();
}
