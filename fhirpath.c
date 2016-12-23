#include "postgres.h"
#include "miscadmin.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/json.h"
#include "fhirpath.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

/* This function passed parser AST create binary string */
/* - pack fhirpath into linear memory (storage representation) */

static int
flattenFhirpathParseItem(StringInfo buf, FhirpathParseItem *item)
{
	int32	pos = buf->len - VARHDRSZ; /* position from begining of fhirpath data */
	int32	next = 0;

	/* we recursive check stack */
	check_stack_depth();

	/* write item type */
	appendStringInfoChar(buf, (char)(item->type));

	/* align ???*/
	alignStringInfoInt(buf);

	next = (item->next) ? buf->len : 0;
	/*write next field */
	appendBinaryStringInfo(buf, (char*)&next /* fake value */, sizeof(next));

	switch(item->type) {
	case fpKey:
	case fpString:
		/* elog(INFO, "pack: %s [%d]", item->string.val, item->string.len); */
		/* write length field*/
		appendBinaryStringInfo(buf, (char*)&item->string.len, sizeof(item->string.len));
		/* write string content */
		appendBinaryStringInfo(buf, item->string.val, item->string.len);
		appendStringInfoChar(buf, '\0');
	case fpNull:
		elog(INFO, "null");
		break;
	case fpNode:
		elog(INFO, "node");
		break;
	default:
		elog(INFO, "unknown: %d", item->type);
	}

	if (item->next)
		*(int32*)(buf->data + next) = flattenFhirpathParseItem(buf, item->next);

	return  pos;
}

static void
printFhirpathItem(StringInfo buf, FhirpathItem *v, bool inKey)
{
	FhirpathItem	elem;

	check_stack_depth();

	switch(v->type)
	{
	case fpNull:
		appendStringInfoString(buf, "null");
		break;
	case fpKey:
		if (inKey)
			appendStringInfoChar(buf, '.');
		/* follow next */
	case fpString:
		/* escape_json(buf, fpGetString(v, NULL)); */
		appendStringInfoString(buf, fpGetString(v, NULL));
		break;
	default:
		elog(ERROR, "Unknown FhirpathItem type: %d", v->type);
	}

	if (fpGetNext(v, &elem))
		printFhirpathItem(buf, &elem, true);
}

void
dumpit(char *buf, int32 len) {
	FILE* f = fopen("/tmp/dump","wb");
	if(f)
	fwrite(buf,1, len,f); 
	fclose(f);
}

PG_FUNCTION_INFO_V1(fhirpath_in);
Datum
fhirpath_in(PG_FUNCTION_ARGS)
{
	char				*in = PG_GETARG_CSTRING(0);
	int32				len = strlen(in);
	FhirpathParseItem	*fhirpath = parsefhirpath(in, len);
	Fhirpath    		*res;
	StringInfoData		buf;

	initStringInfo(&buf);
	enlargeStringInfo(&buf, len /* estimation */);

	appendStringInfoSpaces(&buf, VARHDRSZ);

	if (fhirpath != NULL)
	{
		flattenFhirpathParseItem(&buf, fhirpath);

		res = (Fhirpath*)buf.data;

		SET_VARSIZE(res, buf.len);
		PG_RETURN_FHIRPATH(res);
	}

	PG_RETURN_NULL();

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

