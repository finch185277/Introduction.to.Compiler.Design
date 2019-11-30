#ifndef __NODE_H__
#define __NODE_H__

#define TOKEN_INT 1001
#define TOKEN_REAL 1002
#define TOKEN_STRING 1003
#define TOKEN_IDENTIFIER 1004
#define TOKEN_PLUS 1005
#define TOKEN_MINUS 1006
#define TOKEN_SLASH 1007
#define TOKEN_STAR 1008

#define ARGS 2001
#define DECLS 2002
#define FACTOR 2003
#define PROG 2004
#define STMT 2005
#define TAIL 2006
#define TERM 2007
#define TYPE 2008
#define VARIABLE 2009
#define LAMBDA 2010

#define ADDOP 2021
#define MULOP 2022
#define RELOP 2023
#define OPT_VAR 2024
#define OPT_STMTS 2025
#define ID_LIST 2026
#define EXPR_LIST 2027
#define STMT_LIST 2028
#define PARA_LIST 2029

#define SUBPROG_DECL 2041
#define SUBPROG_DECLS 2042
#define SUBPROG_HEAD 2043
#define COMPOUND_STMT 2044
#define PROC_STMT 2045
#define EXPR 2046
#define SIMPLE_EXPR 2047
#define BOOL_EXPR 2048

#define TYPE_INT 2051
#define TYPE_REAL 2052
#define TYPE_STRING 2053
#define TYPE_ARRAY 2054
#define HEAD_FUNCTION 2055
#define HEAD_PROCEDURE 2056

struct Node {
  int node_type;
  struct Node *parent;
  struct Node *child;
  struct Node *lsibling;
  struct Node *rsibling;

  int integer_value;
  double real_value;
  char *content;
};

struct Node *new_node(int type);
void delete_node(struct Node *node);
void add_child(struct Node *node, struct Node *child);
void print_tree(struct Node *node, int ident);

#endif
