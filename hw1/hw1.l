%{
/*
 * scan.l
 *
 * lex input file for pascal scanner
 *
 * extensions: two ways to spell "external" and "->" ok for "^".
*/

#include <stdio.h>

#define   ARRAY                   1
#define   INTEGER                 2
#define   REAL                    3
#define   NUM                     4
#define   STRINGCONST             5

#define   COMMENT                 6  // should be ignore
#define   DO                      7
#define   ELSE                    8
#define   END                     9
#define   FUNCTION               10
#define   ID                     11
#define   IF                     12
#define   NOT                    13
#define   OF                     14
#define   PBEGIN                 15  // BEGIN redefined in lex.yy.c
#define   PROCEDURE              16
#define   PROGRAM                17
#define   THEN                   18
#define   VAR                    19
#define   WHILE                  20

#define   ASSIGNMENT             21
#define   COLON                  22
#define   COMMA                  23
#define   DOT                    24
#define   DOTDOT                 25
#define   EQUAL                  26
#define   GE                     27
#define   GT                     28
#define   LBRAC                  29
#define   LE                     30
#define   LPAREN                 31
#define   LT                     32
#define   MINUS                  33
#define   PLUS                   34
#define   RBRAC                  35
#define   RPAREN                 36
#define   SEMICOLON              37
#define   SLASH                  38
#define   STAR                   39
#define   notEQUAL               40


int line_no = 1;


%}

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
NQUOTE [^']

%%

{A}{R}{R}{A}{Y}                        return(ARRAY);
{D}{O}                                 return(DO);
{E}{L}{S}{E}                           return(ELSE);
{E}{N}{D}                              return(END);
{F}{U}{N}{C}{T}{I}{O}{N}               return(FUNCTION);
{I}{F}                                 return(IF);
{I}{N}{T}{E}{G}{E}{R}                  return(INTEGER);
{N}{O}{T}                              return(NOT);
{O}{F}                                 return(OF);
{B}{E}{G}{I}{N}                        return(PBEGIN);
{P}{R}{O}{C}{E}{D}{U}{R}{E}            return(PROCEDURE);
{P}{R}{O}{G}{R}{A}{M}                  return(PROGRAM);
{R}{E}{A}{L}                           return(REAL);
{T}{H}{E}{N}                           return(THEN);
{V}{A}{R}                              return(VAR);
{W}{H}{I}{L}{E}                        return(WHILE);

":="                                   return(ASSIGNMENT);
":"                                    return(COLON);
","                                    return(COMMA);
"."                                    return(DOT);
".."                                   return(DOTDOT);
"="                                    return(EQUAL);
"!="                                   return(notEQUAL);
">="                                   return(GE);
">"                                    return(GT);
"["                                    return(LBRAC);
"<="                                   return(LE);
"("                                    return(LPAREN);
"<"                                    return(LT);
"-"                                    return(MINUS);
"+"                                    return(PLUS);
"]"                                    return(RBRAC);
")"                                    return(RPAREN);
";"                                    return(SEMICOLON);
"/"                                    return(SLASH);
"*"                                    return(STAR);

[a-zA-Z]([a-zA-Z0-9_])*                return(ID);
\/\/.*$                                {fprintf(stderr, "Comment at line %d: %s\n", line_no, yytext);}
(\/\*)(.|\n)*(\*\/)                    {fprintf(stderr, "Comment at line %d: %s\n", line_no, yytext);}
[+-]?[0-9]+                            return(NUM);
[+-]?[0-9]+\.[0-9]+                    return(NUM);
[+-]?[0-9]+(\.[0-9]+)?E[+-]?[0-9]+     return(NUM);
\"[^\"\n]*\"                           return(STRINGCONST);

[ \t\f]    ;

\r         ;
\n    line_no++;

.    {fprintf(stderr, "Lexical analyzer error at line %d : %s\n", line_no, yytext);}

%%

int main(int argc, char **argv) {
  int i, tok;
  yyin = fopen(argv[1], "r");
  for (i = 0; 1 == 1; i++) {
    tok = yylex();
    fprintf(stderr, "%3d-th token(type:%d) on line %d : %s\n", i, tok, line_no,
            yytext);
  }
  return (0);
} /* end of main */

int yywrap() {
  fclose(yyin);
  exit(1);
}
