%{

#include "fhirpath.h"
#include <stdio.h>

int yylex();

/* struct string is shared between scan and gram */
/* typedef struct string { */
/*     char    *val; */
/*     int     len; */
/*     int     total; */
/* } string; */

%}

%parse-param { path_node **result }

%union {
    char      *str;
    path_node *node;
}

%token  <str>           IDENT_T

%type   <node>          root path
%type   <str>           path_elem

%% /* The grammar follows.  */
root:
                /* empty */          { $$ = NULL; *result = NULL; }
        |       path                 { $$ = $1; *result = $1; printf("parsed root %p\n", $1) }
                ;

path:
                path_elem            { $$ = new_path_node($1, NULL); }
        |       path_elem path       { $$ = new_path_node($1, $2); }
                ;

path_elem:
                IDENT_T              { printf("parsed path_elem: %s\n", $1); $$ = $1; }
                ;
%%
