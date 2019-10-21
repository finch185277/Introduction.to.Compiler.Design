%{

#include <stdio.h>
#include "node.hpp"
int yylex(void);
int yywrap() { return 1; }
void yyerror(const char* str) { fprintf(stderr, "error: %s\n", str); }

struct Node *ASTROOT;

%}

%union{ struct Node *node; }

%token <node> ARRAY INTEGER REAL NUM STRING
%token <node> COMMENT DO ELSE END FUNCTION IDENTIFIER IF NOT OF
%token <node> PBEGIN PROCEDURE PROGRAM THEN VAR WHILE
%token <node> ASSIGNMENT COLON COMMA DOT DOTDOT EQUAL GE GT
%token <node> LBRAC LE LPAREN LT MINUS PLUS RBRAC RPAREN
%token <node> SEMICOLON SLASH STAR notEQUAL

%token <node> tail term factor addop nulop relop lambda prog type
%token <node> declarations arguments expression variable statement
%token <node> standard_type optional_var optional_statements simple_expression
%token <node> identifier_list expression_list statement_list parameter_list
%token <node> subprogram_declaration subprogram_declarations subprogram_head
%token <node> compound_statement procedure_statement

%left PLUS MINUS STAR SLASH

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
    printf("[Reduction] prog: PROGRAM id ( identifier_list ) ; ");
    printf("declarations subprogram_declarations compound_statement .\n");
  };


identifier_list : IDENTIFIER
  {
    $$ = new_node("identifier_list");
    add_child($$, new_node("IDENTIFIER"));
    printf("[Reduction] identifier_list: id\n");
  }
	| identifier_list COMMA IDENTIFIER
  {
    $$ = new_node("identifier_list");
    add_child($$, $1);
    add_child($$, new_node("COMMA"));
    add_child($$, new_node("IDENTIFIER"));
    printf("[Reduction] identifier_list: identifier_list , id\n");
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
    printf("[Reduction] declarations: ");
    printf("declarations VAR identifier_list : type ;\n");
  }
	| lambda
  {
    $$ = new_node("declarations");
    add_child($$, $1);
    printf("[Reduction] declarations: lambda\n");
  };


type : standard_type
  {
    $$ = new_node("type");
    add_child($$, $1);
    printf("[Reduction] type: standard_type\n");
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
    printf("[Reduction] type: ARRAY [ num .. num ] OF type\n");
  };

standard_type : INTEGER
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("INTEGER"));
    printf("[Reduction] standard_type: INTEGER\n");
  }
	| REAL
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("REAL"));
    printf("[Reduction] standard_type: REAL\n");
  }
	| STRING
  {
    $$ = new_node("standard_type");
    add_child($$, new_node("STRING"));
    printf("[Reduction] standard_type: STRING\n");
  };

subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON
  {
    $$ = new_node("subprogram_declarations");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, new_node("SEMICOLON"));
    printf("[Reduction] subprogram_declarations: ");
    printf("subprogram_declarations subprogram_declaration ;\n");
  }
	| lambda
  {
    $$ = new_node("subprogram_declarations");
    add_child($$, $1);
    printf("[Reduction] subprogram_declarations: lambda\n");
  };

subprogram_declaration :
	subprogram_head
	declarations
	compound_statement
  {
    $$ = new_node("subprogram_declaration");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, $3);
    printf("[Reduction] subprogram_declaration: ");
    printf("subprogram_head declarations compound_statement\n");
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
    printf("[Reduction] subprogram_head: ");
    printf("FUNCTION id arguments : standard_type ;\n");

  }
	| PROCEDURE IDENTIFIER arguments SEMICOLON
  {
    $$ = new_node("subprogram_head");
    add_child($$, new_node("PROCEDURE"));
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $3);
    add_child($$, new_node("SEMICOLON"));
    printf("[Reduction] subprogram_head: PROCEDURE id arguments ;\n");
  };


arguments : LPAREN parameter_list RPAREN
  {
    $$ = new_node("arguments");
    add_child($$, new_node("LPAREN"));
    add_child($$, $2);
    add_child($$, new_node("RPAREN"));
    printf("[Reduction] arguments: ( parameter_list )\n");
  }
	| lambda
  {
    $$ = new_node("arguments");
    add_child($$, $1);
    printf("[Reduction] arguments: lambda\n");
  };


parameter_list : optional_var identifier_list COLON type
  {
    $$ = new_node("parameter_list");
    add_child($$, $1);
    add_child($$, $2);
    add_child($$, new_node("COLON"));
    add_child($$, $4);
    printf("[Reduction] parameter_list: optional_var identifier_list : type\n");
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
    printf("[Reduction] parameter_list: ");
    printf("optional_var identifier_list : type ; parameter_list\n");
  };

optional_var : VAR
  {
    $$ = new_node("optional_var");
    add_child($$, new_node("VAR"));
    printf("[Reduction] optional_var: VAR\n");
  }
	| lambda
  {
    $$ = new_node("optional_var");
    add_child($$, $1);
    printf("[Reduction] optional_var: lambda\n");
  };

compound_statement : PBEGIN optional_statements END
  {
    $$ = new_node("compound_statement");
    add_child($$, new_node("PBEGIN"));
    add_child($$, $2);
    add_child($$, new_node("END"));
    printf("[Reduction] compound_statement: begin optional_statements end\n");
  };

optional_statements : statement_list
  {
    $$ = new_node("optional_statements");
    add_child($$, $1);
    printf("[Reduction] optional_statements: statement_list\n");
  }
	| lambda
  {
    $$ = new_node("optional_statements");
    add_child($$, $1);
    printf("[Reduction] optional_statements: lambda\n");
  };

statement_list : statement
  {
    $$ = new_node("statement_list");
    add_child($$, $1);
    printf("[Reduction] statement_list: statement\n");
  }
	| statement_list SEMICOLON statement
  {
    $$ = new_node("statement_list");
    add_child($$, $1);
    add_child($$, new_node("SEMICOLON"));
    add_child($$, $3);
    printf("[Reduction] statement_list: statement_list ; statement\n");
  };

statement : variable ASSIGNMENT expression
  {
    $$ = new_node("statement");
    add_child($$, $1);
    add_child($$, new_node("ASSIGNMENT"));
    add_child($$, $3);
    printf("[Reduction] statement: variable := expression\n");
  }
	| procedure_statement
  {
    $$ = new_node("statement");
    add_child($$, $1);
    printf("[Reduction] statement: procedure_statement\n");
  }
	| compound_statement
  {
    $$ = new_node("statement");
    add_child($$, $1);
    printf("[Reduction] statement: compound_statement\n");
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
    printf("[Reduction] statement: ");
    printf("IF expression THEN statement ELSE statement\n");
  }
	| WHILE expression DO statement
  {
    $$ = new_node("statement");
    add_child($$, new_node("WHILE"));
    add_child($$, $2);
    add_child($$, new_node("DO"));
    add_child($$, $4);
    printf("[Reduction] statement: WHILE expression DO statement\n");
  }
	| lambda
  {
    $$ = new_node("statement");
    add_child($$, $1);
    printf("[Reduction] statement: lambda\n");
  };

variable : IDENTIFIER tail
  {
    $$ = new_node("variable");
    add_child($$, new_node("IDENTIFIER"));
    add_child($$, $2);
    printf("[Reduction] variable: id tail\n");
  };

tail : LBRAC expression RBRAC tail
  {
    $$ = new_node("tail");
    add_child($$, new_node("LBRAC"));
    add_child($$, $2);
    add_child($$, new_node("RBRAC"));
    add_child($$, $4);
    printf("[Reduction] tail: [ expression ] tail\n");
  }
	| lambda {
    $$ = new_node("tail");
    add_child($$, $1);
    printf("[Reduction] tail: lambda\n");
  };

procedure_statement : IDENTIFIER
	| IDENTIFIER LPAREN expression_list RPAREN
	;

expression_list : expression
	| expression_list COMMA expression
	;

expression : simple_expression
	| simple_expression relop simple_expression
	;

simple_expression : term
	| simple_expression addop term
	;

term : factor
	| term mulop factor
	;

factor : IDENTIFIER tail
	| IDENTIFIER LPAREN expression_list RPAREN
	| NUM
	| STRING
	| LPAREN expression RPAREN
	| NOT factor
	;

addop : PLUS
	| MINUS
	;

mulop : STAR
	| SLASH
	;

relop : LT
	| GT
	| EQUAL
	| LE
	| GE
	| notEQUAL
	;

lambda :
	;

%%

int main(int argc, char **argv) { yyparse(); return 0; }
