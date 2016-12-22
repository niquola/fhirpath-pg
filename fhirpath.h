#ifndef __FHIRPATH_H__
#define __FHIRPATH_H__

#include "access/gin.h"
#include "fmgr.h"
#include "utils/numeric.h"
#include "utils/jsonb.h"

typedef struct
{
	int32	vl_len_;	/* varlena header (do not touch directly!) */
} Fhirpath;

#define DatumGetFhirpathP(d)	((JsQuery*)DatumGetPointer(PG_DETOAST_DATUM(d)))
#define PG_GETARG_FHIRPATH(x)	DatumGetJsFhirpathP(PG_GETARG_DATUM(x))
#define PG_RETURN_FHIRPATH(p)	PG_RETURN_POINTER(p)


typedef enum FhirpathItemType {
	fpNull,
	fpKey,
	fpString,
	fpNode
} FhirpathItemType;

typedef struct FhirpathItem {
	FhirpathItemType	type;
} FhirpathItem;

typedef struct FhirpathParseItem FhirpathParseItem;

struct FhirpathParseItem {
	FhirpathItemType	type;
	FhirpathParseItem	*next; /* next in path */

	union {
		struct {
			FhirpathParseItem	*left;
			FhirpathParseItem	*right;
		} args;

		FhirpathParseItem	*arg;
		int8		isType; /* jbv* values */

		Numeric		numeric;
		bool		boolean;
		struct {
			uint32      len;
			char        *val; /* could not be not null-terminated */
		} string;

		struct {
			int					nelems;
			FhirpathParseItem	**elems;
		} array;
	};
};

extern FhirpathParseItem* parsefhirpath(const char *str, int len);

#endif
