#include "postgres.h"
#include "miscadmin.h"
#include "fhirpath.h"

#define read_byte(v, b, p) do {		\
	(v) = *(uint8*)((b) + (p));		\
	(p) += 1;						\
} while(0)							\

#define read_int32(v, b, p) do {	\
	(v) = *(uint32*)((b) + (p));		\
	(p) += sizeof(int32);			\
} while(0)							\


void dumpit(char *buf, int32 len);

void
dumpit(char *buf, int32 len) {
	FILE* f = fopen("/tmp/dump","wb");
	if(f)
		fwrite(buf,1, len,f); 
	fclose(f);
}

/* This function passed parser AST create binary string */
/* - pack fhirpath into linear memory (storage representation) */

int
serializeFhirpathParseItem(StringInfo buf, FhirpathParseItem *item)
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
		/* elog(INFO, "null"); */
		break;
	case fpNode:
		/* elog(INFO, "node"); */
		break;
	default:
		elog(INFO, "unknown: %d", item->type);
	}

	if (item->next)
		*(int32*)(buf->data + next) =serializeFhirpathParseItem(buf, item->next);

	return  pos;
}

void
alignStringInfoInt(StringInfo buf)
{
	switch(INTALIGN(buf->len) - buf->len)
	{
		case 3:
			appendStringInfoCharMacro(buf, 0);
		case 2:
			appendStringInfoCharMacro(buf, 0);
		case 1:
			appendStringInfoCharMacro(buf, 0);
		default:
			break;
	}
}

void
fpInit(FhirpathItem *v, Fhirpath *js)
{
	fpInitByBuffer(v, VARDATA(js), 0);
}

void
fpInitByBuffer(FhirpathItem *v, char *base, int32 pos)
{
	v->base = base;
	read_byte(v->type, base, pos);

	switch(INTALIGN(pos) - pos)
	{
		case 3: pos++;
		case 2: pos++;
		case 1: pos++;
		default: break;
	}

	read_int32(v->nextPos, base, pos);

	switch(v->type)
	{
		case fpNull:
			break;
		case fpKey:
		case fpString:
			read_int32(v->value.datalen, base, pos);
			v->value.data = base + pos;
			break;
		default:
			abort();
			elog(ERROR, "Unknown type: %d", v->type);
	}
}

void
fpGetArg(FhirpathItem *v, FhirpathItem *a)
{
	fpInitByBuffer(a, v->base, v->arg);
}

bool
fpGetNext(FhirpathItem *v, FhirpathItem *a)
{
	if (v->nextPos > 0)
	{
		if (a)
			fpInitByBuffer(a, v->base, v->nextPos);
		return true;
	}

	return false;
}

void
fpGetLeftArg(FhirpathItem *v, FhirpathItem *a)
{
	fpInitByBuffer(a, v->base, v->args.left);
}

void
fpGetRightArg(FhirpathItem *v, FhirpathItem *a)
{
	fpInitByBuffer(a, v->base, v->args.right);
}

bool
fpGetBool(FhirpathItem *v)
{
	return (bool)*v->value.data;
}

Numeric
fpGetNumeric(FhirpathItem *v)
{
	return (Numeric)v->value.data;
}

int32
fpGetIsType(FhirpathItem *v)
{
	return  (int32)*v->value.data;
}

char*
fpGetString(FhirpathItem *v, int32 *len)
{

	Assert(
		v->type == fpKey ||
		v->type == fpString
		);
	if (len)
		*len = v->value.datalen;
	return v->value.data;
}

void
fpIterateInit(FhirpathItem *v)
{
	v->array.current = 0;
}

bool
fpIterateArray(FhirpathItem *v, FhirpathItem *e)
{
	if (v->array.current < v->array.nelems)
	{
		fpInitByBuffer(e, v->base, v->array.arrayPtr[v->array.current]);
		v->array.current++;
		return true;
	}
	else
	{
		return false;
	}
}

/* This function passed parser AST create binary string */
/* - pack fhirpath into linear memory (storage representation) */

void
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
