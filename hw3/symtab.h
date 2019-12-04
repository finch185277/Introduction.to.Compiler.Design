#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

#define TAB_SIZE 100
#define LIST_SIZE 100
#define MAX_DIMENSION 10

struct Entry {
  int index;
  char *name;
  int scope;
  int type;
  int return_type;
  struct Para *parameter_list;
  int dim;
  struct Range *range;
  int int_value;
  double double_value;
  int inited;
  int para_amount;
  struct Array_node *array_head;
  struct Array_node *array_tail;
};

struct Table {
  int next_entry_idx;
  int is_valid;
  struct Entry table[TAB_SIZE];
};

struct Para {
  int scope;
  char *name;
  struct Para *next;
};

struct Range {
  int is_valid;
  int lower_bound;
  int upper_bound;
};

struct Array_node {
  int address[MAX_DIMENSION];
  int int_value;
  double double_value;
  char *string_value;
  struct Array_node *next;
};

struct Entry *find_entry(int scope, char *name);
struct Array_node *find_array_node(struct Node *node, struct Entry *entry);
void add_entry(char *name, int scope, int type, int return_type, int dim,
               struct Range *range);
void print_entry_type(int type);

void delete_table();
void print_table();

int check_array_index(struct Node *node, struct Entry *entry,
                      struct Array_node *array_node);
int check_simple_expr_type(struct Node *node, int type);
int check_factor(struct Node *node, int type);
int check_term(struct Node *node, int type);
int check_simple_expr_result(struct Node *node, int type);

int calculate_dim(struct Range *range);
struct Range *traverse_array(struct Node *node);

void traverse_asmt(struct Node *node);
void traverse_decls(struct Node *node);
void traverse_para_list(struct Node *node);
void traverse_prog(struct Node *node);

int semantic_check(struct Node *node);

#endif
