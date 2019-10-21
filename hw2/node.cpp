#include "node.hpp"

struct Node *new_node(std::string str) {
  Node *node = new Node;
  node->name = str;
  node->parent = nullptr;
  node->child = nullptr;
  node->lsibling = node;
  node->rsibling = node;
  return node;
}

void delete_node(struct Node *node) {
  if (node != nullptr)
    delete (node);
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
    std::cout << "  ";
  std::cout << node->name << '\n';
  ident++;
  struct Node *child = node->child;
  if (child != nullptr) {
    do {
      print_tree(child, ident);
      child = child->rsibling;
    } while (child != node->child);
  }
}
