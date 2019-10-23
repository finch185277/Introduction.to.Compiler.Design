%{

#include <stdio.h>

int yylex(void);
int yywrap() { return 1; }
void yyerror(const char* msg) {
  extern int yylineno;
  fprintf(stderr, "line %d: %s\n", yylineno, msg);
}

%}

%error-verbose

%start prog

%token ARRAY INTEGER REAL NUM STRING
%token COMMENT DO ELSE END FUNCTION IDENTIFIER IF NOT OF
%token PBEGIN PROCEDURE PROGRAM THEN VAR WHILE
%token ASSIGNMENT COLON COMMA DOT DOTDOT EQUAL GE GT
%token LBRAC LE LPAREN LT MINUS PLUS RBRAC RPAREN
%token SEMICOLON SLASH STAR notEQUAL

%left PLUS MINUS
%left STAR SLASH

%%

prog : PROGRAM IDENTIFIER LPAREN identifier_list RPAREN SEMICOLON
	declarations
	subprogram_declarations
	compound_statement DOT
  ;


identifier_list : IDENTIFIER
	| identifier_list COMMA IDENTIFIER
  ;

declarations : declarations VAR identifier_list COLON type SEMICOLON
	| lambda
  ;


type : standard_type
	| ARRAY LBRAC NUM DOTDOT NUM RBRAC OF type
  ;

standard_type : INTEGER
	| REAL
	| STRING
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
	| PLUS NUM
	| MINUS NUM
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

int main(int argc, char **argv) {
  int flag = yyparse();
  if(flag == 0) {
    printf("OK\n");
  } else {
    printf("ERROR\n");
  }
  return 0;
}
