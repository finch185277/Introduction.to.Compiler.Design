#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

struct symbol_table_entry {
  char name[100];
  int scope;
  int type;
};

struct symbol_table_list {
  int max_idx;
  struct symbol_table_entry symbol_table[100];
  // first element of symbol is ID entry
  // idx means the table scope
};

int semantic_check(struct Node *node);

#endif
