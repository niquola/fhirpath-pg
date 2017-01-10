#include "postgres.h"
#include "miscadmin.h"
#include "fmgr.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/json.h"
#include "fhirpath.h"
#include "utils/jsonb.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

void initJsonbValue(JsonbValue *jbv, Jsonb *jb);


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

		/* elog(INFO, "serialized"); */
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

	/* elog(INFO, "deserialize"); */

	initStringInfo(&buf);
	enlargeStringInfo(&buf, VARSIZE(in) /* estimation */);

	fpInit(&v, in);

	printFhirpathItem(&buf, &v, false);

	/* elog(INFO, "printed: %s", buf.data); */


	PG_RETURN_CSTRING(buf.data);
}


static JsonbValue
*getKey(char *key, JsonbValue *jbv){
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


static long
recursive_fhirpath_extract(JsonbInState *result, JsonbValue *jbv, FhirpathItem *path_item)
{

	char *key;
	long num_results = 0;

	JsonbValue *next_v = NULL;
	FhirpathItem next_item;

	JsonbIterator *array_it;
	JsonbValue	array_value;
	int next_it;

	check_stack_depth();

	switch(path_item->type)
	{

	case fpOr:
		/* elog(INFO, "extract fppipe"); */
		fpGetLeftArg(path_item, &next_item);
		num_results = recursive_fhirpath_extract(result, jbv, &next_item);

		if(num_results == 0){
			fpGetRightArg(path_item, &next_item);
			num_results += recursive_fhirpath_extract(result, jbv, &next_item);
		}

		break;
	case fpPipe:
		/* elog(INFO, "extract fppipe"); */
		fpGetLeftArg(path_item, &next_item);
		num_results = recursive_fhirpath_extract(result, jbv, &next_item);

		fpGetRightArg(path_item, &next_item);
		num_results += recursive_fhirpath_extract(result, jbv, &next_item);

		break;
	case fpEqual:
		fpGetLeftArg(path_item, &next_item);
		key = fpGetString(&next_item, NULL);
		next_v = getKey(key, jbv);

		fpGetRightArg(path_item, &next_item);

		if(next_v != NULL &&  checkScalarEquality(&next_item, next_v)){
			if (fpGetNext(path_item, &next_item)) {
				num_results = recursive_fhirpath_extract(result, jbv, &next_item);
			} else {
				result->res = pushJsonbValue(&result->parseState, WJB_ELEM, jbv);
				num_results += 1;
			}
		}
		break;
	case fpResourceType:
		key = fpGetString(path_item, NULL);
		next_v = getKey("resourceType", jbv);
		/* elog(INFO, "fpResourceType: %s, %s",  key, next_v->val.string.val); */
		if(next_v != NULL && checkScalarEquality(path_item, next_v)){
			if (fpGetNext(path_item, &next_item)) {
				num_results = recursive_fhirpath_extract(result, jbv, &next_item);
			}
		}
		break;
	case fpKey:
		key = fpGetString(path_item, NULL);
		next_v = getKey(key, jbv);

		/* elog(INFO, "got key: %s, %d", key, next_v); *\/ */

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
								num_results += recursive_fhirpath_extract(result, &array_value, &next_item);
							} else {
								result->res = pushJsonbValue(&result->parseState, WJB_ELEM, &array_value);
								num_results += 1;
							}
						}
					}
				}
				else if(next_it == WJB_BEGIN_OBJECT){
					if(fpGetNext(path_item, &next_item)) {
						num_results += recursive_fhirpath_extract(result, next_v, &next_item);
					} else {
						result->res = pushJsonbValue(&result->parseState, WJB_ELEM, next_v);
						num_results += 1;

					}
				}
			} else {
				result->res = pushJsonbValue(&result->parseState, WJB_ELEM, next_v);
				num_results += 1;
			}

		}
		break;
	default:
		elog(INFO, "TODO extract");
	}

	/* elog(INFO, "num results %lu", num_results); */
	return num_results;
}

void
initJsonbValue(JsonbValue *jbv, Jsonb *jb) {
	jbv->type = jbvBinary;
	jbv->val.binary.data = &jb->root;
	jbv->val.binary.len = VARSIZE_ANY_EXHDR(jb);
}

PG_FUNCTION_INFO_V1(fhirpath_extract);
Datum
fhirpath_extract(PG_FUNCTION_ARGS)
{

	Jsonb       *jb = PG_GETARG_JSONB(0);
	Fhirpath	*fp_in = PG_GETARG_FHIRPATH(1);

	/* init fhirpath from in disck */
	FhirpathItem		fp;
	fpInit(&fp, fp_in);

	/* init jsonbvalue from in disck */
	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	/* init accumulator */
	JsonbInState result;
	memset(&result, 0, sizeof(JsonbInState));
	result.res = pushJsonbValue(&result.parseState, WJB_BEGIN_ARRAY, NULL);

	long num_results = recursive_fhirpath_extract(&result, &jbv, &fp);

	result.res = pushJsonbValue(&result.parseState, WJB_END_ARRAY, NULL);
	if(num_results > 0){
		PG_RETURN_POINTER(JsonbValueToJsonb(result.res));
	} else {
		PG_RETURN_NULL();
	}

}

static long
recursive_fhirpath_values(JsonbInState *result, JsonbValue *jbv)
{

	JsonbIterator *array_it;
	JsonbValue	array_value;
	int num_results = 0;
	int next_it;

	if(jbv->type == jbvBinary) {

		array_it = JsonbIteratorInit((JsonbContainer *) jbv->val.binary.data);
		next_it = JsonbIteratorNext(&array_it, &array_value, true);

		if(next_it == WJB_BEGIN_ARRAY || next_it == WJB_BEGIN_OBJECT){
			while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
				if(next_it == WJB_ELEM || next_it == WJB_VALUE){
					num_results += recursive_fhirpath_values(result, &array_value);
				}
			}
		}
	} else {
		result->res = pushJsonbValue(&result->parseState, WJB_ELEM, jbv);
		num_results += 1;
	}

	return num_results;
}


PG_FUNCTION_INFO_V1(fhirpath_values);
Datum
fhirpath_values(PG_FUNCTION_ARGS)
{

	Jsonb       *jb = PG_GETARG_JSONB(0);

	/* init jsonbvalue from in disck */
	JsonbValue	jbv;
	initJsonbValue(&jbv, jb);

	/* init accumulator */
	JsonbInState result;
	memset(&result, 0, sizeof(JsonbInState));
	result.res = pushJsonbValue(&result.parseState, WJB_BEGIN_ARRAY, NULL);

	long num_results = recursive_fhirpath_values(&result, &jbv);

	result.res = pushJsonbValue(&result.parseState, WJB_END_ARRAY, NULL);
	if(num_results > 0){
		PG_RETURN_POINTER(JsonbValueToJsonb(result.res));
	} else {
		PG_RETURN_NULL();
	}
}
