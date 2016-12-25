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

void *recursive_fhirpath_extract(JsonbInState *result, JsonbValue *jb, FhirpathItem *path_item);


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


void
*recursive_fhirpath_extract(JsonbInState *result, JsonbValue *jbv, FhirpathItem *path_item)
{

	char *key;

	JsonbValue	key_v;
	JsonbValue *next_v = NULL;
	FhirpathItem next_item;

	JsonbIterator *array_it;
	JsonbValue	array_value;
	int next_it;

	check_stack_depth();

	switch(path_item->type)
	{
	case fpKey:
		key = fpGetString(path_item, NULL);
		/* elog(INFO, "get key: %s", key); */

		key_v.type = jbvString;
		key_v.val.string.len = strlen(key);
		key_v.val.string.val = key;
		next_v = findJsonbValueFromContainer((JsonbContainer *) jbv->val.binary.data , JB_FOBJECT, &key_v);
		if(next_v){
			Jsonb *out = JsonbValueToJsonb(next_v);
			/* elog(INFO, "Next: %s", JsonbToCString(NULL, &out->root, 0)); */
			if(next_v->type == jbvBinary){
				elog(INFO, "binary");
			}
		}

		break;
	default:
		elog(ERROR, "TODO extract");
	}

	if (next_v && fpGetNext(path_item, &next_item)) {

		if(next_v->type == jbvBinary){

		  array_it = JsonbIteratorInit((JsonbContainer *) next_v->val.binary.data);
		  next_it = JsonbIteratorNext(&array_it, &array_value, true);

		  if(next_it == WJB_BEGIN_ARRAY){
			  /* elog(INFO, "We are in array"); */
			  while ((next_it = JsonbIteratorNext(&array_it, &array_value, true)) != WJB_DONE){
				  if(next_it == WJB_ELEM){
					  recursive_fhirpath_extract(result, &array_value, &next_item);
				  }
			  }
		  }
		  else if(next_it == WJB_BEGIN_OBJECT){
			  /* elog(INFO, "We are in object"); */
			  recursive_fhirpath_extract(result, next_v, &next_item);
		  }
		}

	} else if (next_v) {
		Jsonb *out = JsonbValueToJsonb(next_v);
		/* elog(INFO, "Add to result: %s", JsonbToCString(NULL, &out->root, 0)); */
		/* elog(INFO, "Type: %d", next_v->type); */
		result->res = pushJsonbValue(&result->parseState, WJB_ELEM, next_v);
	}
	return NULL;
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
	jbv.type = jbvBinary;
	jbv.val.binary.data = &jb->root;
	jbv.val.binary.len = VARSIZE_ANY_EXHDR(jb);

	/* init accumulator */
	JsonbInState result;
	memset(&result, 0, sizeof(JsonbInState));
	result.res = pushJsonbValue(&result.parseState, WJB_BEGIN_ARRAY, NULL);

	recursive_fhirpath_extract(&result, &jbv, &fp);

	result.res = pushJsonbValue(&result.parseState, WJB_END_ARRAY, NULL);

	PG_RETURN_POINTER(JsonbValueToJsonb(result.res));
}
