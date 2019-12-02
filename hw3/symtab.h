#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

#define NAME_SIZE 100
#define TAB_SIZE 100
#define LIST_SIZE 100
#define MAX_DIMENSION 10
#define PARA_SIZE 100

struct Entry {
  char name[NAME_SIZE];
  int scope;
  int type;
  int return_type;
  char parameter[PARA_SIZE];
  int dim;
  struct Range *range;
  int int_value;
  double double_value;
  int inited;
  struct Array_node *array_content;
};

struct Table {
  int next_entry_idx;
  int is_valid;
  struct Entry table[TAB_SIZE];
};

struct Range {
  int is_valid;
  int lower_bound;
  int upper_bound;
};

struct Array_node {
  int is_valid;
  int address[MAX_DIMENSION];
  struct Array_node *prev;
  struct Array_node *next;
};

struct Entry *find_entry(char *name);
void add_entry(char *name, int scope, int type, int return_type, int dim,
               struct Range *range);
void delete_table();
void print_entry_type(int type);
void print_table();
int calculate_dim(struct Range *range);
int check_array_index(struct Node *node);
int check_assignment_type(struct Node *node, int type);
struct Range *traverse_array(struct Node *node);
void traverse_stmt(struct Node *node);
void traverse_simple_expr(struct Node *node, int type);
void traverse_decls(struct Node *node);
void traverse_para_list(struct Node *node);
void traverse_prog(struct Node *node);
int semantic_check(struct Node *node);

#endif
