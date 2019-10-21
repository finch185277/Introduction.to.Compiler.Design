#ifndef __NODE_HPP__
#define __NODE_HPP__

#include <cstring>
#include <iostream>

enum ntype { INVALID, NODE };

struct Node {
  std::string name;
  struct Node *parent;
  struct Node *child;
  struct Node *lsibling;
  struct Node *rsibling;
};

struct Node *new_node(std::string str);
void delete_node(struct Node *node);
void add_child(struct Node *node, struct Node *child);
void print_tree(struct Node *node, int ident);

#endif
