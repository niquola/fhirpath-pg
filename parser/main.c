#include <ctype.h>
#include <stdio.h>
#include "fhirpath.h"
#include "fhirpath.tab.h"
#include <stdarg.h>
#include <stdlib.h>

void print_ast(path_node *root) {
  printf("node: %s\n", root->ident_str);

  if (root->next) {
    print_ast(root->next);
  }
}

path_node *new_path_node(char *ident, path_node *next)
{
  path_node *a = malloc(sizeof(path_node));

  if (!a) {
    yyerror(NULL, "out of memory");
    exit(1);
  }

  a->ident_str = ident;
  a->next = next;

  return a;
}


void delete_path_node(path_node *root)
{
  if (root->next) {
    delete_path_node(root->next);
  }

  free(root);
}

int main (void)
{
  path_node *result = NULL;

  printf("> ");
  yyparse(&result);

  // Ctrl+D

  printf("got following ast:\n");
  print_ast(result);
  delete_path_node(result);

  return 0;
}

void yyerror(path_node **result, char *s, ...)
{
  va_list ap;
  va_start(ap, s);
  fprintf(stderr, "error: ");
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}
