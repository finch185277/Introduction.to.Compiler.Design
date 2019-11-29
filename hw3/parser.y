%{

#include <stdio.h>
#include "node.h"

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

%token <node> ARRAY INTEGER REAL NUM STRING
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
    add_child($$, $2);
    add_child($$, $4);
    add_child($$, $7);
    add_child($$, $8);
    add_child($$, $9);
    ASTROOT = $$;
    printf("[Reduction] | prog: PROGRAM id ( identifier_list ) ; ");
    printf("declarations subprogram_declarations compound_statement .\n");
  };


identifier_list : IDENTIFIER
  {
    $$ = new_node(ID_LIST);
    add_child($$, $1);
    printf("[Reduction] | identifier_list: id\n");
  }
	| identifier_list COMMA IDENTIFIER
  {
    $$ = $1;
    add_child($$, $3);
    printf("[Reduction] | identifier_list: identifier_list , id\n");
  };

declarations : declarations VAR identifier_list COLON type SEMICOLON
  {
    $$ = $1;
    add_child($$, $3);
    add_child($$, $5);
    printf("[Reduction] | declarations: ");
    printf("declarations VAR identifier_list : type ;\n");
  }
	| lambda
  {
    $$ = new_node(DECLS);
    add_child($$, $1);
    printf("[Reduction] | declarations: lambda\n");
  };


type : standard_type
  {
    $$ = new_node(TYPE);
    add_child($$, $1);
    printf("[Reduction] | type: standard_type\n");
  }
	| ARRAY LBRAC NUM DOTDOT NUM RBRAC OF type
  {
    $$ = $8;
    add_child($$, new_node(TYPE_ARRAY));
    add_child($$, $3);
    add_child($$, $5);
    printf("[Reduction] | type: ARRAY [ num .. num ] OF type\n");
  };

standard_type : INTEGER
  {
    $$ = new_node(STD_TYPE);
    add_child($$, $1);
    printf("[Reduction] | standard_type: INTEGER\n");
  }
	| REAL
  {
    $$ = new_node(STD_TYPE);
    add_child($$, $1);
    printf("[Reduction] | standard_type: REAL\n");
  }
	| STRING
  {
    $$ = new_node(STD_TYPE);
    add_child($$, $1);
    printf("[Reduction] | standard_type: STRING\n");
  };

subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON
  {
    $$ = $1;
    add_child($$, $2);
    printf("[Reduction] | subprogram_declarations: ");
    printf("subprogram_declarations subprogram_declaration ;\n");
  }
	| lambda
  {
    $$ = new_node(SUBPROG_DECLS);
    add_child($$, $1);
    printf("[Reduction] | subprogram_declarations: lambda\n");
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
    printf("[Reduction] | subprogram_declaration: ");
    printf("subprogram_head declarations ");
    printf("subprogram_declarations compound_statement\n");
  };

subprogram_head : FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON
  {
    $$ = new_node(SUBPROG_HEAD);
    add_child($$, $2);
    add_child($$, $3);
    add_child($$, $5);
    printf("[Reduction] | subprogram_head: ");
    printf("FUNCTION id arguments : standard_type ;\n");

  }
	| PROCEDURE IDENTIFIER arguments SEMICOLON
  {
    $$ = new_node(SUBPROG_HEAD);
    add_child($$, $2);
    add_child($$, $3);
    printf("[Reduction] | subprogram_head: PROCEDURE id arguments ;\n");
  };


arguments : LPAREN parameter_list RPAREN
  {
    $$ = new_node(ARGS);
    add_child($$, $2);
    printf("[Reduction] | arguments: ( parameter_list )\n");
  }
	| lambda
  {
    $$ = new_node(ARGS);
    add_child($$, $1);
    printf("[Reduction] | arguments: lambda\n");
  };


parameter_list : optional_var identifier_list COLON type
  {
    $$ = new_node(PARA_LIST);
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $4);
    printf("[Reduction] | parameter_list: optional_var identifier_list : type\n");
  }
	| optional_var identifier_list COLON type SEMICOLON parameter_list
  {
    $$ = $6;
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $4);
    printf("[Reduction] | parameter_list: ");
    printf("optional_var identifier_list : type ; parameter_list\n");
  };

optional_var : VAR
  {
    $$ = new_node(OPT_VAR);
    printf("[Reduction] | optional_var: VAR\n");
  }
	| lambda
  {
    $$ = new_node(OPT_VAR);
    printf("[Reduction] | optional_var: lambda\n");
  };

compound_statement : PBEGIN optional_statements END
  {
    $$ = new_node(COMPOUND_STMT);
    add_child($$, $2);
    printf("[Reduction] | compound_statement: begin optional_statements end\n");
  };

optional_statements : statement_list
  {
    $$ = new_node(OPT_STMTS);
    add_child($$, $1);
    printf("[Reduction] | optional_statements: statement_list\n");
  };

statement_list : statement
  {
    $$ = new_node(STMT_LIST);
    add_child($$, $1);
    printf("[Reduction] | statement_list: statement\n");
  }
	| statement_list SEMICOLON statement
  {
    $$ = $1;
    add_child($$, $3);
    printf("[Reduction] | statement_list: statement_list ; statement\n");
  };

statement : variable ASSIGNMENT expression
  {
    $$ = new_node(STMT);
    add_child($$, $1);
    add_child($$, $3);
    printf("[Reduction] | statement: variable := expression\n");
  }
	| procedure_statement
  {
    $$ = new_node(STMT);
    add_child($$, $1);
    printf("[Reduction] | statement: procedure_statement\n");
  }
	| compound_statement
  {
    $$ = new_node(STMT);
    add_child($$, $1);
    printf("[Reduction] | statement: compound_statement\n");
  }
	| IF expression THEN statement ELSE statement
  {
    $$ = $4;
    add_child($$, $2);
    add_child($$, $6);
    printf("[Reduction] | statement: ");
    printf("IF expression THEN statement ELSE statement\n");
  }
	| WHILE expression DO statement
  {
    $$ = $4;
    add_child($$, $2);
    printf("[Reduction] | statement: WHILE expression DO statement\n");
  }
	| lambda
  {
    $$ = new_node(STMT);
    add_child($$, $1);
    printf("[Reduction] | statement: lambda\n");
  };

variable : IDENTIFIER tail
  {
    $$ = new_node(VARIABLE);
    add_child($$, $1);
    add_child($$, $2);
    printf("[Reduction] | variable: id tail\n");
  };

tail : LBRAC expression RBRAC tail
  {
    $$ = $4;
    add_child($$, $2);
    printf("[Reduction] | tail: [ expression ] tail\n");
  }
	| lambda
  {
    $$ = new_node(TAIL);
    add_child($$, $1);
    printf("[Reduction] | tail: lambda\n");
  };

procedure_statement : IDENTIFIER
  {
    $$ = new_node(PROC_STMT);
    add_child($$, $1);
    printf("[Reduction] | procedure_statement: id\n");
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node(PROC_STMT);
    add_child($$, $1);
    add_child($$, $3);
    printf("[Reduction] | procedure_statement: id ( expression_list )\n");
  };

expression_list : expression
  {
    $$ = new_node(EXPR_LIST);
    add_child($$, $1);
    printf("[Reduction] | expression_list: expression\n");
  }
	| expression_list COMMA expression
  {
    $$ = $1;
    add_child($$, $3);
    printf("[Reduction] | expression_list: expression_list , expression\n");
  };

  expression : boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
    printf("[Reduction] | expression: boolexpression\n");
  }
	| boolexpression AND boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
    add_child($$, $3);
    printf("[Reduction] | expression: ");
    printf("boolexpression AND boolexpression\n");
  }
	| boolexpression OR boolexpression
  {
    $$ = new_node(EXPR);
    add_child($$, $1);
    add_child($$, $3);
    printf("[Reduction] | expression: ");
    printf("boolexpression OR boolexpression\n");
  };

  boolexpression : simple_expression
  {
    $$ = new_node(BOOL_EXPR);
    add_child($$, $1);
    printf("[Reduction] | boolexpression: simple_expression\n");
  }
	| simple_expression relop simple_expression
  {
    $$ = new_node(BOOL_EXPR);
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
    printf("[Reduction] | boolexpression: ");
    printf("simple_expression relop simple_expression\n");
  };

simple_expression : term
  {
    $$ = new_node(SIMPLE_EXPR);
    add_child($$, $1);
    printf("[Reduction] | simple_expression: term\n");
  }
	| simple_expression addop term
  {
    $$ = $1;
    add_child($$, $2);
    add_child($$, $3);
    printf("[Reduction] | simple_expression: simple_expression addop term\n");
  };

term : factor
  {
    $$ = new_node(TERM);
    add_child($$, $1);
    printf("[Reduction] | term: factor\n");
  }
	| term mulop factor
  {
    $$ = $1;
    add_child($$, $2);
    add_child($$, $3);
    printf("[Reduction] | term: term mulop factor\n");
  };

factor : IDENTIFIER tail
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $2);
    printf("[Reduction] | factor: id tail\n");
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $3);
    printf("[Reduction] | factor: id ( expression_list )\n");
  }
	| NUM
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    printf("[Reduction] | factor: num\n");
  }
  | PLUS NUM
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $2);
    printf("[Reduction] | factor: positive num\n");
  }
  | MINUS NUM
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    add_child($$, $2);
    printf("[Reduction] | factor: negative num\n");
  }
	| STRING
  {
    $$ = new_node(FACTOR);
    add_child($$, $1);
    printf("[Reduction] | factor: stringconstant\n");
  }
	| LPAREN expression RPAREN
  {
    $$ = new_node(FACTOR);
    add_child($$, $2);
    printf("[Reduction] | factor: ( expression )\n");
  }
	| NOT factor
  {
    $$ = new_node(FACTOR);
    add_child($$, $2);
    printf("[Reduction] | factor: not factor\n");
  };

addop : PLUS
  {
    $$ = new_node(ADDOP);
    printf("[Reduction] | addop: +\n");
  }
	| MINUS
  {
    $$ = new_node(ADDOP);
    printf("[Reduction] | addop: -\n");
  };

mulop : STAR
  {
    $$ = new_node(MULOP);
    printf("[Reduction] | mulop: *\n");
  }
	| SLASH
  {
    $$ = new_node(MULOP);
    printf("[Reduction] | mulop: /\n");
  };

relop : LT
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: <\n");
  }
	| GT
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: >\n");
  }
	| EQUAL
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: =\n");
  }
	| LE
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: <=\n");
  }
	| GE
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: >=\n");
  }
	| notEQUAL
  {
    $$ = new_node(RELOP);
    printf("[Reduction] | relop: !=\n");
  };

lambda :
  {
    $$ = new_node(LAMBDA);
    printf("[Reduction] | lambda:\n");
  };

%%

int main(int argc, char **argv) {
  int flag = yyparse();
  if(flag == 0) {
    printf("SUCCESS\n");
    print_tree(ASTROOT, 0);
    printf("***********************************\n");
    printf("*         No syntax error!        *\n");
    printf("***********************************\n");
    printf("***********************************\n");
    printf("*        No semantic error!       *\n");
    printf("***********************************\n");
  } else {
    printf("ERROR\n");
  }
  return 0;
}
