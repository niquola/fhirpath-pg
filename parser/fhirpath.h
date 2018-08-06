#ifndef FHIRPATH_H
#define FHIRPATH_H

typedef struct path_node path_node;

struct path_node {
  char *ident_str;
  path_node *next;
};

int yyparse(path_node **result);

void yyerror(path_node **result, char *s, ...);

path_node *new_path_node(char *ident, path_node *next);

void delete_path_node(path_node *root);

#endif
