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
};

struct Table {
  int next_entry_idx;
  int is_valid;
  struct Entry table[TAB_SIZE];
};

int semantic_check(struct Node *node);

#endif
