%{

#include <stdio.h>
#include "node.h"

int yylex(void);
int yywrap() { return 1; }
void yyerror(const char* msg) {
  extern int yylineno;
  extern char* token_content;
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
    $$ = new_node("prog");
    add_child($$, new_node("PROGRAM"));
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, new_node("LPAREN"));
    add_child($$, $4);
    add_child($$, new_node("RPAREN"));
    add_child($$, new_node("SEMICOLON"));
    add_child($$, $7);
    add_child($$, $8);
    add_child($$, $9);
    add_child($$, new_node("DOT"));
    ASTROOT = $$;
  };


identifier_list : IDENTIFIER
  {
    $$ = new_node("identifier_list");
    add_child($$, new_node("IDENTIFIER"));
  }
	| identifier_list COMMA IDENTIFIER
  {
    $$ = new_node("identifier_list");
    add_child($$, $1);
    add_child($$, new_node("COMMA"));
    add_child($$, new_node("IDENTIFIER"));
  };

declarations : declarations VAR identifier_list COLON type SEMICOLON
  {
    $$ = new_node("declarations");
    add_child($$, $1);
    add_child($$, new_node("VAR"));
    add_child($$, $3);
    add_child($$, new_node("COLON"));
    add_child($$, $5);
    add_child($$, new_node("SEMICOLON"));
  }
	| lambda
  {
    $$ = new_node("declarations");
    add_child($$, $1);
  };


type : standard_type
  {
    $$ = new_node("type");
    add_child($$, $1);
  }
	| ARRAY LBRAC NUM DOTDOT NUM RBRAC OF type
  {
    $$ = new_node("type");
    add_child($$, new_node("ARRAY"));
    add_child($$, new_node("LBRAC"));
    add_child($$, new_node("NUM"));
    add_child($$, new_node("DOTDOT"));
    add_child($$, new_node("NUM"));
    add_child($$, new_node("RBRAC"));
    add_child($$, new_node("OF"));
    add_child($$, $8);
  };

standard_type : INTEGER
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("INTEGER"));
  }
	| REAL
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("REAL"));
  }
	| STRING
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("STRING"));
  };

subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON
  {
    $$ = new_node("subprogram_declarations");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, new_node("SEMICOLON"));
  }
	| lambda
  {
    $$ = new_node("subprogram_declarations");
    add_child($$, $1);
  };

subprogram_declaration :
	subprogram_head
	declarations
	subprogram_declarations
	compound_statement
  {
    $$ = new_node("subprogram_declaration");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
    add_child($$, $4);
  };

subprogram_head : FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON
  {
    $$ = new_node("subprogram_head");
    add_child($$, new_node("FUNCTION"));
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $3);
    add_child($$, new_node("COLON"));
    add_child($$, $5);
    add_child($$, new_node("SEMICOLON"));

  }
	| PROCEDURE IDENTIFIER arguments SEMICOLON
  {
    $$ = new_node("subprogram_head");
    add_child($$, new_node("PROCEDURE"));
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $3);
    add_child($$, new_node("SEMICOLON"));
  };


arguments : LPAREN parameter_list RPAREN
  {
    $$ = new_node("arguments");
    add_child($$, new_node("LPAREN"));
    add_child($$, $2);
    add_child($$, new_node("RPAREN"));
  }
	| lambda
  {
    $$ = new_node("arguments");
    add_child($$, $1);
  };


parameter_list : optional_var identifier_list COLON type
  {
    $$ = new_node("parameter_list");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, new_node("COLON"));
    add_child($$, $4);
  }
	| optional_var identifier_list COLON type SEMICOLON parameter_list
  {
    $$ = new_node("parameter_list");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, new_node("COLON"));
    add_child($$, $4);
    add_child($$, new_node("SEMICOLON"));
    add_child($$, $6);
  };

optional_var : VAR
  {
    $$ = new_node("optional_var");
    add_child($$, new_node("VAR"));
  }
	| lambda
  {
    $$ = new_node("optional_var");
    add_child($$, $1);
  };

compound_statement : PBEGIN optional_statements END
  {
    $$ = new_node("compound_statement");
    add_child($$, new_node("PBEGIN"));
    add_child($$, $2);
    add_child($$, new_node("END"));
  };

optional_statements : statement_list
  {
    $$ = new_node("optional_statements");
    add_child($$, $1);
  };

statement_list : statement
  {
    $$ = new_node("statement_list");
    add_child($$, $1);
  }
	| statement_list SEMICOLON statement
  {
    $$ = new_node("statement_list");
    add_child($$, $1);
    add_child($$, new_node("SEMICOLON"));
    add_child($$, $3);
  };

statement : variable ASSIGNMENT expression
  {
    $$ = new_node("statement");
    add_child($$, $1);
    add_child($$, new_node("ASSIGNMENT"));
    add_child($$, $3);
  }
	| procedure_statement
  {
    $$ = new_node("statement");
    add_child($$, $1);
  }
	| compound_statement
  {
    $$ = new_node("statement");
    add_child($$, $1);
  }
	| IF expression THEN statement ELSE statement
  {
    $$ = new_node("statement");
    add_child($$, new_node("IF"));
    add_child($$, $2);
    add_child($$, new_node("THEN"));
    add_child($$, $4);
    add_child($$, new_node("ELSE"));
    add_child($$, $6);
  }
	| WHILE expression DO statement
  {
    $$ = new_node("statement");
    add_child($$, new_node("WHILE"));
    add_child($$, $2);
    add_child($$, new_node("DO"));
    add_child($$, $4);
  }
	| lambda
  {
    $$ = new_node("statement");
    add_child($$, $1);
  };

variable : IDENTIFIER tail
  {
    $$ = new_node("variable");
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $2);
  };

tail : LBRAC expression RBRAC tail
  {
    $$ = new_node("tail");
    add_child($$, new_node("LBRAC"));
    add_child($$, $2);
    add_child($$, new_node("RBRAC"));
    add_child($$, $4);
  }
	| lambda {
    $$ = new_node("tail");
    add_child($$, $1);
  };

procedure_statement : IDENTIFIER
  {
    $$ = new_node("procedure_statement");
    add_child($$, new_node("IDENTIFIER"));
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node("procedure_statement");
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, new_node("LBRAC"));
    add_child($$, $3);
    add_child($$, new_node("RPAREN"));
  };

expression_list : expression
  {
    $$ = new_node("expression_list");
    add_child($$, $1);
  }
	| expression_list COMMA expression
  {
    $$ = new_node("expression_list");
    add_child($$, $1);
    add_child($$, new_node("COMMA"));
    add_child($$, $3);
  };

  expression : boolexpression
  {
    $$ = new_node("expression");
    add_child($$, $1);
  }
	| boolexpression AND boolexpression
  {
    $$ = new_node("expression");
    add_child($$, $1);
    add_child($$, new_node("AND"));
    add_child($$, $3);
  }
	| boolexpression OR boolexpression
  {
    $$ = new_node("expression");
    add_child($$, $1);
    add_child($$, new_node("OR"));
    add_child($$, $3);
  };

  boolexpression : simple_expression
  {
    $$ = new_node("boolexpression");
    add_child($$, $1);
  }
	| simple_expression relop simple_expression
  {
    $$ = new_node("boolexpression");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
  };

simple_expression : term
  {
    $$ = new_node("simple_expression");
    add_child($$, $1);
  }
	| simple_expression addop term
  {
    $$ = new_node("simple_expression");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
  };

term : factor
  {
    $$ = new_node("term");
    add_child($$, $1);
  }
	| term mulop factor
  {
    $$ = new_node("term");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
  };

factor : IDENTIFIER tail
  {
    $$ = new_node("factor");
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $2);
  }
	| IDENTIFIER LPAREN expression_list RPAREN
  {
    $$ = new_node("factor");
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, new_node("LPAREN"));
    add_child($$, $3);
    add_child($$, new_node("RPAREN"));
  }
	| NUM
  {
    $$ = new_node("factor");
    add_child($$, new_node("NUM"));
  }
  | PLUS NUM
  {
    $$ = new_node("factor");
    add_child($$, new_node("NUM"));
  }
  | MINUS NUM
  {
    $$ = new_node("factor");
    add_child($$, new_node("NUM"));
  }
	| STRING
  {
    $$ = new_node("factor");
    add_child($$, new_node("STRING"));
  }
	| LPAREN expression RPAREN
  {
    $$ = new_node("factor");
    add_child($$, new_node("LPAREN"));
    add_child($$, $2);
    add_child($$, new_node("RPAREN"));
  }
	| NOT factor
  {
    $$ = new_node("factor");
    add_child($$, new_node("NOT"));
    add_child($$, $2);
  };

addop : PLUS
  {
    $$ = new_node("addop");
    add_child($$, new_node("PLUS"));
  }
	| MINUS
  {
    $$ = new_node("addop");
    add_child($$, new_node("MINUS"));
  };

mulop : STAR
  {
    $$ = new_node("mulop");
    add_child($$, new_node("STAR"));
  }
	| SLASH
  {
    $$ = new_node("mulop");
    add_child($$, new_node("SLASH"));
  };

relop : LT
  {
    $$ = new_node("relop");
    add_child($$, new_node("LT"));
  }
	| GT
  {
    $$ = new_node("relop");
    add_child($$, new_node("GT"));
  }
	| EQUAL
  {
    $$ = new_node("relop");
    add_child($$, new_node("EQUAL"));
  }
	| LE
  {
    $$ = new_node("relop");
    add_child($$, new_node("LE"));
  }
	| GE
  {
    $$ = new_node("relop");
    add_child($$, new_node("GE"));
  }
	| notEQUAL
  {
    $$ = new_node("relop");
    add_child($$, new_node("notEQUAL"));
  };

lambda :
  {
    $$ = new_node("lambda");
  };

%%

int main(int argc, char **argv) {
  int flag = yyparse();
  if(flag == 0) {
    printf("SUCCESS\n");
    printf("------------------------- AST -------------------------\n");
    print_tree(ASTROOT, 0);
    printf("------------------------- END -------------------------\n");
  } else {
    printf("ERROR\n");
  }
  return 0;
}
