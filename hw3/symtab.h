#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

#define NAME_SIZE 100
#define TAB_SIZE 100
#define LIST_SIZE 100

struct Entry {
  char name[NAME_SIZE];
  int scope;
  int type;
  int return_type;
  struct Node *parameter;
  int dim;
  struct Node *range;
};

struct Table {
  int next_entry_idx;
  int is_valid;
  struct Entry table[TAB_SIZE];
};

struct Entry *find_entry(char *name);
void add_entry(char *name, int scope, int type, int return_type,
               struct Node *parameter, int dim, struct Node *range);
void delete_table();
void print_entry_type(int type);
void print_table();
void traverse_decls(struct Node *node);
void traverse_prog(struct Node *node);
int semantic_check(struct Node *node);

#endif
