#include "node.hpp"
#include <stdio.h>
#include <stdlib.h>

struct Node *new_node(char *str) {
  Node *node = (struct Node *)malloc(sizeof(struct Node));
  node->name = str;
  node->parent = nullptr;
  node->child = nullptr;
  node->lsibling = node;
  node->rsibling = node;
  return node;
}

void delete_node(struct Node *node) {
  if (node != nullptr)
    free(node);
}

void add_child(struct Node *node, struct Node *child) {
  child->parent = node;
  if (node->child == nullptr) {
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
    printf("  ");
  printf("%s\n", node->name);
  ident++;
  struct Node *child = node->child;
  if (child != nullptr) {
    do {
      print_tree(child, ident);
      child = child->rsibling;
    } while (child != node->child);
  }
}
