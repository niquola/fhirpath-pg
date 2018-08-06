%option noyywrap nodefault
%{
# include "fhirpath.h"
# include "fhirpath.tab.h"
%}

%%
[a-zA-Z_\-0-9]+       { yylval.str = strdup(yytext); printf("ident '%s'\n", yytext); return IDENT_T; }
\.                    { /* ignore dots for now */ }
[\n\s]                { /* ignore whitespace */ }
<<EOF>>               { return EOF; }
.                     { yyerror(NULL, "Unexpected character %c\n", *yytext); }
%%
