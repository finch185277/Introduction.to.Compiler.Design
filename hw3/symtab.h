#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

#define NAME_SIZE 100
#define TAB_SIZE 100
#define LIST_SIZE 100

struct entry {
  char name[NAME_SIZE];
  int scope;
  int type;
};

int semantic_check(struct Node *node);

#endif
