#include "symtab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Table symtab[LIST_SIZE];
int cur_tab_idx;
int is_error;

struct Entry *find_entry(int scope, char *name) {
  for (int j = 0; j < symtab[scope].next_entry_idx; j++) {
    if (strcmp(name, symtab[scope].table[j].name) == 0) {
      return &symtab[scope].table[j];
    }
  }
  return NULL;
}

struct Array_node *find_array_node(struct Node *node, struct Entry *entry) {
  struct Array_node *array_node = malloc(sizeof(struct Array_node));
  struct Array_node *finder = entry->array_head;
  switch (check_array_index(node, entry, array_node)) {
  case 0:;
    while (finder != NULL) {
      int error_flag = 0;
      for (int i = 0; i < entry->dim && error_flag != 1; i++) {
        if (finder->address[i] != array_node->address[i]) {
          error_flag = 1;
        }
      }
      if (error_flag == 0) {
        free(array_node);
        return finder;
      }
      finder = finder->next;
    }
    free(array_node);
    return NULL;
    break;
  case 1:
    printf("          Array index type error: %s\n", entry->name);
    free(array_node);
    return NULL;
  case 2:
    printf("[ ERROR ] Array index calculate error: %s\n", entry->name);
    free(array_node);
    return NULL;
  case 3:
    printf("[ ERROR ] Array index range error: %s\n", entry->name);
    free(array_node);
    return NULL;
  }
  return NULL;
}

void add_entry(char *name, int scope, int type, int return_type, int dim,
               struct Range *range) {
  if (find_entry(cur_tab_idx, name) != NULL) {
    printf("[ ERROR ] Redefined error: %s\n", name);
    is_error = 1;
    print_table();
    exit(0);
  }

  int entry_idx = symtab[cur_tab_idx].next_entry_idx;
  if (entry_idx == TAB_SIZE) {
    printf("[ ERROR ] Table size overflow: %s\n", name);
    is_error = 1;
    print_table();
    exit(0);
  }

  symtab[cur_tab_idx].table[entry_idx].index = entry_idx;
  strcpy(symtab[cur_tab_idx].table[entry_idx].name, name);
  symtab[cur_tab_idx].table[entry_idx].scope = scope;
  symtab[cur_tab_idx].table[entry_idx].type = type;
  symtab[cur_tab_idx].table[entry_idx].return_type = return_type;
  symtab[cur_tab_idx].table[entry_idx].parameter_list = NULL;
  symtab[cur_tab_idx].table[entry_idx].dim = dim;
  symtab[cur_tab_idx].table[entry_idx].range = range;
  symtab[cur_tab_idx].table[entry_idx].array_head = NULL;
  symtab[cur_tab_idx].table[entry_idx].array_tail = NULL;

  if (type == HEAD_FUNCTION || type == HEAD_PROCEDURE) {
    struct Para *tail;
    for (int para_id = 0; para_id < entry_idx; para_id++) {
      struct Para *para = malloc(sizeof(struct Para));
      para->scope = cur_tab_idx;
      para->name = symtab[cur_tab_idx].table[para_id].name;
      tail = para;
      if (symtab[cur_tab_idx].table[entry_idx].parameter_list == NULL) {
        symtab[cur_tab_idx].table[entry_idx].parameter_list = tail;
      }
      tail = tail->next;
    }
  }

  printf("[SUCCESS] Load to symbol table: %s\n", name);

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

void print_para_list(struct Entry *entry) {
  char para_list[200];
  struct Para *tail = entry->parameter_list;
  memset(&para_list, 0, sizeof(para_list));
  while (tail != NULL) {
    char para[20];
    sprintf(para, "(%s)", tail->name);
    strcat(para_list, para);
    tail = tail->next;
  }
  printf("| %-15s ", para_list);
}

void print_table() {
  printf("---------------------------------------------------------------------"
         "--------------------------------\n");
  printf("|    Name    | Scope |   Type    |  Return   |    Parameter    | Dim "
         "|          Array Range         |\n");
  printf("---------------------------------------------------------------------"
         "--------------------------------\n");
  for (int i = 0; i < symtab[cur_tab_idx].next_entry_idx; i++) {
    printf("| %-10s ", symtab[cur_tab_idx].table[i].name);
    printf("| %-5d ", symtab[cur_tab_idx].table[i].scope);
    print_entry_type(symtab[cur_tab_idx].table[i].type);
    print_entry_type(symtab[cur_tab_idx].table[i].return_type);
    print_para_list(&symtab[cur_tab_idx].table[i]);

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
      printf("| %-28s |", array_range);
    } else {
      printf("| %-3s ", "");
      printf("| %-28s |", "");
    }

    printf("\n-----------------------------------------------------------------"
           "------------------------------------\n");
  }
  return;
}

int calculate_dim(struct Range *range) {
  int dim = 0;
  for (; dim < MAX_DIMENSION; dim++) {
    if (range[dim].is_valid == 0) {
      break;
    }
  }
  return dim;
}

struct Range *traverse_array(struct Node *node) {
  int dim = 0;
  struct Range *range = malloc(MAX_DIMENSION * sizeof(struct Range));
  do {
    range[dim].is_valid = 1;
    range[dim].lower_bound = node->child->integer_value;
    range[dim].upper_bound = node->child->rsibling->integer_value;
    dim++;
    node = node->rsibling;
  } while (node->node_type == TYPE_ARRAY);
  return range;
}

void traverse_decls(struct Node *node) {
  node->visited = 1;
  struct Node *child = node->child->rsibling;
  while (child->node_type != LAMBDA) {
    int type;
    struct Node *type_node = child->rsibling;
    switch (type_node->child->node_type) {
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
    if (type_node->child->rsibling != type_node->child) {
      is_array = 1;
      range = traverse_array(type_node->child->rsibling);
    }
    struct Node *grand_child = child->child;
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
    } while (grand_child != child->child);
    child = child->rsibling->rsibling;
  }
  return;
}

void traverse_para_list(struct Node *node) {
  node->visited = 1;
  if (node->node_type == LAMBDA)
    return;
  struct Node *child = node->child;
  do {
    int type;
    struct Node *type_node = child->rsibling->rsibling;
    switch (type_node->child->node_type) {
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
    if (type_node->child->rsibling != type_node->child) {
      is_array = 1;
      range = traverse_array(type_node->child->rsibling);
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
    struct Node *upper_node = node->parent->parent->parent;
    scope =
        find_entry(cur_tab_idx, upper_node->child->rsibling->content)->scope;
  }
  struct Node *id_node = node->child->rsibling;
  switch (node->child->node_type) {
  case HEAD_FUNCTION:;
    int return_type = node->child->lsibling->node_type;
    add_entry(id_node->content, scope, HEAD_FUNCTION, return_type, 0, NULL);
    break;
  case HEAD_PROCEDURE:
    add_entry(id_node->content, scope, HEAD_PROCEDURE, 0, 0, NULL);
    break;
  }
}

int check_simple_expr_type(struct Node *node, int type) {
  struct Node *child = node->child;
  if (child != NULL) {
    do {
      if (child->node_type == FACTOR) {
        switch (child->child->node_type) {
        case TOKEN_INT:
          if (type != TYPE_INT) {
            printf("[ ERROR ] Type error: type should not be INT: %d\n",
                   child->integer_value);
            return 1;
          }
          break;
        case TOKEN_REAL:
          if (type != TYPE_REAL) {
            printf("[ ERROR ] Type error: type should not be REAL: %lf\n",
                   child->real_value);
            return 1;
          }
          break;
        case TOKEN_STRING:
          if (type != TYPE_STRING) {
            printf("[ ERROR ] Type error: type should not be STRING: %s\n",
                   child->content);
            return 1;
          }
          break;
        case TOKEN_IDENTIFIER:;
          struct Entry *entry = find_entry(cur_tab_idx, child->child->content);
          if (entry == NULL) {
            printf("[ ERROR ] Undeclared error: %s\n", child->child->content);
            return 1;
          } else {
            switch (entry->type) {
            case TYPE_INT:
              if (type != TYPE_INT) {
                printf("[ ERROR ] Type error: type should not be INT: %s\n",
                       entry->name);
                return 1;
              }
              if (entry->inited == 0) {
                printf("[ ERROR ] Uninitialized error: %s\n", entry->name);
                return 1;
              }
              break;
            case TYPE_REAL:
              if (type != TYPE_REAL) {
                printf("[ ERROR ] Type error: type should not be REAL: %s\n",
                       entry->name);
                return 1;
              }
              if (entry->inited == 0) {
                printf("[ ERROR ] Uninitialized error: %s\n", entry->name);
                return 1;
              }
              break;
            case TYPE_STRING:
              if (type != TYPE_STRING) {
                printf("[ ERROR ] Type error: type should not be STRING: %s\n",
                       entry->name);
                return 1;
              }
              if (entry->inited == 0) {
                printf("[ ERROR ] Uninitialized error: %s\n", entry->name);
                return 1;
              }
              break;
            case HEAD_FUNCTION:
              switch (entry->return_type) {
              case TYPE_INT:
                if (type != TYPE_INT) {
                  printf("[ ERROR ] Type error: "
                         "function return type should not be INT: %s\n",
                         entry->name);
                  return 1;
                }
                break;
              case TYPE_REAL:
                if (type != TYPE_REAL) {
                  printf("[ ERROR ] Type error: "
                         "function return type should not be REAL: %s\n",
                         entry->name);
                  return 1;
                }
                break;
              case TYPE_STRING:
                if (type != TYPE_STRING) {
                  printf("[ ERROR ] Type error:"
                         " function return type should not be STRING: %s\n",
                         entry->name);
                  return 1;
                }
                break;
              }      // switch (entry->return_type)
              break; // case HEAD_FUNCTION
            default:
              return 1;
            }    // switch (entry->type)
          }      // if (entry != NULL)
          break; // case TOKEN_IDENTIFIER
        }        // switch (child->child->node_type)
      }          // if (child->node_type == FACTOR)
      if (check_simple_expr_type(child, type) == 1)
        return 1;
      else
        child = child->rsibling;
    } while (child != node->child);
  }
  return 0;
}

int check_parameter_list(struct Node *node, struct Entry *entry) {
  struct Node *para_node = node->child->rsibling;
  struct Para *para_ptr = entry->parameter_list;
  int index = entry->index;
  while (para_node->node_type != EXPR_LIST) {
    if (para_ptr == NULL) {
      return 1;
    }
    struct Node *simple_expr = para_node->child->child;
    int type = find_entry(para_ptr->scope, para_ptr->name)->type;
    if (check_simple_expr_type(simple_expr, type) == 1) {
      return 1;
    }
    para_ptr = para_ptr->next;
    para_node = para_node->rsibling;
  }
  return 0;
}

int check_factor(struct Node *node, int type) {
  struct Node *child = node->child;
  switch (child->node_type) {
  case TOKEN_INT:
    node->integer_value = child->integer_value;
    break;
  case TOKEN_REAL:
    node->real_value = child->real_value;
    break;
  case TOKEN_STRING:
    node->content = child->content;
    break;
  case TOKEN_IDENTIFIER:;
    struct Entry *entry = find_entry(cur_tab_idx, child->content);
    if (entry == NULL) {
      printf("[ ERROR ] Undeclared error: %s\n", child->rsibling->content);
      return 1;
    }
    if (entry->dim == 0) {
      if (entry->type == HEAD_FUNCTION) {
        break;
      }
      if (entry->type == HEAD_PROCEDURE) {
        printf("[ ERROR ] Assign error (procedure no return value): %s\n",
               entry->name);
        return 1;
      }
      if (entry->inited == 0) {
        printf("[ ERROR ] Uninitialized error: %s\n", entry->name);
        return 1;
      }
      switch (entry->type) {
      case TYPE_INT:
        node->integer_value = entry->int_value;
        break;
      case TYPE_REAL:
        node->real_value = entry->double_value;
        break;
      }
    } else {
      struct Node *tail = child->rsibling;
      struct Array_node *finder = find_array_node(tail, entry);
      if (finder == NULL) {
        printf("[ ERROR ] Uninitialized error: %s\n", entry->name);
        return 1;
      }
      switch (entry->type) {
      case TYPE_INT:
        node->integer_value = finder->int_value;
        break;
      case TYPE_REAL:
        node->real_value = finder->double_value;
        break;
      }
    }
    break;
  case TOKEN_EXPR:;
    struct Node *simple_expr = child->rsibling->child->child;
    if (simple_expr->rsibling->node_type == RELOP) {
      printf("[ ERROR ] Variable should not assign to (RELOP)\n");
    } else {
      if (check_simple_expr_result(simple_expr, type) == 1) {
        return 1;
      }
      switch (type) {
      case TYPE_INT:
        child->integer_value = simple_expr->integer_value;
        node->integer_value = child->integer_value;
        break;
      case TYPE_REAL:
        child->real_value = simple_expr->real_value;
        node->real_value = child->real_value;
        break;
      case TYPE_STRING:
        child->content = simple_expr->content;
        node->content = child->content;
        break;
      }
    }
    break;
  }
  return 0;
}

int check_term(struct Node *node, int type) {
  struct Node *child = node->child;
  int op = 0;
  do {
    switch (child->node_type) {
    case FACTOR:
      if (check_factor(child, type) == 1)
        return 1;
      switch (type) {
      case TYPE_INT:
        switch (op) {
        case TOKEN_STAR:
          node->integer_value *= child->integer_value;
          break;
        case TOKEN_SLASH:
          node->integer_value /= child->integer_value;
          break;
        default: // op not declared
          node->integer_value = child->integer_value;
        } // switch (op)
        break;
      case TYPE_REAL:
        switch (op) {
        case TOKEN_STAR:
          node->real_value *= child->real_value;
          break;
        case TOKEN_SLASH:
          node->real_value /= child->real_value;
          break;
        default: // op not declared
          node->real_value = child->real_value;
        } // switch (op)
        break;
      case TYPE_STRING:
        node->content = child->content;
        break;
      } // switch (type)

      op = 0; // reset op
      break;
    case MULOP:
      op = child->child->node_type;
      break;
    } // switch (child->node_type)
    child = child->rsibling;
  } while (child != node->child);
  return 0;
}

int check_simple_expr_result(struct Node *node, int type) {
  struct Node *child = node->child;
  int op = 0;
  do {
    switch (child->node_type) {
    case TERM:
      if (check_term(child, type) == 1)
        return 1;
      switch (type) {
      case TYPE_INT:
        switch (op) {
        case TOKEN_PLUS:
          node->integer_value += child->integer_value;
          break;
        case TOKEN_MINUS:
          node->integer_value -= child->integer_value;
          break;
        default: // op not declared
          node->integer_value = child->integer_value;
        } // switch (op)
        break;
      case TYPE_REAL:
        switch (op) {
        case TOKEN_PLUS:
          node->real_value += child->real_value;
          break;
        case TOKEN_MINUS:
          node->real_value -= child->real_value;
          break;
        default: // op not declared
          node->real_value = child->real_value;
        } // switch (op)
        break;
      case TYPE_STRING:
        node->content = child->content;
        break;
      } // switch (type)

      op = 0; // reset op
      break;
    case ADDOP:
      op = child->child->node_type;
      break;
    } // switch (child->node_type)
    child = child->rsibling;
  } while (child != node->child);
  return 0;
}

int check_array_index(struct Node *node, struct Entry *entry,
                      struct Array_node *array_node) {
  struct Node *index = node->child->rsibling;
  for (int i = 0; i < entry->dim; i++) {
    struct Node *simple_expr = index->child->child;
    if (check_simple_expr_type(simple_expr, TYPE_INT) == 1) {
      return 1;
    }
    if (check_simple_expr_result(simple_expr, TYPE_INT) == 1) {
      return 2;
    }
    if (simple_expr->integer_value < entry->range[i].lower_bound ||
        simple_expr->integer_value > entry->range[i].upper_bound) {
      return 3;
    }
    array_node->address[i] = simple_expr->integer_value;
    index = index->rsibling;
  }
  return 0;
}

void traverse_asmt(struct Node *node) {
  // assignment: variable := expression
  struct Node *var = node->rsibling;            // variable
  struct Node *expr = node->rsibling->rsibling; // expression

  struct Entry *var_entry = find_entry(cur_tab_idx, var->child->content);
  if (var_entry == NULL) {
    printf("[ ERROR ] Undeclared error: %s\n", var->child->content);
    is_error = 1;
    return;
  }
  int dim = 0;
  struct Node *tail = var->child->rsibling;
  struct Node *dim_counter = tail->child->rsibling;
  while (dim_counter->node_type != LAMBDA) {
    dim++;
    dim_counter = dim_counter->rsibling;
  }
  if (dim != var_entry->dim) {
    printf("[ ERROR ] Array dimension error: ");
    printf("declare %d dim, but access %d dim\n", var_entry->dim, dim);
    is_error = 1;
    return;
  }
  if (expr->child->child->rsibling->node_type == RELOP) {
    printf("[ ERROR ] Variable should not assign to RELOP: %s\n",
           var->child->content);
    is_error = 1;
    return;
  }
  struct Node *simple_expr = expr->child->child;
  // check type
  if (check_simple_expr_type(simple_expr, var_entry->type) != 0) {
    is_error = 1;
    return;
  }
  if (dim == 0) { // real or int or string: assign value
    switch (var_entry->type) {
    case TYPE_INT:
      if (check_simple_expr_result(simple_expr, TYPE_INT) == 1) {
        is_error = 1;
      } else {
        var_entry->int_value = simple_expr->integer_value;
        var_entry->inited = 1;
      }
      break;
    case TYPE_REAL:
      if (check_simple_expr_result(simple_expr, TYPE_REAL) == 1) {
        is_error = 1;
      } else {
        var_entry->double_value = simple_expr->real_value;
        var_entry->inited = 1;
      }
      break;
    case TYPE_STRING:
      if (check_simple_expr_result(simple_expr, TYPE_STRING) == 1)
        is_error = 1;
      break;
    case HEAD_FUNCTION:
      switch (var_entry->type) {
      case TYPE_INT:
        if (check_simple_expr_result(simple_expr, TYPE_INT) == 1)
          is_error = 1;
        break;
      case TYPE_REAL:
        if (check_simple_expr_result(simple_expr, TYPE_REAL) == 1)
          is_error = 1;
        break;
      case TYPE_STRING:
        if (check_simple_expr_result(simple_expr, TYPE_STRING) == 1)
          is_error = 1;
        break;
      }
      break;
    }
  } else { // array: check index
    struct Array_node *array_node = malloc(sizeof(struct Array_node));
    switch (check_array_index(tail, var_entry, array_node)) {
    case 0:
      var_entry->array_tail = array_node;
      if (var_entry->array_head == NULL) {
        var_entry->array_head = var_entry->array_tail;
      }
      switch (var_entry->type) {
      case TYPE_INT:
        if (check_simple_expr_result(simple_expr, TYPE_INT) == 1) {
          is_error = 1;
        } else {
          var_entry->array_tail->int_value = simple_expr->integer_value;
        }
        break;
      case TYPE_REAL:
        if (check_simple_expr_result(simple_expr, TYPE_REAL) == 1) {
          is_error = 1;
        } else {
          var_entry->array_tail->double_value = simple_expr->real_value;
        }
        break;
      case TYPE_STRING:
        if (check_simple_expr_result(simple_expr, TYPE_STRING) == 1) {
          is_error = 1;
        } else {
          var_entry->array_tail->string_value = simple_expr->content;
        }
        break;
      }
      var_entry->array_tail = var_entry->array_tail->next;
      break;
    case 1:
      printf("          Array index type error: %s\n", var_entry->name);
      free(array_node);
      is_error = 1;
      break;
    case 2:
      printf("[ ERROR ] Array index calculate error: %s\n", var_entry->name);
      free(array_node);
      is_error = 1;
      break;
    case 3:
      printf("[ ERROR ] Array index range error: %s\n", var_entry->name);
      free(array_node);
      is_error = 1;
      break;
    }
  }
  return;
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
  case BEGIN_FLAG:
    if (node->parent->parent->node_type != PROG) {
      print_table();
    }
    break;
  case STMT:
    if (node->child->node_type == ASMT)
      traverse_asmt(node->child);
    break;
  case END_FLAG:
    if (node->parent->parent->node_type != PROG) {
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

  return is_error;
}
