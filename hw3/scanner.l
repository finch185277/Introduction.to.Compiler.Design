%option yylineno

%{
/*
 * scan.l
 *
 * lex input file for pascal scanner
 *
 * extensions: two ways to spell "external" and "->" ok for "^".
*/

#include <stdio.h>
#include "y.tab.h"

char* token_content;

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

{A}{R}{R}{A}{Y}                       { printf("[  Shift  ] | ARRAY\n");
                                        token_content = strdup(yytext);
                                        return(ARRAY);
                                      }
{D}{O}                                { printf("[  Shift  ] | DO\n");
                                        token_content = strdup(yytext);
                                        return(DO);
                                      }
{E}{L}{S}{E}                          { printf("[  Shift  ] | ELSE\n");
                                        token_content = strdup(yytext);
                                        return(ELSE);
                                      }
{E}{N}{D}                             { printf("[  Shift  ] | END\n");
                                        token_content = strdup(yytext);
                                        return(END);
                                      }
{F}{U}{N}{C}{T}{I}{O}{N}              { printf("[  Shift  ] | FUNCTION\n");
                                        token_content = strdup(yytext);
                                        return(FUNCTION);
                                      }
{I}{F}                                { printf("[  Shift  ] | IF\n");
                                        token_content = strdup(yytext);
                                        return(IF);
                                      }
{I}{N}{T}{E}{G}{E}{R}                 { printf("[  Shift  ] | INTEGER\n");
                                        token_content = strdup(yytext);
                                        return(INTEGER);
                                      }
{N}{O}{T}                             { printf("[  Shift  ] | NOT\n");
                                        token_content = strdup(yytext);
                                        return(NOT);
                                      }
{O}{F}                                { printf("[  Shift  ] | OF\n");
                                        token_content = strdup(yytext);
                                        return(OF);
                                      }
{B}{E}{G}{I}{N}                       { printf("[  Shift  ] | PBEGIN\n");
                                        token_content = strdup(yytext);
                                        return(PBEGIN);
                                      }
{P}{R}{O}{C}{E}{D}{U}{R}{E}           { printf("[  Shift  ] | PROCEDURE\n");
                                        token_content = strdup(yytext);
                                        return(PROCEDURE);
                                      }
{P}{R}{O}{G}{R}{A}{M}                 { printf("[  Shift  ] | PROGRAM\n");
                                        token_content = strdup(yytext);
                                        return(PROGRAM);
                                      }
{R}{E}{A}{L}                          { printf("[  Shift  ] | REAL\n");
                                        token_content = strdup(yytext);
                                        return(REAL);
                                      }
{T}{H}{E}{N}                          { printf("[  Shift  ] | THEN\n");
                                        token_content = strdup(yytext);
                                        return(THEN);
                                      }
{V}{A}{R}                             { printf("[  Shift  ] | VAR\n");
                                        token_content = strdup(yytext);
                                        return(VAR);
                                      }
{W}{H}{I}{L}{E}                       { printf("[  Shift  ] | WHILE\n");
                                        token_content = strdup(yytext);
                                        return(WHILE);
                                      }

":="                                  { printf("[  Shift  ] | ASSIGNMENT\n");
                                        token_content = strdup(yytext);
                                        return(ASSIGNMENT);
                                      }
":"                                   { printf("[  Shift  ] | COLON\n");
                                        token_content = strdup(yytext);
                                        return(COLON);
                                      }
","                                   { printf("[  Shift  ] | COMMA\n");
                                        token_content = strdup(yytext);
                                        return(COMMA);
                                      }
"."                                   { printf("[  Shift  ] | DOT\n");
                                        token_content = strdup(yytext);
                                        return(DOT);
                                      }
".."                                  { printf("[  Shift  ] | DOTDOT\n");
                                        token_content = strdup(yytext);
                                        return(DOTDOT);
                                      }
"="                                   { printf("[  Shift  ] | EQUAL\n");
                                        token_content = strdup(yytext);
                                        return(EQUAL);
                                      }
"!="                                  { printf("[  Shift  ] | notEQUAL\n");
                                        token_content = strdup(yytext);
                                        return(notEQUAL);
                                      }
">="                                  { printf("[  Shift  ] | GE\n");
                                        token_content = strdup(yytext);
                                        return(GE);
                                      }
">"                                   { printf("[  Shift  ] | GT\n");
                                        token_content = strdup(yytext);
                                        return(GT);
                                      }
"["                                   { printf("[  Shift  ] | LBRAC\n");
                                        token_content = strdup(yytext);
                                        return(LBRAC);
                                      }
"<="                                  { printf("[  Shift  ] | LE\n");
                                        token_content = strdup(yytext);
                                        return(LE);
                                      }
"("                                   { printf("[  Shift  ] | LPAREN\n");
                                        token_content = strdup(yytext);
                                        return(LPAREN);
                                      }
"<"                                   { printf("[  Shift  ] | LT\n");
                                        token_content = strdup(yytext);
                                        return(LT);
                                      }
"-"                                   { printf("[  Shift  ] | MINUS\n");
                                        token_content = strdup(yytext);
                                        return(MINUS);
                                      }
"+"                                   { printf("[  Shift  ] | PLUS\n");
                                        token_content = strdup(yytext);
                                        return(PLUS);
                                      }
"]"                                   { printf("[  Shift  ] | RBRAC\n");
                                        token_content = strdup(yytext);
                                        return(RBRAC);
                                      }
")"                                   { printf("[  Shift  ] | RPAREN\n");
                                        token_content = strdup(yytext);
                                        return(RPAREN);
                                      }
";"                                   { printf("[  Shift  ] | SEMICOLON\n");
                                        token_content = strdup(yytext);
                                        return(SEMICOLON);
                                      }
"/"                                   { printf("[  Shift  ] | SLASH\n");
                                        token_content = strdup(yytext);
                                        return(SLASH);
                                      }
"*"                                   { printf("[  Shift  ] | STAR\n");
                                        token_content = strdup(yytext);
                                        return(STAR);
                                      }

[a-zA-Z]([a-zA-Z0-9_])*                 { printf("[  Shift  ] | IDENTIFIER\n");
                                          token_content = strdup(yytext);
                                          return(IDENTIFIER);
                                        }
[0-9]+                                  { printf("[  Shift  ] | NUM\n");
                                          token_content = strdup(yytext);
                                          return(NUM);
                                        }
[0-9]+\.[0-9]+                          { printf("[  Shift  ] | NUM\n");
                                          token_content = strdup(yytext);
                                          return(NUM);
                                        }
[0-9]+(\.[0-9]+)?E[+-]?[0-9]+           { printf("[  Shift  ] | NUM\n");
                                          token_content = strdup(yytext);
                                          return(NUM);
                                        }
\"((\\.)|[^\\\"\n])*\"                  { printf("[  Shift  ] | STRING\n");
                                          token_content = strdup(yytext);
                                          return(STRING);
                                        }

\/\/.*$                                 ;
"/*" { register int c;
      while ((c = input())) {
        if (c == '*') {
          if ((c = input()) == '/') {
            break;
          } else {
            unput (c);
          }
        } else if (c == 0) {
          fprintf (stderr, "Unexpected EOF inside comment at line %d\n", yylineno);
        }
      }
    }

[ \t\f]    ;

\r         ;
\n         ;

.    {fprintf(stderr, "Lexical analyzer error at line %d : %s\n", yylineno, yytext);}

%%
