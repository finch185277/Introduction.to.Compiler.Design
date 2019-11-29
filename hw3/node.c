#include "node.h"
#include <stdio.h>
#include <stdlib.h>

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

void print_tree(struct Node *node, int ident) {
  for (int i = 0; i < ident; i++)
    printf(" ");

  // switch (node->node_type) {
  // case TYPE_INT:
  //   printf("%d\n", node->integer_value);
  // case TYPE_REAL:
  //   printf("%f\n", node->real_value);
  // case TYPE_STRING:
  //   printf("%s\n", node->content);
  // default:
  //   printf("%d\n", node->node_type);
  // }

  printf("%d\n", node->node_type);
  ident++;

  struct Node *child = node->child;
  if (child != NULL) {
    do {
      print_tree(child, ident);
      child = child->rsibling;
    } while (child != node->child);
  }
}
