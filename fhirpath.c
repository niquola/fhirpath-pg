#include "postgres.h"
#include "miscadmin.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/json.h"
#include "fhirpath.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

void
elogFhirparse(FhirpathParseItem *fhirpath)
{

	elog(INFO, "DEBUG!!!!");
	switch(fhirpath->type) {
	case fpKey:
		elog(INFO, "key");
		break;
	case fpNull:
		elog(INFO, "null");
		break;
	case fpString:
		elog(INFO, "string");
		break;
	case fpNode:
		elog(INFO, "node");
		break;
	default:
		elog(INFO, "%d", fhirpath->type);
	}

}

static int
flattenFhirpathParseItem(StringInfo buf, FhirpathParseItem *item)
{
	int32	pos = buf->len - VARHDRSZ; /* position from begining of fhirpath data */
	int32	chld, next;

	check_stack_depth();

	appendStringInfoChar(buf, (char)(item->type));
	alignStringInfoInt(buf);

	next = (item->next) ? buf->len : 0;
	appendBinaryStringInfo(buf, (char*)&next /* fake value */, sizeof(next));

	switch(item->type) {
	case fpNull:
		elog(INFO, "null");
		break;
	case fpKey:
	case fpString:
		elog(INFO, "string: %s [%d]", item->string.val, item->string.len);
		appendBinaryStringInfo(buf, (char*)&item->string.len, sizeof(item->string.len));
		appendBinaryStringInfo(buf, item->string.val, item->string.len);
		appendStringInfoChar(buf, '\0');
		break;
	case fpNode:
		elog(INFO, "node");
		break;
	default:
		elog(INFO, "%d", item->type);
	}

	if (item->next)
		*(int32*)(buf->data + next) = flattenFhirpathParseItem(buf, item->next);

	return  pos;
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
	enlargeStringInfo(&buf, 10 * len /* estimation */);

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

static void
printFhirpathItem(StringInfo buf, FhirpathItem *v, bool inKey)
{
	FhirpathItem	elem;
	bool		first = true;

	check_stack_depth();

	switch(v->type)
	{
		case fpNull:
			appendStringInfoString(buf, "null");
			break;
		case fpKey:
			if (inKey)
				appendStringInfoChar(buf, '-');
			/* follow next */
		case fpString:
			appendStringInfoChar(buf, fpGetString(v, NULL));
			break;
		default:
			elog(ERROR, "Unknown FhirpathItem type: %d", v->type);
	}

	if (fpGetNext(v, &elem))
		printFhirpathItem(buf, &elem, true);
}


PG_FUNCTION_INFO_V1(fhirpath_out);
Datum
fhirpath_out(PG_FUNCTION_ARGS)
{

	Fhirpath			*in = PG_GETARG_FHIRPATH(0);
	StringInfoData	buf;
	FhirpathItem		v;

	initStringInfo(&buf);
	enlargeStringInfo(&buf, VARSIZE(in) /* estimation */);

	fpInit(&v, in);
	printFhirpathItem(&buf, &v, false);

	elog(INFO, "%s", buf.data);
	PG_RETURN_CSTRING(buf.data);
}

