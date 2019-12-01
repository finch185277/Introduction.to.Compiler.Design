%{

#include <stdio.h>
#include "node.h"
#include "symtab.h"

int yylex(void);
int yywrap() { return 1; }
void yyerror(const char* msg) {
  extern int yylineno;
  extern char* token_content;
  fprintf(stderr, "line %d: error token %s\n%s\n", yylineno, token_content, msg);
}

struct Node *ASTROOT;

%}

%error-verbose

%start prog

%union
{
  struct Node *node;
}

%token <node> ARRAY INTEGER REAL NUM STRING STRINGCONST
%token <node> COMMENT DO ELSE END FUNCTION IDENTIFIER IF NOT OF
%token <node> PBEGIN PROCEDURE PROGRAM THEN VAR WHILE
%token <node> ASSIGNMENT COLON COMMA DOT DOTDOT EQUAL GE GT
%token <node> LBRAC LE LPAREN LT MINUS PLUS RBRAC RPAREN
%token <node> SEMICOLON SLASH STAR notEQUAL AND OR

%type <node> tail term factor addop mulop relop lambda prog type
%type <node> declarations arguments expression variable statement
%type <node> standard_type optional_var optional_statements simple_expression
%type <node> identifier_list expression_list statement_list parameter_list
%type <node> subprogram_declaration subprogram_declarations subprogram_head
%type <node> compound_statement procedure_statement boolexpression

%left PLUS MINUS
%left STAR SLASH

%%

prog : PROGRAM IDENTIFIER LPAREN identifier_list RPAREN SEMICOLON
	declarations
	subprogram_declarations
	compound_statement DOT
  {
    $$ = new_node(PROG);
    add_child($$, $7);
    add_child($$, $8);
    add_child($$, $9);
    ASTROOT = $$;
  };


identifier_list : IDENTIFIER
  {
    $$ = new_node(ID_LIST);
    add_child($$, $1);
  }
	| identifier_list COMMA IDENTIFIER
  {
    $$ = $1;
    add_child($$, $3);
  };

declarations : declarations VAR identifier_list COLON type SEMICOLON
  {
    $$ = $1;
    add_child($$, $3);
    add_child($$, $5);
  }
	| lambda
  {
    $$ = new_node(DECLS);
    add_child($$, $1);
  };


type : standard_type
  {
    $$ = new_node(TYPE);
    add_child($$, $1);
  }
	| ARRAY LBRAC NUM DOTDOT NUM RBRAC OF type
  {
    $$ = $8;
    struct Node *ptr = new_node(TYPE_ARRAY);
    add_child(ptr, $3);
    add_child(ptr, $5);
    add_child($$, ptr);
  };

standard_type : INTEGER
  {
    $$ = new_node(TYPE_INT);
  }
	| REAL
  {
    $$ = new_node(TYPE_REAL);
  }
	| STRING
  {
    $$ = new_node(TYPE_STRING);
  };

subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON
  {
    $$ = $1;
    add_child($$, $2);
  }
	| lambda
  {
    $$ = new_node(SUBPROG_DECLS);
    add_child($$, $1);
  };

subprogram_declaration :
	subprogram_head
	declarations
	subprogram_declarations
	compound_statement
  {
    $$ = new_node(SUBPROG_DECL);
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
    add_child($$, $4);
  };

subprogram_head : FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON
  {
    $$ = new_node(SUBPROG_HEAD);
    add_child($$, new_node(HEAD_FUNCTION));
    add_child($$, $2);
    add_child($$, $3);
    add_child($$, $5);

  }
	| PROCEDURE IDENTIFIER arguments SEMICOLON
  {
    $$ = new_node(SUBPROG_HEAD);
    add_child($$, new_node(HEAD_PROCEDURE));
    add_child($$, $2);
    add_child($$, $3);
  };


arguments : LPAREN parameter_list RPAREN
  {
    $$ = new_node(ARGS);
    add_child($$, $2);
  }
	| lambda
  {
    $$ = new_node(ARGS);
    add_child($$, $1);
  };


parameter_list : optional_var identifier_list COLON type
  {
    $$ = new_node(PARA_LIST);
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $4);
  }
	| optional_var identifier_list COLON type SEMICOLON parameter_list
  {
    $$ = $6;
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $4);
  };

optional_var : VAR
  {
    $$ = new_node(OPT_VAR);
  }
	| lambda
  {
    $$ = new_node(OPT_VAR);
    add_child($$, $1);
  };

compound_statement : PBEGIN optional_statements END
  {
    $$ = new_node(COMPOUND_STMT);
    add_child($$, $2);
  };

optional_statements : statement_list
  {
    $$ = new_node(OPT_STMTS);
    add_child($$, $1);
  };

statement_list : statement
  {
    $$ = new_node(STMT_LIST);
    add_child($$, $1);
  }
	| statement_list SEMICOLON statement
  {
    $$ = $1;
    add_child($$, $3);
  };

statement : variable ASSIGNMENT expression
  {
    $$ = new_node(STMT);
    add_child($$, new_node(ASMT));
    add_child($$, $1);
    add_child($$, $3);
  }
	| procedure_statement
  {
    $$ = new_node(STMT);
    add_child($$, $1);
  }
	| compound_statement
  {
    $$ = new_node(STMT);
    add_child($$, $1);
  }
	| IF expression THEN statement ELSE statement
  {
    $$ = new_node(STMT);
    add_child($$, $2);
    add_child($$, $4);
    add_child($$, $6);
  }
	| WHILE expression DO statement
  {
    $$ = new_node(STMT);
    add_child($$, $2);
    add_child($$, $4);
  }
	| lambda
  {
    $$ = new_node(STMT);
    add_child($$, $1);
  };

variable : IDENTIFIER tail
  {
    $$ = new_node(VARIABLE);
    add_child($$, $1);
    add_child($$, $2);
  };

tail : LBRAC expression RBRAC tail
  {
    $$ = $4;
    add_child($$, $2);
  }
	| lambda
  {
    $$ = new_node(TAIL);
    add_child($$, $1);
  };

procedure_statement : IDENTIFIER
  {
    $$ = new_node(PROC_STMT);
    add_child($$, $1);
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node(PROC_STMT);
    add_child($$, $1);
    add_child($$, $3);
  };

expression_list : expression
  {
    $$ = new_node(EXPR_LIST);
    add_child($$, $1);
  }
	| expression_list COMMA expression
  {
    $$ = $1;
    add_child($$, $3);
  };

expression : boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
  }
	| boolexpression AND boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
    add_child($$, $3);
  }
	| boolexpression OR boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
    add_child($$, $3);
  };

boolexpression : simple_expression
  {
    $$ = new_node(BOOL_EXPR);
    add_child($$, $1);
  }
	| simple_expression relop simple_expression
  {
    $$ = new_node(BOOL_EXPR);
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
  };

simple_expression : term
  {
    $$ = new_node(SIMPLE_EXPR);
    add_child($$, $1);
  }
	| simple_expression addop term
  {
    $$ = $1;
    add_child($$, $2);
    add_child($$, $3);
  };

term : factor
  {
    $$ = new_node(TERM);
    add_child($$, $1);
  }
	| term mulop factor
  {
    $$ = $1;
    add_child($$, $2);
    add_child($$, $3);
  };

factor : IDENTIFIER tail
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $2);
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $3);
  }
	| NUM
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
  }
  | PLUS NUM
  {
    $$ = new_node(FACTOR);
    add_child($$, $2);
  }
  | MINUS NUM
  {
    $$ = new_node(FACTOR);
    $2->integer_value = -$2->integer_value;
    $2->real_value = -$2->real_value;
    add_child($$, $2);
  }
	| STRINGCONST
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
  }
	| LPAREN expression RPAREN
  {
    $$ = new_node(FACTOR);
    add_child($$, $2);
  }
	| NOT factor
  {
    $$ = new_node(FACTOR);
    add_child($$, $2);
  };

addop : PLUS
  {
    $$ = new_node(ADDOP);
    add_child($$, $1);
  }
	| MINUS
  {
    $$ = new_node(ADDOP);
    add_child($$, $1);
  };

mulop : STAR
  {
    $$ = new_node(MULOP);
    add_child($$, $1);
  }
	| SLASH
  {
    $$ = new_node(MULOP);
    add_child($$, $1);
  };

relop : LT
  {
    $$ = new_node(RELOP);
  }
	| GT
  {
    $$ = new_node(RELOP);
  }
	| EQUAL
  {
    $$ = new_node(RELOP);
  }
	| LE
  {
    $$ = new_node(RELOP);
  }
	| GE
  {
    $$ = new_node(RELOP);
  }
	| notEQUAL
  {
    $$ = new_node(RELOP);
  };

lambda :
  {
    $$ = new_node(LAMBDA);
  };

%%

int main(int argc, char **argv) {
  int flag = yyparse();
  if(flag == 0) {
    printf("***********************************\n");
    printf("*         No parse error!         *\n");
    printf("***********************************\n");
    print_tree(ASTROOT, 0);
    printf("***********************************\n");
    printf("*         No syntax error!        *\n");
    printf("***********************************\n");
    flag = semantic_check(ASTROOT);
    if(flag == 0) {
      printf("***********************************\n");
      printf("*        No semantic error!       *\n");
      printf("***********************************\n");
    } else {
      printf("SEMANTIC ERROR\n");
    }
  } else {
    printf("PARSE ERROR\n");
  }
  return 0;
}
