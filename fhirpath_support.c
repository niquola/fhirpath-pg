#include "postgres.h"

#include "fhirpath.h"

#define read_byte(v, b, p) do {		\
	(v) = *(uint8*)((b) + (p));		\
	(p) += 1;						\
} while(0)							\

#define read_int32(v, b, p) do {	\
	(v) = *(uint32*)((b) + (p));		\
	(p) += sizeof(int32);			\
} while(0)							\

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
