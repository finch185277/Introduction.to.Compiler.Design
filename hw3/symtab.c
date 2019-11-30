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

struct entry *add_symbol(char *name, int type) {
  struct entry *entry_ptr = find_symbol(name);
  if (entry_ptr != NULL) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  entry_ptr = &symtab[max_tab][max_entry[max_tab]++];
  strcpy(entry_ptr->name, name);
  entry_ptr->scope = max_tab;
  entry_ptr->type = type;

  return entry_ptr;
}

void delete_table(int idx) {
  max_entry[idx] = 0;
  tab_valid[idx] = 0;
}

void print_table(int idx) {
  printf("Name | Scope | Type\n");
  for (int i = 0; i < max_entry[idx]; i++) {
    char type[10];
    switch (symtab[idx][i].type) {
    case TYPE_INT:
      strcpy(type, "int");
      break;
    case TYPE_REAL:
      strcpy(type, "real");
      break;
    case TYPE_STRING:
      strcpy(type, "string");
      break;
    case HEAD_FUNCTION:
      strcpy(type, "function");
      break;
    case HEAD_PROCEDURE:
      strcpy(type, "procedure");
      break;
    }
    printf("%s | %d | %s\n", symtab[idx][i].name, symtab[idx][i].scope, type);
  }
}

int semantic_check(struct Node *node) {
  switch (node->node_type) {
  case PROG:
    printf("get prog\n");
    break;
  case SUBPROG_DECL:
    printf("get SUBPROG_DECL\n");
    break;
  case SUBPROG_HEAD:
    printf("****************************************\n");
    printf("*              Open Scope              *\n");
    printf("****************************************\n");
    break;
  case COMPOUND_STMT:
    printf("get COMPOUND_STMT\n");
    break;
  case STMT_LIST:
    printf("****************************************\n");
    printf("*              Close Scope             *\n");
    printf("****************************************\n");
    break;
  }

  struct Node *child = node->child;
  if (child != NULL) {
    do {
      semantic_check(child);
      child = child->rsibling;
    } while (child != node->child);
  }

  return 0;
}
