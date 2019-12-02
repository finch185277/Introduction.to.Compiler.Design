#ifndef __SYMTAB_H___
#define __SYMTAB_H___

#include "node.h"

#define NAME_SIZE 100
#define TAB_SIZE 100
#define LIST_SIZE 100
#define RANGE_SIZE 10
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
  int double_value;
  int inited;
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

struct Entry *find_entry(char *name);
void add_entry(char *name, int scope, int type, int return_type, int dim,
               struct Range *range);
void delete_table();
void print_entry_type(int type);
void print_table();
int calculate_dim(struct Range *range);
struct Range *traverse_array(struct Node *node);
void traverse_decls(struct Node *node);
void traverse_para_list(struct Node *node);
void traverse_prog(struct Node *node);
int semantic_check(struct Node *node);

#endif
