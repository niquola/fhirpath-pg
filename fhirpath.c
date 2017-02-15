#include "postgres.h"
#include "miscadmin.h"
#include "fmgr.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/formatting.h"
#include "utils/timestamp.h"
#include "utils/datetime.h"
#include "utils/json.h"
#include "fhirpath.h"
#include "catalog/pg_type.h"
#include "catalog/pg_collation.h"
#include "utils/jsonb.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

void initJsonbValue(JsonbValue *jbv, Jsonb *jb);

void appendJsonbValuePrimitives(StringInfoData *buf, JsonbValue *jbv, char *prefix, char *suffix, char *delim);

static char *jsonbv_to_string(StringInfoData *out, JsonbValue *v);
static text *jsonbv_to_text(StringInfoData *out, JsonbValue *v);
typedef void (*reduce_fn)(void *acc, JsonbValue *val);
static void reduce_jsonb_array(JsonbValue *arr, void *acc, reduce_fn fn);
static void reduce_jsonb(void *buf, JsonbValue *val);
static void reduce_jsonb_values(JsonbValue *jbv, void *acc, reduce_fn fn);
static void reduce_as_string_values(void *acc,  JsonbValue *val);
static void reduce_as_string(void *acc, JsonbValue *val);
static void reduce_as_reference(void *acc, JsonbValue *val);
static void reduce_as_number(void *acc, JsonbValue *val);
static text *get_text_key(JsonbValue *val, char *key);
static void reduce_as_token(void *acc, JsonbValue *val);
static void reduce_as_date(void *acc, JsonbValue *val);

static void reduce_jsonb_as_strings(JsonbValue *jbv, void *acc, reduce_fn fn);

typedef enum MinMax {min, max} MinMax;  

static MinMax minmax_from_string(char *s);

typedef enum FPSearchType {FPToken, FPString, FPDate, FPNumeric, FPReference} FPSearchType;  

static Datum date_bound(char *date_str, long str_len,  MinMax minmax);

typedef struct BasicAccumulator {
	char	*element_type;
	FPSearchType search_type;
} BasicAccumulator;

typedef struct NumericAccumulator {
	char	*element_type;
	FPSearchType search_type;
	Numeric acc;
	MinMax minmax;
} NumericAccumulator;

typedef struct StringAccumulator {
	char	*element_type;
	FPSearchType search_type;
	StringInfoData *buf;
} StringAccumulator;

typedef struct ArrayAccumulator {
	char	*element_type;
	FPSearchType search_type;
	ArrayBuildState *acc;
	bool case_insensitive;
} ArrayAccumulator;

typedef struct DateAccumulator {
	char	*element_type;
	FPSearchType search_type;
	Datum  acc;
	MinMax minmax;
} DateAccumulator;

static void update_numeric(NumericAccumulator *nacc, Numeric num);
/* static char * numeric_to_cstring(Numeric n); */

MinMax
minmax_from_string(char *s){
	if(strcmp(s, "min") == 0){
		return min;
	} else if (strcmp(s, "max") == 0) {
		return max;
	} else {
		elog(ERROR, "expected min or max");
	}
}


/* standard *in* function to parse fhirpath datatype from string */
/* Fhirpath is parse tree, see fhirpath_gram for grammars */

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

/* standard *out* function to dump fhirpath datatype to text */

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


/* return value of obj key */
static JsonbValue *
jsonb_get_key(char *key, JsonbValue *obj){

	JsonbValue	key_v;
	key_v.type = jbvString;
	key_v.val.string.len = strlen(key);
	key_v.val.string.val = key;

	/* test it's container (object) */
	if(obj->type == jbvBinary){
		/* we need to use special function to get valid JsonbValue */
		return findJsonbValueFromContainer((JsonbContainer *) obj->val.binary.data , JB_FOBJECT, &key_v);
	} else {
		return NULL;
	}
}

static inline char *
starts_with(char const *str, char const *pref, int limit) {
	int next = limit;
	char *postfix;
	for ( ; next > 0; str++, pref++, --next) {
     	if (*pref == '\0'){
			postfix = palloc(next + 1);
			memcpy(postfix, str, next);
			postfix[next] = '\0';
			return postfix;
		}
		else if (*str != *pref)
			return NULL;
	}
    return NULL;
}

inline static JsonbValue *
jsonb_get_prefix(char *key, JsonbValue *obj, char **type){

	JsonbIterator *iter;
	/* check for memory */
	/* we return this item from function */
	JsonbValue	*item;
	int next_it;
	char *postfix;

	bool matched = false;

	if (obj != NULL && obj->type == jbvBinary){

		item = palloc(sizeof(JsonbValue));
		iter = JsonbIteratorInit((JsonbContainer *) obj->val.binary.data);
		next_it = JsonbIteratorNext(&iter, item, true);

		if(next_it == WJB_BEGIN_OBJECT){
			while ((next_it = JsonbIteratorNext(&iter, item, true)) != WJB_DONE){
				if(next_it == WJB_KEY && item->type == jbvString){
					postfix = starts_with(item->val.string.val, key, item->val.string.len);
					if(postfix != NULL){
						/* write type as postfix */
						*type = postfix;
						matched = true;
						/* elog(INFO, "match prefix[key]: %s", jsonbv_to_string(NULL, item)); */
					}
				}
				if(next_it == WJB_VALUE && matched){
					/* elog(INFO, "prefix[value]: %s", jsonbv_to_string(NULL, item)); */
					return item; 
				}
			}
		}
		pfree(item);
	}
	return NULL;
}

inline text *
jsonb_string_as_text(JsonbValue *value) {

	if(value!=NULL && value->type == jbvString) {
		return cstring_to_text_with_len(value->val.string.val, value->val.string.len);
	} else {
		return NULL;
	}
}

/* return string value of key of obj as pg text */
text *
get_text_key(JsonbValue *obj, char *key) {
	/* return jsonb_string_as_text(jsonb_get_key(key, obj)); */
	return jsonbv_to_text(NULL, jsonb_get_key(key, obj));
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

text *jsonbv_to_text(StringInfoData *out, JsonbValue *v){
	if (v == NULL) 
		return NULL;

	if (out == NULL)
		out = makeStringInfo();

	appendStringInfoSpaces(out, VARHDRSZ);

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
	SET_VARSIZE(out->data, out->len);
	return (text *)out->data;
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

		/* handle polymorphics */
		if(next_v == NULL && path_item->nextPos == 0){
			BasicAccumulator *bacc = (BasicAccumulator *)acc;
			if(strcmp(bacc->element_type, "Polymorphic") == 0) {
				char *poly_type;
				next_v = jsonb_get_prefix(key, jbv, &poly_type);
				if(next_v != NULL){
					/* elog(INFO, "!!!el type %s, type %s, %s", bacc->element_type, poly_type, jsonbv_to_string(NULL, next_v)); */
					bacc->element_type = poly_type;
				}
			}
		}


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


void reduce_jsonb_as_strings(JsonbValue *jbv, void *acc, reduce_fn fn) {

	JsonbIterator *array_it;
	JsonbValue	array_value;
	JsonbValue	key;
	int next_it;

	if(jbv->type == jbvBinary) {
		array_it = JsonbIteratorInit((JsonbContainer *) jbv->val.binary.data);
		next_it = JsonbIteratorNext(&array_it, &array_value, true);

		if(next_it == WJB_BEGIN_ARRAY) {
			while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
				if(next_it == WJB_ELEM || next_it == WJB_VALUE){
					reduce_jsonb_as_strings(&array_value, acc, fn);
				}
			}
		} else if( next_it == WJB_BEGIN_OBJECT ){
			while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
				if(next_it == WJB_KEY){
					/* NOTE: here we need to copy because iterator change content of pointer */
					key = array_value;
				}
				if(next_it == WJB_VALUE){
					StringAccumulator *sacc = (StringAccumulator *) acc;
					if( key.type == jbvString &&
						(strcmp(sacc->element_type, "HumanName") == 0 || strcmp(sacc->element_type, "Address") == 0) &&
						( memcmp(key.val.string.val, "use", key.val.string.len) == 0 || memcmp(key.val.string.val, "period", key.val.string.len) == 0 )
						) {
						/* elog(INFO, "Skip %s", jsonbv_to_string(NULL, &key)); */

					} else {
						reduce_jsonb_as_strings(&array_value, acc, fn);
					}
				}
			}
		}
	} else if (jbv->type == jbvString  || jbv->type == jbvNumeric){
		fn(acc, jbv);
	}
}


void reduce_as_string_values(void *acc, JsonbValue *val) {
	StringAccumulator *sacc = (StringAccumulator *) acc;
	jsonbv_to_string(sacc->buf, val);
	appendStringInfoString(sacc->buf, "$");
}

void reduce_as_string(void *acc, JsonbValue *val){
	reduce_jsonb_as_strings(val, acc, reduce_as_string_values);
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
	acc.search_type = FPString;
	acc.buf = &buf;

	long num_results = reduce_fhirpath(&jbv, &fp, &acc, reduce_as_string);

	if( num_results > 0 ){
		SET_VARSIZE(buf.data, buf.len);
		PG_RETURN_TEXT_P(buf.data);
	} else {
		PG_RETURN_NULL();
	}
}




static void
appendStringInfoText(StringInfo str, const text *t)
{
	appendBinaryStringInfo(str, VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t));
}

static text* text_lower(text *t){
	if(t != NULL) {
		return cstring_to_text_with_len(str_tolower(VARDATA_ANY(t), VARSIZE_ANY_EXHDR(t), DEFAULT_COLLATION_OID), VARSIZE_ANY_EXHDR(t));
	}
	return NULL;
}

static void
append_token(ArrayAccumulator *acc, text *token) {
	if( token != NULL ) {
		acc->acc = accumArrayResult(acc->acc,
									(Datum) (acc->case_insensitive ? text_lower(token) : token),
									false, TEXTOID, CurrentMemoryContext);
	}
}

static void
append_token_pair(ArrayAccumulator *tacc, text *a, text *b) {

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
	ArrayAccumulator *tacc = (ArrayAccumulator *) acc;

	/* elog(INFO, "reduce token [%s] %s",tacc->element_type, jsonbv_to_string(NULL, val)); */

	if(strcmp(tacc->element_type, "Identifier") == 0 ||
	   strcmp(tacc->element_type, "ContactPoint") == 0 ){

		text *value = get_text_key(val, "value");
		append_token(tacc,  value);
		text *system = get_text_key(val, "system");
		append_token(tacc,  system);

		append_token_pair(tacc, system, value);

	} else if (strcmp(tacc->element_type, "code") == 0 || strcmp(tacc->element_type, "string") == 0 || strcmp(tacc->element_type, "uri") == 0) {

		append_token(tacc, jsonb_string_as_text(val));

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
			ArrayAccumulator tmpacc;
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

	} else if (val->type == jbvString || val->type == jbvBool || val->type == jbvNumeric) {

		append_token(tacc, jsonbv_to_text(NULL, val));

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

	ArrayAccumulator acc;
	acc.element_type = type;
	acc.search_type = FPToken;
	acc.acc = NULL;
	acc.case_insensitive = true;

	long num_results = reduce_fhirpath(&jbv, &fp, &acc, reduce_as_token);

	if (num_results > 0 && acc.acc != NULL)
		PG_RETURN_ARRAYTYPE_P(makeArrayResult(acc.acc, CurrentMemoryContext));
	else
		PG_RETURN_NULL();
}

static inline
void append_ref(ArrayAccumulator *tacc, JsonbValue *val) {

	if (val != NULL && val->type == jbvString) {

		int last_entr = 0;
		int num_entr = 0;
		int i =0;

		for(i = 0; i < val->val.string.len; i++) {
			char ch = val->val.string.val[i];
			if(ch == '/'){
				num_entr += 1;
				last_entr = i;
			}
		}

		append_token(tacc, cstring_to_text_with_len(val->val.string.val, val->val.string.len));

		if(num_entr == 1) {
			char *resource_id = val->val.string.val + last_entr + 1;
			append_token(tacc, cstring_to_text_with_len(resource_id, val->val.string.len - last_entr - 1));
		}

	}
}

void reduce_as_reference(void *acc, JsonbValue *val){
	ArrayAccumulator *tacc = (ArrayAccumulator *) acc;

	/* elog(INFO, "reduce ref [%s] %s",tacc->element_type, jsonbv_to_string(NULL, val)); */
	if( strcmp(tacc->element_type, "Reference") == 0){

		append_ref(tacc, jsonb_get_key("reference", val));

	} else if (val != NULL && val->type == jbvString) {

		append_ref(tacc, val);
	}

}

PG_FUNCTION_INFO_V1(fhirpath_as_reference);
Datum
fhirpath_as_reference(PG_FUNCTION_ARGS) {

	Jsonb      *jb = PG_GETARG_JSONB(0);
	Fhirpath   *fp_in = PG_GETARG_FHIRPATH(1);
	char       *type = text_to_cstring(PG_GETARG_TEXT_P(2));


	if(jb == NULL || fp_in == NULL ){ PG_RETURN_NULL();}

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	ArrayAccumulator acc;
	acc.element_type = type;
	acc.search_type = FPReference;
	acc.acc = NULL;
	acc.case_insensitive = false;

	long num_results = reduce_fhirpath(&jbv, &fp, &acc, reduce_as_reference);

	if (num_results > 0 && acc.acc != NULL)
		PG_RETURN_ARRAYTYPE_P(makeArrayResult(acc.acc, CurrentMemoryContext));
	else
		PG_RETURN_NULL();
}


/* static char * */
/* numeric_to_cstring(Numeric n) */
/* { */
/* 	Datum		d = NumericGetDatum(n); */

/* 	return DatumGetCString(DirectFunctionCall1(numeric_out, d)); */
/* } */

void
update_numeric(NumericAccumulator *nacc, Numeric num){
	if(nacc->acc == NULL){
		nacc->acc = num;
	} else {

		bool gt = DirectFunctionCall2(numeric_gt, (Datum) nacc->acc, (Datum) num);
		/* elog(INFO, "%s > %s, gt %d min %d", numeric_to_cstring(num), numeric_to_cstring(nacc->acc), gt, nacc->minmax); */
		if (nacc->minmax == min && gt == 1){
			nacc->acc = num;
		} else if (nacc->minmax == max && gt == 0){
			nacc->acc = num;
		}
	}
}

void reduce_as_number(void *acc, JsonbValue *val){
	NumericAccumulator *nacc = acc;

	/* elog(INFO, "extract as number [%s] %s", nacc->element_type, jsonbv_to_string(NULL, val)); */

	if ( strcmp(nacc->element_type, "decimal") == 0 ||
		 strcmp(nacc->element_type, "integer") == 0 ||
		 strcmp(nacc->element_type, "positiveInt") == 0 ||
		 strcmp(nacc->element_type, "unsignedInt") == 0 ) {

		if(val != NULL && val->type == jbvNumeric){
			update_numeric(nacc, val->val.numeric);
		}

	} else if (
		strcmp(nacc->element_type, "Duration") == 0 ||
		strcmp(nacc->element_type, "Quantity") == 0 ||
		strcmp(nacc->element_type, "Age") == 0 ||
		strcmp(nacc->element_type, "Count") == 0 ||
		strcmp(nacc->element_type, "Money") == 0 ||
		strcmp(nacc->element_type, "Distance") == 0 ||
		strcmp(nacc->element_type, "SimpleQuantity") == 0
	) {

		JsonbValue *value = jsonb_get_key("value", val); 

		if(value != NULL && value->type == jbvNumeric){
			update_numeric(nacc, value->val.numeric);
		}

	} else {
		elog(ERROR, "Could not extract as number [%s] %s", nacc->element_type, jsonbv_to_string(NULL, val));
	}
}


PG_FUNCTION_INFO_V1(fhirpath_as_number);

Datum
fhirpath_as_number(PG_FUNCTION_ARGS) {

	Jsonb      *jb = PG_GETARG_JSONB(0);
	Fhirpath   *fp_in = PG_GETARG_FHIRPATH(1);
	char       *type = text_to_cstring(PG_GETARG_TEXT_P(2));
	MinMax minmax = minmax_from_string(text_to_cstring(PG_GETARG_TEXT_P(3))); 


	if(jb == NULL || fp_in == NULL ){ PG_RETURN_NULL();}

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	NumericAccumulator acc;
	acc.element_type = type;
	acc.search_type = FPNumeric;
	acc.minmax = minmax;
	acc.acc = NULL;

	reduce_fhirpath(&jbv, &fp, &acc, reduce_as_number);

	if (acc.acc != NULL)
		PG_RETURN_NUMERIC(acc.acc);
	else
		PG_RETURN_NULL();
}



Datum
date_bound(char *date_str, long str_len,  MinMax minmax){
	if(date_str != NULL) {
		char *ref_str = "0000-01-01T00:00:00";
		long ref_str_len = strlen(ref_str);

		long date_in_len = (str_len > ref_str_len) ? str_len : ref_str_len;
	    char *date_in = palloc(date_in_len + 1);
		memcpy(date_in, date_str, str_len);

		/* elog(INFO, "date_str: '%s', %d", date_str, str_len ); */

		if( str_len < ref_str_len){
			long diff = (ref_str_len - str_len);
			memcpy(date_in + str_len, ref_str + str_len, diff);
		}

		date_in[date_in_len] = '\0';

		/* elog(INFO, "input: '%s', %d, %d", date_in, date_in_len, ref_str_len); */

		Datum min_date = DirectFunctionCall3(timestamptz_in,
											 CStringGetDatum(date_in),
											 ObjectIdGetDatum(InvalidOid),
											 Int32GetDatum(-1));
		if(minmax == min) {
			return min_date;
		} else if (minmax == max ) {
			Timestamp	max_date;
			int			tz;
			struct pg_tm tt, *tm = &tt;
			fsec_t		fsec;

			if (timestamp2tm(min_date, &tz, tm, &fsec, NULL, NULL) != 0)
				ereport(ERROR,
						(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
						 errmsg("timestamp out of range")));

			/* elog(INFO, "get tm %d y %d m %d d %d fsec", tm->tm_year, tm->tm_mon, tm->tm_mday, fsec); */

			if (str_len < 5) {
				tm->tm_mon = 12;
			}
			if (str_len < 8) {
				tm->tm_mday = day_tab[isleap(tm->tm_year)][tm->tm_mon - 1];
			}
			if (str_len < 11) {
				tm->tm_hour = 23;
			}
			if (str_len < 14) {
				tm->tm_min = 59;
				tm->tm_sec = 59;
			}
			if (str_len < 17) {
				tm->tm_sec = 59;
			}

			/* round fsec up .555 to .555999 */
			/* this is not strict algorytm so if user enter .500 we will lose 00 */
			/* better to analyze initial string */
			int fsec_up = 0, temp, count = 1;
			if(fsec == 0){
				fsec_up = 999999;
			} else {
				temp = fsec;
				while(temp > 0) {
					if(temp%10 == 0) {
						temp = temp/10;
						fsec_up += 9 * count; 
						count= count * 10;
					} else {
						break;
					}
				}
			}


			if (tm2timestamp(tm, (fsec + fsec_up), &tz, &max_date) != 0)
				ereport(ERROR,
						(errcode(ERRCODE_DATETIME_VALUE_OUT_OF_RANGE),
						 errmsg("timestamp out of range")));

			return max_date;
		} else {
			elog(ERROR, "expected min or max value");
		}
	}
	return 0;
}

void reduce_as_date(void *acc, JsonbValue *val){
	DateAccumulator *dacc = acc;
	/* elog(INFO, "extract as date %s as %s", jsonbv_to_string(NULL, val), dacc->element_type);   */

	if(val != NULL && val->type == jbvString) {

		Datum date = date_bound(val->val.string.val, val->val.string.len, dacc->minmax);

		if(dacc->minmax == min) {
			if(dacc->acc != 0){
				int gt = DirectFunctionCall2(timestamptz_cmp_timestamp, date, dacc->acc);
				/* elog(INFO, "compare %d", gt); */
				if(gt < 0) {
					dacc->acc = date;
				}
			} else if (date != 0) {
				dacc->acc = date;
			}
		} else if (dacc->minmax == max ) {
			if(dacc->acc != 0){
				int gt = DirectFunctionCall2(timestamptz_cmp_timestamp, date, dacc->acc);
				if(gt > 0) {
					dacc->acc = date;
				}
			} else if (date != 0){
				dacc->acc = date;
			}

		} else {
			elog(ERROR, "expected min or max value");
		}

	} else {
		if(strcmp(dacc->element_type, "Period") == 0){
			JsonbValue *prop;
			Datum inf;
			/* elog(INFO, "Period: datetime from %s", jsonbv_to_string(NULL, prop)); */
			if(dacc->minmax == min){
				prop = jsonb_get_key("start", val);
				if(prop != NULL) {
					reduce_as_date(acc, prop);
				} else {
					/* inifity case */
					TIMESTAMP_NOBEGIN(inf);
					dacc->acc = inf;
				}
			} else {
				prop = jsonb_get_key("end", val);
				if(prop != NULL) {
					reduce_as_date(acc, prop);
				} else {
					/* inifity case */
					TIMESTAMP_NOEND(inf);
					dacc->acc = inf;
				}
			}
		} else if(strcmp(dacc->element_type, "Timing") == 0){
			JsonbValue *prop;
			prop = jsonb_get_key("event", val);
			/* elog(INFO, "Timing: datetime from %s", jsonbv_to_string(NULL, prop)); */
			if(prop != NULL) {
				reduce_jsonb_array(prop, acc, reduce_as_date);
			}
		} else {
			elog(WARNING, "I do not know how to get datetime from %s", jsonbv_to_string(NULL, val));
		}
	}

}

PG_FUNCTION_INFO_V1(fhirpath_date_bound);

Datum
fhirpath_date_bound(PG_FUNCTION_ARGS) {
	char       *date = text_to_cstring(PG_GETARG_TEXT_P(0));
	MinMax minmax = minmax_from_string(text_to_cstring(PG_GETARG_TEXT_P(1))); 

	Datum res = date_bound(date, strlen(date), minmax);

	if(res != 0){
		return res;
	} else {
		PG_RETURN_NULL();
	}
}


PG_FUNCTION_INFO_V1(fhirpath_as_date);

Datum
fhirpath_as_date(PG_FUNCTION_ARGS) {

	Jsonb      *jb = PG_GETARG_JSONB(0);
	Fhirpath   *fp_in = PG_GETARG_FHIRPATH(1);
	char       *type = text_to_cstring(PG_GETARG_TEXT_P(2));
	MinMax minmax = minmax_from_string(text_to_cstring(PG_GETARG_TEXT_P(3))); 



	if(jb == NULL || fp_in == NULL ){ PG_RETURN_NULL();}

	FhirpathItem	fp;
	fpInit(&fp, fp_in);

	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	DateAccumulator acc;
	acc.element_type = type;
	acc.search_type = FPDate;
	acc.acc = 0;
	acc.minmax = minmax;

	reduce_fhirpath(&jbv, &fp, &acc, reduce_as_date);

	if (acc.acc != 0)
		PG_RETURN_TIMESTAMPTZ(acc.acc);
	else
		PG_RETURN_NULL();
}
