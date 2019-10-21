%{

#include <stdio.h>
#include "node.hpp"
int yylex(void);
int yywrap() { return 1; }
void yyerror(const char* str) { fprintf(stderr, "error: %s\n", str); }

struct Node *ASTROOT;

%}

%union{ struct Node *node; }

%token <node> ARRAY INTEGER REAL NUM STRINGCONST
%token <node> COMMENT DO ELSE END FUNCTION IDENTIFIER IF NOT OF
%token <node> PBEGIN PROCEDURE PROGRAM THEN VAR WHILE
%token <node> ASSIGNMENT COLON COMMA DOT DOTDOT EQUAL GE GT
%token <node> LBRAC LE LPAREN LT MINUS PLUS RBRAC RPAREN SEMICOLON SLASH STAR notEQUAL

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
	| ARRAY LBRAC NUM DOTDOT NUM RBRAC OF type
	;

standard_type : INTEGER
	| REAL
	| STRINGCONST
	;

subprogram_declarations :
	subprogram_declarations subprogram_declaration SEMICOLON
	| lambda
	;

subprogram_declaration :
	subprogram_head
	declarations
	compound_statement
	;

subprogram_head : FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON
	| PROCEDURE IDENTIFIER arguments SEMICOLON
	;


arguments : LPAREN parameter_list RPAREN
	| lambda
	;


parameter_list : optional_var identifier_list COLON type
	| optional_var identifier_list COLON type SEMICOLON parameter_list
	;

optional_var : VAR
	| lambda
	;

compound_statement : PBEGIN optional_statements END
	;

optional_statements : statement_list
	| lambda
	;

statement_list : statement
	| statement_list SEMICOLON statement
	;

statement : variable ASSIGNMENT expression
	| procedure_statement
	| compound_statement
	| IF expression THEN statement ELSE statement
	| WHILE expression DO statement
	| lambda
	;

variable : IDENTIFIER tail
	;

tail : LBRAC expression RBRAC tail
	| lambda
	;

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
	| STRINGCONST
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
