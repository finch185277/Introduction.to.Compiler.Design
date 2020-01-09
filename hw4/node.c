#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node *new_node(int type) {
  struct Node *node = (struct Node *)malloc(sizeof(struct Node));
  node->node_type = type;
  node->parent = NULL;
  node->child = NULL;
  node->lsibling = node;
  node->rsibling = node;
  node->content = NULL;
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
    // right-most node would point to new node, and new node would point back to
    // the child, so new node will be right sibling of original right-most node
    child->lsibling = node->child->lsibling;
    child->rsibling = node->child;
    node->child->lsibling->rsibling = child;
    node->child->lsibling = child;
  }
};

void print_type(struct Node *node) {
  switch (node->node_type) {
  case TOKEN_INT:
    printf("TOKEN_INT\n");
    break;
  case TOKEN_REAL:
    printf("TOKEN_REAL\n");
    break;
  case TOKEN_STRING:
    printf("TOKEN_STRING\n");
    break;
  case TOKEN_IDENTIFIER:
    printf("TOKEN_IDENTIFIER\n");
    break;
  case TOKEN_PLUS:
    printf("TOKEN_PLUS\n");
    break;
  case TOKEN_MINUS:
    printf("TOKEN_MINUS\n");
    break;
  case TOKEN_SLASH:
    printf("TOKEN_SLASH\n");
    break;
  case TOKEN_STAR:
    printf("TOKEN_STAR\n");
    break;
  case ARGS:
    printf("ARGS\n");
    break;
  case DECLS:
    printf("DECLS\n");
    break;
  case FACTOR:
    printf("FACTOR\n");
    break;
  case PROG:
    printf("PROG\n");
    break;
  case STMT:
    printf("STMT\n");
    break;
  case TAIL:
    printf("TAIL\n");
    break;
  case TERM:
    printf("TERM\n");
    break;
  case TYPE:
    printf("TYPE\n");
    break;
  case VARIABLE:
    printf("VARIABLE\n");
    break;
  case LAMBDA:
    printf("LAMBDA\n");
    break;
  case ADDOP:
    printf("ADDOP\n");
    break;
  case MULOP:
    printf("MULOP\n");
    break;
  case RELOP:
    printf("RELOP\n");
    break;
  case OPT_VAR:
    printf("OPT_VAR\n");
    break;
  case OPT_STMTS:
    printf("OPT_STMTS\n");
    break;
  case ID_LIST:
    printf("ID_LIST\n");
    break;
  case EXPR_LIST:
    printf("EXPR_LIST\n");
    break;
  case STMT_LIST:
    printf("STMT_LIST\n");
    break;
  case PARA_LIST:
    printf("PARA_LIST\n");
    break;
  case SUBPROG_DECL:
    printf("SUBPROG_DECL\n");
    break;
  case SUBPROG_DECLS:
    printf("SUBPROG_DECLS\n");
    break;
  case SUBPROG_HEAD:
    printf("SUBPROG_HEAD\n");
    break;
  case COMPOUND_STMT:
    printf("COMPOUND_STMT\n");
    break;
  case PROC_STMT:
    printf("PROC_STMT\n");
    break;
  case EXPR:
    printf("EXPR\n");
    break;
  case SIMPLE_EXPR:
    printf("SIMPLE_EXPR\n");
    break;
  case BOOL_EXPR:
    printf("BOOL_EXPR\n");
    break;
  case TYPE_INT:
    printf("TYPE_INT\n");
    break;
  case TYPE_REAL:
    printf("TYPE_REAL\n");
    break;
  case TYPE_STRING:
    printf("TYPE_STRING\n");
    break;
  case TYPE_ARRAY:
    printf("TYPE_ARRAY\n");
    break;
  case HEAD_FUNCTION:
    printf("HEAD_FUNCTION\n");
    break;
  case HEAD_PROCEDURE:
    printf("HEAD_PROCEDURE\n");
    break;
  }
}

void print_tree(struct Node *node, int ident_len) {
  char *ident = malloc(1000 * sizeof(char));
  for (int i = 0; i < ident_len; i++)
    strcat(ident, "  ");

  switch (node->node_type) {
  case TOKEN_INT:
    printf("%s %d\n", ident, node->integer_value);
    break;
  case TOKEN_REAL:
    printf("%s %lf\n", ident, node->real_value);
    break;
  case TOKEN_STRING:
    printf("%s %s\n", ident, node->content);
    break;
  case TOKEN_IDENTIFIER:
    printf("%s %s\n", ident, node->content);
    break;
  case TOKEN_PLUS:
    printf("%s +\n", ident);
    break;
  case TOKEN_MINUS:
    printf("%s -\n", ident);
    break;
  case TOKEN_SLASH:
    printf("%s /\n", ident);
    break;
  case TOKEN_STAR:
    printf("%s *\n", ident);
    break;
  case PROG:
    printf("%s PROGRAM\n", ident);
    break;
  case SUBPROG_DECL:
    printf("%s SUBPROG_DECL\n", ident);
    break;
  case SUBPROG_HEAD:
    printf("%s SUBPROG_HEAD\n", ident);
    break;
  case PARA_LIST:
    printf("%s PARA_LIST\n", ident);
    break;
  case OPT_VAR:
    printf("%s PARA\n", ident);
    break;
  case TYPE_INT:
    printf("%s TYPE_INT\n", ident);
    break;
  case TYPE_REAL:
    printf("%s TYPE_REAL\n", ident);
    break;
  case TYPE_STRING:
    printf("%s TYPE_STRING\n", ident);
    break;
  case TYPE_ARRAY:
    printf("%s ARRAY\n", ident);
    break;
  case ID_LIST:
    if (node->parent->node_type != PARA_LIST)
      printf("%s VAR_DECL\n", ident);
    break;
  case STMT_LIST:
    printf("%s STMT_LIST\n", ident);
    break;
  case COMPOUND_STMT:
    printf("%s COMPOUND_STMT\n", ident);
    break;
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
