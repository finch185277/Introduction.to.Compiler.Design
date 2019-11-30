#include "symtab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Table symtab[LIST_SIZE];
int cur_tab_idx;

int find_symbol(char *name) {
  for (int i = 0; i <= cur_tab_idx; i++) {
    if (symtab[i].is_valid) {
      for (int j = 0; j < symtab[i].next_entry_idx; j++) {
        if (strcmp(name, symtab[i].table[j].name) == 0) {
          return 0;
        }
      }
    }
  }
  return 0;
}

void add_symbol(char *name, int type) {
  if (find_symbol(name) == 1) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  int entry_idx = symtab[cur_tab_idx].next_entry_idx;
  if (entry_idx == TAB_SIZE) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  strcpy(symtab[cur_tab_idx].table[entry_idx].name, name);
  symtab[cur_tab_idx].table[entry_idx].scope = cur_tab_idx;
  symtab[cur_tab_idx].table[entry_idx].type = type;
  printf("---- %d %d %d ----\n", entry_idx, type,
         symtab[cur_tab_idx].table[entry_idx].type);

  if (entry_idx == 0)
    symtab[cur_tab_idx].is_valid = 1;

  symtab[cur_tab_idx].next_entry_idx++;
}

void delete_table() {
  symtab[cur_tab_idx].next_entry_idx = 0;
  cur_tab_idx--;
}

void print_table() {
  printf("-------------------\n");
  printf("Name | Scope | Type\n");
  printf("-------------------\n");
  for (int i = 0; i < symtab[cur_tab_idx].next_entry_idx; i++) {
    char type_name[10];
    switch (symtab[cur_tab_idx].table[i].type) {
    case TYPE_INT:
      strcpy(type_name, "int");
      break;
    case TYPE_REAL:
      strcpy(type_name, "real");
      break;
    case TYPE_STRING:
      strcpy(type_name, "string");
      break;
    case HEAD_FUNCTION:
      strcpy(type_name, "function");
      break;
    case HEAD_PROCEDURE:
      strcpy(type_name, "procedure");
      break;
    }

    printf("%s | %d | %s\n", symtab[cur_tab_idx].table[i].name,
           symtab[cur_tab_idx].table[i].scope, type_name);
    printf("-------------------\n");
  }
}

void traverse_id_list(struct Node *node) {
  int type;
  struct Node *child = node->child;
  if (child != NULL) {
    child = child->lsibling;
    printf(" type : %d", child->node_type);
    switch (child->node_type) {
    case TYPE_INT:
      printf(" type int ");
      type = TYPE_INT;
      break;
    case TYPE_REAL:
      printf(" type real ");
      type = TYPE_REAL;
      break;
    case TYPE_STRING:
      printf(" type string ");
      type = TYPE_STRING;
      break;
    }
    child->visited = 1;
    child = child->rsibling;
    // printf("before do type: %d", type);
    do {
      switch (child->node_type) {
      case TOKEN_IDENTIFIER:
        printf("add type: %d", type);
        add_symbol(child->content, type);
        break;
      }
      child->visited = 1;
      child = child->rsibling;
    } while (child != node->child);
  }
}

void traverse_prog(struct Node *node) {
  struct Node *ptr = node->child->child;
  if (ptr != NULL) {
    do {
      if (ptr->node_type == ID_LIST)
        traverse_id_list(ptr);
      ptr = ptr->rsibling;
    } while (ptr != node->child->child);
  }
  print_table();
}

int semantic_check(struct Node *node) {
  if (node->visited == 1)
    return 0;
  switch (node->node_type) {
  case PROG:
    traverse_prog(node);
    break;
  case SUBPROG_DECL:
    printf("SUBPROG_DECL\n");
    break;
  case SUBPROG_HEAD:
    printf("****************************************\n");
    printf("*              Open Scope              *\n");
    printf("****************************************\n");
    cur_tab_idx++;
    break;
  case ID_LIST:
    traverse_id_list(node);
    break;
  case COMPOUND_STMT:
    break;
  case STMT_LIST:
    print_table();
    printf("****************************************\n");
    printf("*              Close Scope             *\n");
    printf("****************************************\n");
    break;
  }

  node->visited = 1;

  struct Node *child = node->child;
  if (child != NULL) {
    do {
      semantic_check(child);
      child = child->rsibling;
    } while (child != node->child);
  }

  return 0;
}
