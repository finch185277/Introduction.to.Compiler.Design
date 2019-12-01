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

void add_entry(char *name, int scope, int type, int return_type, int dim,
               struct Range *range) {
  if (0) {
    printf("Error: duplicate declaration of variable %s\n", name);
    exit(0);
  }

  int entry_idx = symtab[cur_tab_idx].next_entry_idx;
  if (entry_idx == TAB_SIZE) {
    printf("Error: Size full, name: %s\n", name);
    exit(0);
  }

  strcpy(symtab[cur_tab_idx].table[entry_idx].name, name);
  symtab[cur_tab_idx].table[entry_idx].scope = scope;
  symtab[cur_tab_idx].table[entry_idx].type = type;
  symtab[cur_tab_idx].table[entry_idx].return_type = return_type;
  symtab[cur_tab_idx].table[entry_idx].dim = dim;
  symtab[cur_tab_idx].table[entry_idx].range = range;

  if (type == HEAD_FUNCTION || type == HEAD_PROCEDURE) {
    if (entry_idx == 0) {
      strcat(symtab[cur_tab_idx].table[entry_idx].parameter, "()");
    } else {
      for (int para_id = 0; para_id < entry_idx; para_id++) {
        char para[200];
        sprintf(para, "(%s)", symtab[cur_tab_idx].table[para_id].name);
        strcat(symtab[cur_tab_idx].table[entry_idx].parameter, para);
      }
    }
  }

  if (entry_idx == 0)
    symtab[cur_tab_idx].is_valid = 1;

  symtab[cur_tab_idx].next_entry_idx++;
}

void delete_table() {
  symtab[cur_tab_idx].next_entry_idx = 0;
  cur_tab_idx--;
}

void print_entry_type(int type) {
  char type_name[20];
  switch (type) {
  case TYPE_INT:
    sprintf(type_name, "int");
    break;
  case TYPE_REAL:
    sprintf(type_name, "real");
    break;
  case TYPE_STRING:
    sprintf(type_name, "string");
    break;
  case HEAD_FUNCTION:
    sprintf(type_name, "function");
    break;
  case HEAD_PROCEDURE:
    sprintf(type_name, "procedure");
    break;
  default:
    sprintf(type_name, " ");
    break;
  }
  printf("| %-9s ", type_name);
  return;
}

void print_table() {
  printf("---------------------------------------------------------------------"
         "------------------------\n");
  printf(
      "|    Name    | Scope |   Type    |  Return   |    Parameter    | Dim | "
      "     Array Range     |\n");
  printf("---------------------------------------------------------------------"
         "------------------------\n");
  for (int i = 0; i < symtab[cur_tab_idx].next_entry_idx; i++) {
    printf("| %-10s ", symtab[cur_tab_idx].table[i].name);
    printf("| %-5d ", symtab[cur_tab_idx].table[i].scope);
    print_entry_type(symtab[cur_tab_idx].table[i].type);
    print_entry_type(symtab[cur_tab_idx].table[i].return_type);
    printf("| %-15s ", symtab[cur_tab_idx].table[i].parameter);

    if (symtab[cur_tab_idx].table[i].dim != 0) {
      printf("| %-3d ", symtab[cur_tab_idx].table[i].dim);
      char array_range[100];
      memset(&array_range, 0, sizeof(array_range));
      for (int rid = symtab[cur_tab_idx].table[i].dim - 1; rid >= 0; rid--) {
        char single_range[20];
        sprintf(single_range, "(%d, %d) ",
                symtab[cur_tab_idx].table[i].range[rid].lower_bound,
                symtab[cur_tab_idx].table[i].range[rid].upper_bound);
        strcat(array_range, single_range);
      }
      printf("| %-20s |", array_range);
    } else {
      printf("| %-3s ", "");
      printf("| %-20s |", "");
    }

    printf("\n-----------------------------------------------------------------"
           "----------------------------\n");
  }
  return;
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
        add_entry(grand_child->content, cur_tab_idx, type, 0, 0, NULL);
        break;
      }
      grand_child = grand_child->rsibling;
    } while (grand_child != child->child);
    child = child->rsibling->rsibling;
  }
}

int calculate_dim(struct Range *range) {
  int dim = 0;
  for (; dim < RANGE_SIZE; dim++) {
    if (range[dim].is_valid == 0) {
      break;
    }
  }
  return dim;
}

struct Range *traverse_array(struct Node *node) {
  int dim = 0;
  struct Range *range = malloc(RANGE_SIZE * sizeof(struct Range));
  do {
    range[dim].is_valid = 1;
    range[dim].lower_bound = node->child->integer_value;
    range[dim].upper_bound = node->child->rsibling->integer_value;
    dim++;
    node = node->rsibling;
  } while (node->node_type == TYPE_ARRAY);
  return range;
}

void traverse_para_list(struct Node *node) {
  if (node->node_type == LAMBDA)
    return;
  struct Node *child = node->child;
  do {
    int type;
    switch (child->rsibling->rsibling->child->node_type) {
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
    int is_array = 0;
    struct Range *range = NULL;
    if (child->rsibling->rsibling->child->rsibling !=
        child->rsibling->rsibling->child) {
      is_array = 1;
      range = traverse_array(child->rsibling->rsibling->child->rsibling);
    }
    struct Node *grand_child = child->rsibling->child;
    do {
      switch (grand_child->node_type) {
      case TOKEN_IDENTIFIER:
        if (is_array) {
          int dim = calculate_dim(range);
          add_entry(grand_child->content, cur_tab_idx, type, 0, dim, range);
        } else
          add_entry(grand_child->content, cur_tab_idx, type, 0, 0, NULL);
        break;
      }
      grand_child = grand_child->rsibling;
    } while (grand_child != child->rsibling->child);
    child = child->rsibling->rsibling->rsibling;
  } while (child != node->child);
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
  traverse_para_list(node->child->rsibling->rsibling->child);
  int scope;
  if (node->parent->parent->parent->node_type == PROG) {
    scope = 0;
  } else {
    scope = find_entry(node->parent->parent->parent->child->rsibling->content)
                ->scope;
  }
  switch (node->child->node_type) {
  case HEAD_FUNCTION:;
    int return_type = node->child->lsibling->node_type;
    add_entry(node->child->rsibling->content, scope, HEAD_FUNCTION, return_type,
              0, NULL);
    break;
  case HEAD_PROCEDURE:
    add_entry(node->child->rsibling->content, scope, HEAD_PROCEDURE, 0, 0,
              NULL);
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
