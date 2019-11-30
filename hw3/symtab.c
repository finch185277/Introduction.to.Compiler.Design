#include "symtab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct entry symtab[LIST_SIZE][TAB_SIZE];
int max_tab = 0;          // record max tab idx in list(symtab)
int tab_valid[LIST_SIZE]; // record which tab on list is valid
int max_entry[LIST_SIZE]; // record max entry idx of every tab

struct entry *find_symbol(char *name) {
  for (int i = 0; i < max_tab && tab_valid[i]; i++) {
    for (int j = 0; j < max_entry[i]; j++) {
      if (strcmp(name, symtab[i][j].name)) {
        return &symtab[i][j];
      }
    }
  }
  return NULL;
}

int semantic_check(struct Node *node) { return 0; }
