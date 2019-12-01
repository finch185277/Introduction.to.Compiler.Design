#include "symtab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Table symtab[LIST_SIZE];
int cur_tab_idx;

struct Entry *find_entry(char *name) {
  for (int i = 0; i <= cur_tab_idx; i++) {
    if (symtab[i].is_valid) {
      for (int j = 0; j < symtab[i].next_entry_idx; j++) {
        if (strcmp(name, symtab[i].table[j].name) == 0) {
          return &symtab[i].table[j];
        }
      }
    }
  }
  return NULL;
}

void add_entry(char *name, int scope, int type, int return_type,
               struct Node *parameter, int dim, struct Node *range) {
  if (0) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  int entry_idx = symtab[cur_tab_idx].next_entry_idx;
  if (entry_idx == TAB_SIZE) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  strcpy(symtab[cur_tab_idx].table[entry_idx].name, name);
  symtab[cur_tab_idx].table[entry_idx].scope = scope;
  symtab[cur_tab_idx].table[entry_idx].type = type;
  symtab[cur_tab_idx].table[entry_idx].return_type = return_type;

  if (entry_idx == 0)
    symtab[cur_tab_idx].is_valid = 1;

  symtab[cur_tab_idx].next_entry_idx++;
}

void delete_table() {
  symtab[cur_tab_idx].next_entry_idx = 0;
  cur_tab_idx--;
}

void print_entry_type(int type) {
  switch (type) {
  case TYPE_INT:
    printf("int");
    break;
  case TYPE_REAL:
    printf("real");
    break;
  case TYPE_STRING:
    printf("string");
    break;
  case HEAD_FUNCTION:
    printf("function");
    break;
  case HEAD_PROCEDURE:
    printf("procedure");
    break;
  }
  return;
}

void print_table() {
  printf("----------------------------------------------------------------\n");
  printf("| Name | Scope | Type | Return | Parameter | Dim | Array Range |\n");
  printf("----------------------------------------------------------------\n");
  for (int i = 0; i < symtab[cur_tab_idx].next_entry_idx; i++) {
    printf("| %s | %d | ", symtab[cur_tab_idx].table[i].name,
           symtab[cur_tab_idx].table[i].scope);
    print_entry_type(symtab[cur_tab_idx].table[i].type);
    printf(" | ");
    if (symtab[cur_tab_idx].table[i].return_type != 0) {
      print_entry_type(symtab[cur_tab_idx].table[i].return_type);
      printf(" |");
    } else {
      printf(" |");
    }
    if (symtab[cur_tab_idx].table[i].parameter != NULL) {
      printf(" |");
    } else {
      printf(" |");
    }
    if (symtab[cur_tab_idx].table[i].dim != 0) {
      printf(" |");
    } else {
      printf(" |");
    }
    if (symtab[cur_tab_idx].table[i].range != NULL) {
      printf(" |");
    } else {
      printf(" |");
    }
    printf(
        "\n----------------------------------------------------------------\n");
  }
}

void traverse_decls(struct Node *node) {
  struct Node *child = node->child->rsibling;
  while (child->node_type != LAMBDA) {
    int type;
    switch (child->rsibling->child->node_type) {
    case TYPE_INT:
      type = TYPE_INT;
      break;
    case TYPE_REAL:
      type = TYPE_REAL;
      break;
    case TYPE_STRING:
      type = TYPE_STRING;
      break;
    }
    struct Node *grand_child = child->child;
    do {
      switch (grand_child->node_type) {
      case TOKEN_IDENTIFIER:
        add_entry(grand_child->content, cur_tab_idx, type, 0, NULL, 0, NULL);
        break;
      }
      grand_child = grand_child->rsibling;
    } while (grand_child != child->child);
    child = child->rsibling->rsibling;
  }
}

void traverse_prog(struct Node *node) {
  traverse_decls(node);
  print_table();
}

void traverse_subprog_head(struct Node *node) {
  printf("****************************************\n");
  printf("*              Open Scope              *\n");
  printf("****************************************\n");
  cur_tab_idx++;
  switch (node->child->node_type) {
  case HEAD_FUNCTION:;
    int return_type = node->child->lsibling->node_type;
    add_entry(node->child->rsibling->content, cur_tab_idx, HEAD_FUNCTION,
              return_type, NULL, 0, NULL);
    break;
  case HEAD_PROCEDURE:
    add_entry(node->child->rsibling->content, cur_tab_idx, HEAD_PROCEDURE, 0,
              NULL, 0, NULL);
    break;
  }
}

int semantic_check(struct Node *node) {
  if (node->visited == 1)
    return 0;
  switch (node->node_type) {
  case PROG:
    traverse_prog(node->child);
    break;
  case SUBPROG_DECL:
    break;
  case SUBPROG_HEAD:
    traverse_subprog_head(node);
    break;
  case DECLS:
    traverse_decls(node);
    break;
  case COMPOUND_STMT:
    if (node->parent->node_type != PROG) {
      print_table();
      printf("****************************************\n");
      printf("*              Close Scope             *\n");
      printf("****************************************\n");
    }
    break;
  case STMT_LIST:
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
