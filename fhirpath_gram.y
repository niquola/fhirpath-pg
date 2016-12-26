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

	 v = makeItemType(fpString);
	 v->string.val = s->val;
	 v->string.len = s->len;
	 /* elog(INFO, "makeItemString %s [%d]", s->val, s->len); */

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

 static FhirpathParseItem*
	 makeItemKey(string *s)
 {
	 FhirpathParseItem *v;

	 /* elog(INFO, "makeItemKey %s [%d]", s->val, s->len); */
	 v = makeItemString(s);
	 v->type = fpKey;

	 return v;
 }

 static FhirpathParseItem*
	 makeResourceType(string *s)
 {
	 FhirpathParseItem *v;

	 v = makeItemType(fpResourceType);
	 v->string.val = s->val;
	 v->string.len = s->len;
	 /* elog(INFO, "makeItemString %s [%d]", s->val, s->len); */

	 return v;
 }

 /* static FhirpathParseItem* */
 /* 	 makeItemArray(FhirpathItemType tp, List *list) */
 /* { */
 /* 	 FhirpathParseItem	*v = makeItemType(tp); */
 /* 	 v->array.nelems = list_length(list); */
 /* 	 /\* elog(INFO, "MakeItemArray: Path lenght %d", list_length(list)); *\/ */

 /* 	 if (v->array.nelems > 0) */
 /* 	 { */
 /* 		 ListCell	*cell; */
 /* 		 int			i = 0; */

 /* 		 v->array.elems = palloc(sizeof(FhirpathParseItem) * v->array.nelems); */

 /* 		 foreach(cell, list) */
 /* 			 v->array.elems[i++] = (FhirpathParseItem*)lfirst(cell); */
 /* 	 } */
 /* 	 else */
 /* 	 { */
 /* 		 v->array.elems = NULL; */
 /* 	 } */

 /* 	 return v; */
 /* } */


 static FhirpathParseItem*
 makeItemOp(FhirpathItemType type, FhirpathParseItem *la, FhirpathParseItem *ra)
 {
	 /* elog(INFO, "binary op %d, %d", la->type, ra->type);  */
	 FhirpathParseItem *v = makeItemType(type);

	 v->args.left = la;
	 v->args.right = ra;

	 return v;
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

%token	<str>		WHERE_P IN_P IS_P OR_P AND_P NOT_P NULL_P TRUE_P
					ARRAY_T FALSE_P NUMERIC_T OBJECT_T
					STRING_T BOOLEAN_T PIPE_P

%token	<str>		STRING_P NUMERIC_P

%type	<value>		result
%type 	<value>		expr
%type	<elems>		path

%type 	<value>		key

%left OR_P 
%left AND_P 
%right NOT_P 
%nonassoc IN_P IS_P WHERE_P
%nonassoc '(' ')'

/* Grammar follows */
%%

result:
	expr							{ *result = $1; } 
	| /* EMPTY */					{ *result = NULL; }
	;

expr:
    path                                { $$ = makeItemList($1); }
	| expr '|' path                     { $$ = makeItemOp(fpPipe, $1, makeItemList($3)); }
    | expr OR_P path                    { $$ = makeItemOp(fpOr, $1, makeItemList($3)); }
    ;

/*
 * key is always a string, not a bool or numeric
 */

key:
    WHERE_P '(' STRING_P '=' STRING_P ')'   { $$ = makeItemOp(fpEqual, makeItemString(&$3), makeItemString(&$5)); }
    | STRING_P		        				{ $$ = makeItemKey(&$1); }
	;

path:
	'.' key							{ $$ = lappend(NIL, $2); }
    | STRING_P '.' key    			{ $$ = lappend(lappend(NIL, makeResourceType(&$1)), $3); }
	| path '.' key   				{ $$ = lappend($1, $3); }
	;

%%

#include "fhirpath_scan.c"
