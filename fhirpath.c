#include "postgres.h"
#include "miscadmin.h"
#include "lib/stringinfo.h"
#include "utils/builtins.h"
#include "utils/json.h"
#include "fhirpath.h"

#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)

PG_MODULE_MAGIC;

static int
flattenFhirpathParseItem(StringInfo buf, FhirpathParseItem *item, bool onlyCurrentInPath)
{
	/* int32	pos = buf->len - VARHDRSZ; /\* position from begining of jsquery data *\/ */
	/* int32	chld, next; */

	/* check_stack_depth(); */

	/* appendStringInfoChar(buf, (char)(item->type)); */
	/* alignStringInfoInt(buf); */

	/* next = (item->next) ? buf->len : 0; */
	/* appendBinaryStringInfo(buf, (char*)&next /\* fake value *\/, sizeof(next)); */
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
	enlargeStringInfo(&buf, 4 * len /* estimation */);

	appendStringInfoSpaces(&buf, VARHDRSZ);

	if (fhirpath != NULL)
	{

		elog(INFO, "Parsed!!!!, %d", fhirpath->type);
		/* flattenFhirpathParseItem(&buf, fhirpath, false); */

		/* res = (Fhirpath*)buf.data; */
		/* SET_VARSIZE(res, buf.len); */

		/* PG_RETURN_FHIRPATH(res); */
	}

	/* PG_RETURN_FHIRPATH("path"); */
	PG_RETURN_FHIRPATH("path");

}


PG_FUNCTION_INFO_V1(fhirpath_out);
Datum
fhirpath_out(PG_FUNCTION_ARGS)
{
	/* Fhirpath			*in = PG_GETARG_FHIRPATH(0); */
	/* StringInfoData	buf; */
	/* FhirpathItem		v; */

	/* initStringInfo(&buf); */
	/* enlargeStringInfo(&buf, VARSIZE(in) /\* estimation *\/);  */

	/* jsqInit(&v, in); */
	/* printFhirpathItem(&buf, &v, false, true); */

	PG_RETURN_CSTRING("ups");
}

