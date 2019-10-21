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

{A}{R}{R}{A}{Y}                       { printf("[Shift] ARRAY\n");
                                        return(ARRAY);
                                      }
{D}{O}                                { printf("[Shift] DO\n");
                                        return(DO);
                                      }
{E}{L}{S}{E}                          { printf("[Shift] ELSE\n");
                                        return(ELSE);
                                      }
{E}{N}{D}                             { printf("[Shift] END\n");
                                        return(END);
                                      }
{F}{U}{N}{C}{T}{I}{O}{N}              { printf("[Shift] FUNCTION\n");
                                        return(FUNCTION);
                                      }
{I}{F}                                { printf("[Shift] IF\n");
                                        return(IF);
                                      }
{I}{N}{T}{E}{G}{E}{R}                 { printf("[Shift] INTEGER\n");
                                        return(INTEGER);
                                      }
{N}{O}{T}                             { printf("[Shift] NOT\n");
                                        return(NOT);
                                      }
{O}{F}                                { printf("[Shift] OF\n");
                                        return(OF);
                                      }
{B}{E}{G}{I}{N}                       { printf("[Shift] PBEGIN\n");
                                        return(PBEGIN);
                                      }
{P}{R}{O}{C}{E}{D}{U}{R}{E}           { printf("[Shift] PROCEDURE\n");
                                        return(PROCEDURE);
                                      }
{P}{R}{O}{G}{R}{A}{M}                 { printf("[Shift] PROGRAM\n");
                                        return(PROGRAM);
                                      }
{R}{E}{A}{L}                          { printf("[Shift] REAL\n");
                                        return(REAL);
                                      }
{T}{H}{E}{N}                          { printf("[Shift] THEN\n");
                                        return(THEN);
                                      }
{V}{A}{R}                             { printf("[Shift] VAR\n");
                                        return(VAR);
                                      }
{W}{H}{I}{L}{E}                       { printf("[Shift] WHILE\n");
                                        return(WHILE);
                                      }

":="                                  { printf("[Shift] ASSIGNMENT\n");
                                        return(ASSIGNMENT);
                                      }
":"                                   { printf("[Shift] COLON\n");
                                        return(COLON);
                                      }
","                                   { printf("[Shift] COMMA\n");
                                        return(COMMA);
                                      }
"."                                   { printf("[Shift] DOT\n");
                                        return(DOT);
                                      }
".."                                  { printf("[Shift] DOTDOT\n");
                                        return(DOTDOT);
                                      }
"="                                   { printf("[Shift] EQUAL\n");
                                        return(EQUAL);
                                      }
"!="                                  { printf("[Shift] notEQUAL\n");
                                        return(notEQUAL);
                                      }
">="                                  { printf("[Shift] GE\n");
                                        return(GE);
                                      }
">"                                   { printf("[Shift] GT\n");
                                        return(GT);
                                      }
"["                                   { printf("[Shift] LBRAC\n");
                                        return(LBRAC);
                                      }
"<="                                  { printf("[Shift] LE\n");
                                        return(LE);
                                      }
"("                                   { printf("[Shift] LPAREN\n");
                                        return(LPAREN);
                                      }
"<"                                   { printf("[Shift] LT\n");
                                        return(LT);
                                      }
"-"                                   { printf("[Shift] MINUS\n");
                                        return(MINUS);
                                      }
"+"                                   { printf("[Shift] PLUS\n");
                                        return(PLUS);
                                      }
"]"                                   { printf("[Shift] RBRAC\n");
                                        return(RBRAC);
                                      }
")"                                   { printf("[Shift] RPAREN\n");
                                        return(RPAREN);
                                      }
";"                                   { printf("[Shift] SEMICOLON\n");
                                        return(SEMICOLON);
                                      }
"/"                                   { printf("[Shift] SLASH\n");
                                        return(SLASH);
                                      }
"*"                                   { printf("[Shift] STAR\n");
                                        return(STAR);
                                      }

[a-zA-Z]([a-zA-Z0-9_])*               { printf("[Shift] IDENTIFIER\n");
                                        return(IDENTIFIER);
                                      }
[+-]?[0-9]+                           { printf("[Shift] NUM\n");
                                        return(NUM);
                                      }
[+-]?[0-9]+\.[0-9]+                   { printf("[Shift] NUM\n");
                                        return(NUM);
                                      }
[+-]?[0-9]+(\.[0-9]+)?E[+-]?[0-9]+    { printf("[Shift] NUM\n");
                                        return(NUM);
                                      }
\"((\\.)|[^\\\"\n])*\"                { printf("[Shift] STRING\n");
                                        return(STRING);
                                      }

\/\/.*$                               ;
"/*" { register int c;
      while ((c = input())) {
        if (c == '*') {
          if ((c = input()) == '/'){
            break;
          } else
            unput (c);
        } else if (c == '\n') {
          line_no++;
        } else if (c == 0) {
          fprintf (stderr, "Unexpected EOF inside comment at line %d\n",line_no);
        }
      }
    }

[ \t\f]    ;

\r         ;
\n    line_no++;

.    {fprintf(stderr, "Lexical analyzer error at line %d : %s\n", line_no, yytext);}

%%
