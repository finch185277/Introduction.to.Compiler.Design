#ifndef __NODE_H__
#define __NODE_H__

enum ntype { INVALID, NODE };

struct Node {
  char *name;
  struct Node *parent;
  struct Node *child;
  struct Node *lsibling;
  struct Node *rsibling;
};

struct Node *new_node(char *str);
void delete_node(struct Node *node);
void add_child(struct Node *node, struct Node *child);
void print_tree(struct Node *node, int ident);

#endif
