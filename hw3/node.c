#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node *new_node(int type) {
  struct Node *node = (struct Node *)malloc(sizeof(struct Node));
  node->node_type = type;
  node->content = NULL;
  node->parent = NULL;
  node->child = NULL;
  node->lsibling = node;
  node->rsibling = node;
  return node;
}

void delete_node(struct Node *node) {
  if (node->content != NULL)
    free(node->content);
  free(node);
}

void add_child(struct Node *node, struct Node *child) {
  child->parent = node;
  if (node->child == NULL) {
    node->child = child;
  } else {
    child->lsibling = node->child->lsibling;
    child->rsibling = node->child;
    node->child->lsibling->rsibling = child;
    node->child->lsibling = child;
  }
};

void print_tree(struct Node *node, int ident_len) {
  char *ident = malloc(1000 * sizeof(char));
  for (int i = 0; i < ident_len; i++)
    strcat(ident, "  ");

  switch (node->node_type) {
  case ARGS:
    printf("%s ARGS\n", ident);
  case DECLS:
    printf("%s DECLS\n", ident);
  case FACTOR:
    printf("%s FACTOR\n", ident);
  case PROG:
    printf("%s PROGRAM\n", ident);
  case STMT:
    printf("%s STMT\n", ident);
  case TAIL:
    printf("%s TAIL\n", ident);
  case TERM:
    printf("%s TERM\n", ident);
  case TYPE:
    printf("%s TYPE\n", ident);
  case VARIABLE:
    printf("%s VARIABLE\n", ident);
  case ADDOP:
    printf("%s ADDOP\n", ident);
  case MULOP:
    printf("%s MULOP\n", ident);
  case RELOP:
    printf("%s RELOP\n", ident);
  case OPT_VAR:
    printf("%s OPT_VAR\n", ident);
  case OPT_STMTS:
    printf("%s OPT_STMTS\n", ident);
  case ID_LIST:
    printf("%s ID_LIST\n", ident);
  case EXPR_LIST:
    printf("%s EXPR_LIST\n", ident);
  case STMT_LIST:
    printf("%s STMT_LIST\n", ident);
  case PARA_LIST:
    printf("%s PARA_LIST\n", ident);
  case SUBPROG_DECL:
    printf("%s SUBPROG_DECL\n", ident);
  case SUBPROG_DECLS:
    printf("%s SUBPROG_DECLS\n", ident);
  case SUBPROG_HEAD:
    printf("%s SUBPROG_HEAD\n", ident);
  case COMPOUND_STMT:
    printf("%s COMPOUND_STMT\n", ident);
  case PROC_STMT:
    printf("%s PROC_STMT\n", ident);
  case EXPR:
    printf("%s EXPR\n", ident);
  case SIMPLE_EXPR:
    printf("%s SIMPLE_EXPR\n", ident);
  case BOOL_EXPR:
    printf("%s BOOL_EXPR\n", ident);
  case TYPE_INT:
    printf("%s TYPE_INT\n", ident);
  case TYPE_REAL:
    printf("%s TYPE_REAL\n", ident);
  case TYPE_STRING:
    printf("%s TYPE_STRING\n", ident);
  case TYPE_ARRAY:
    printf("%s TYPE_ARRAY\n", ident);
  case VAR_DECL:
    printf("%s VAR_DECL\n", ident);
  }

  ident_len++;

  struct Node *child = node->child;
  if (child != NULL) {
    do {
      print_tree(child, ident_len);
      child = child->rsibling;
    } while (child != node->child);
  }
}
