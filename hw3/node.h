#ifndef __NODE_H__
#define __NODE_H__

#define TOKEN_ARRAY 1001
#define TOKEN_INTEGER 1002
#define TOKEN_REAL 1003
#define TOKEN_NUM 1004
#define TOKEN_STRING 1005
#define TOKEN_COMMENT 1006
#define TOKEN_DO 1007
#define TOKEN_ELSE 1008
#define TOKEN_END 1009
#define TOKEN_FUNCTION 1010
#define TOKEN_IDENTIFIER 1011
#define TOKEN_IF 1012
#define TOKEN_NOT 1013
#define TOKEN_OF 1014
#define TOKEN_PBEGIN 1015
#define TOKEN_PROCEDURE 1016
#define TOKEN_PROGRAM 1017
#define TOKEN_THEN 1018
#define TOKEN_VAR 1019
#define TOKEN_WHILE 1020
#define TOKEN_ASSIGNMENT 1021
#define TOKEN_COLON 1022
#define TOKEN_COMMA 1023
#define TOKEN_DOT 1024
#define TOKEN_DOTDOT 1025
#define TOKEN_EQUAL 1026
#define TOKEN_GE 1027
#define TOKEN_GT 1028
#define TOKEN_LBRAC 1029
#define TOKEN_LE 1030
#define TOKEN_LPAREN 1031
#define TOKEN_LT 1032
#define TOKEN_MINUS 1033
#define TOKEN_PLUS 1034
#define TOKEN_RBRAC 1035
#define TOKEN_RPAREN 1036
#define TOKEN_SEMICOLON 1037
#define TOKEN_SLASH 1038
#define TOKEN_STAR 1039
#define TOKEN_notEQUAL 1040
#define TOKEN_AND 1041
#define TOKEN_OR 1042

#define TYPE_tail 2001
#define TYPE_term 2002
#define TYPE_factor 2003
#define TYPE_addop 2004
#define TYPE_mulop 2005
#define TYPE_relop 2006
#define TYPE_lambda 2007
#define TYPE_prog 2008
#define TYPE_type 2009
#define TYPE_declarations 2010
#define TYPE_arguments 2011
#define TYPE_expression 2012
#define TYPE_variable 2013
#define TYPE_statement 2014
#define TYPE_standard_type 2015
#define TYPE_optional_var 2016
#define TYPE_optional_statements 2017
#define TYPE_simple_expression 2018
#define TYPE_identifier_list 2019
#define TYPE_expression_list 2020
#define TYPE_statement_list 2021
#define TYPE_parameter_list 2022
#define TYPE_subprogram_declaration 2023
#define TYPE_subprogram_declarations 2024
#define TYPE_subprogram_head 2025
#define TYPE_compound_statement 2026
#define TYPE_procedure_statement 2027
#define TYPE_boolexpression 2028

struct Node {
  int node_type;
  struct Node *parent;
  struct Node *child;
  struct Node *lsibling;
  struct Node *rsibling;

  int integer_value;
  double real_value;
  char *node_str;
};

struct Node *new_node(char *str);
void delete_node(struct Node *node);
void add_child(struct Node *node, struct Node *child);
void print_tree(struct Node *node, int ident);

#endif
