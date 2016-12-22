%{
#include "postgres.h"

#include "fmgr.h"
#include "utils/builtins.h"

#include "fhirpath.h"

/*
 * Bison doesn't allocate anything that needs to live across parser calls,
 * so we can easily have it use palloc instead of malloc.  This prevents
 * memory leaks if we error out during parsing.  Note this only works with
 * bison >= 2.0.  However, in bison 1.875 the default is to use alloca()
 * if possible, so there's not really much problem anyhow, at least if
 * you're building with gcc.
 */
#define YYMALLOC palloc
#define YYFREE   pfree

/* Avoid exit() on fatal scanner errors (a bit ugly -- see yy_fatal_error) */
#undef fprintf
#define fprintf(file, fmt, msg)  fprintf_to_ereport(fmt, msg)

static void
fprintf_to_ereport(const char *fmt, const char *msg)
{
	ereport(ERROR, (errmsg_internal("%s", msg)));
}

/* struct string is shared between scan and gram */
typedef struct string {
	char 	*val;
	int  	len;
	int		total;
} string;
#include <fhirpath_gram.h>

/* flex 2.5.4 doesn't bother with a decl for this */
int fhirpath_yylex(YYSTYPE * yylval_param);
void fhirpath_yyerror(FhirpathParseItem **result, const char *message);

 static FhirpathParseItem*
	 makeItemType(int type)
 {
	 FhirpathParseItem* v = palloc(sizeof(*v));

	 v->type = type;
	 v->next = NULL;

	 return v;
 }

 static FhirpathParseItem*
	 makeItemString(string *s)
 {
	 FhirpathParseItem *v;

	 if (s == NULL)
	 {
		 v = makeItemType(fpNull);
	 }
	 else
	 {
		 v = makeItemType(fpString);
		 v->string.val = s->val;
		 v->string.len = s->len;
	 }

	 return v;
 }

 static FhirpathParseItem*
	 makeItemList(List *list)
 {
	 FhirpathParseItem	*head, *end;
	 ListCell	*cell;

	 head = end = (FhirpathParseItem*)linitial(list);

	 foreach(cell, list)
	 {
		 FhirpathParseItem	*c = (FhirpathParseItem*)lfirst(cell);

		 if (c == head)
			 continue;

		 end->next = c;
		 end = c;
	 }

	 return head;
 }

%}

/* BISON Declarations */
%pure-parser
%expect 0
%name-prefix="fhirpath_yy"
%error-verbose
/* %parse-param {FhirpathParseItem **result} */
%parse-param {FhirpathParseItem **result}

%union {
	string 				str;
	List				*elems; /* list of FhirpathParseItem */

	FhirpathParseItem	*value;
}

%token	<str>		IN_P IS_P OR_P AND_P NOT_P NULL_P TRUE_P
					ARRAY_T FALSE_P NUMERIC_T OBJECT_T
					STRING_T BOOLEAN_T

%token	<str>		STRING_P NUMERIC_P

%type	<value>		result
%type	<value>		expr

%type	<elems>		path

%type 	<value>		key key_any

%left OR_P 
%left AND_P 
%right NOT_P 
%nonassoc IN_P IS_P 
%nonassoc '(' ')'

/* Grammar follows */
%%

result:
	expr							{ *result = $1; } 
	| /* EMPTY */					{ *result = NULL; }
	;

expr:
	path            				{ $$ = makeItemList($1); }
    ;
/*
 * key is always a string, not a bool or numeric
 */
key:
	STRING_P						{ $$ = makeItemType(fpNode); }
	;

/*
 * NOT keyword needs separate processing 
 */
key_any:
	key								{ $$ = $$; }
	;

path:
	key								{ $$ = lappend(NIL, $1); }
	| path '.' key_any				{ $$ = lappend($1, $3); }
	;

%%

#include "fhirpath_scan.c"
