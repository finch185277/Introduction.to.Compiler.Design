#include "node.h"
#include <stdio.h>
#include <stdlib.h>

struct Node *new_node(int type) {
  struct Node *node = (struct Node *)malloc(sizeof(struct Node));
  node->node_type = type;
  node->node_str = NULL;
  node->parent = NULL;
  node->child = NULL;
  node->lsibling = node;
  node->rsibling = node;
  return node;
}

void delete_node(struct Node *node) {
  if (node->node_str != NULL)
    free(node->node_str);
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

void print_tree(struct Node *node, int ident) {
  for (int i = 0; i < ident; i++)
    printf(" ");

  switch (node->node_type) {
  case TOKEN_INTEGER:
    printf("%d\n", node->integer_value);
  case TOKEN_REAL:
    printf("%f\n", node->real_value);
  case TOKEN_STRING:
    printf("%s\n", node->node_str);
  case TOKEN_PLUS:
    printf("+\n");
  case TOKEN_MINUS:
    printf("-\n");
  case TOKEN_STAR:
    printf("*\n");
  case TOKEN_SLASH:
    printf("/\n");
  case TOKEN_GT:
    printf(">\n");
  case TOKEN_GE:
    printf(">=\n");
  case TOKEN_LT:
    printf("<\n");
  case TOKEN_LE:
    printf("<=\n");
  case TOKEN_EQUAL:
    printf("=\n");
  case TOKEN_notEQUAL:
    printf("!=\n");
  }
  ident++;

  struct Node *child = node->child;
  if (child != NULL) {
    do {
      print_tree(child, ident);
      child = child->rsibling;
    } while (child != node->child);
  }
}
