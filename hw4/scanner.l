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
#include "node.h"

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

{A}{N}{D}                             {
                                        token_content = strdup(yytext);
                                        return(AND);
                                      }
{A}{R}{R}{A}{Y}                       {
                                        token_content = strdup(yytext);
                                        return(ARRAY);
                                      }
{D}{O}                                {
                                        token_content = strdup(yytext);
                                        return(DO);
                                      }
{E}{L}{S}{E}                          {
                                        token_content = strdup(yytext);
                                        return(ELSE);
                                      }
{E}{N}{D}                             {
                                        token_content = strdup(yytext);
                                        return(END);
                                      }
{F}{U}{N}{C}{T}{I}{O}{N}              {
                                        token_content = strdup(yytext);
                                        return(FUNCTION);
                                      }
{I}{F}                                {
                                        token_content = strdup(yytext);
                                        return(IF);
                                      }
{I}{N}{T}{E}{G}{E}{R}                 {
                                        token_content = strdup(yytext);
                                        return(INTEGER);
                                      }
{N}{O}{T}                             {
                                        token_content = strdup(yytext);
                                        return(NOT);
                                      }
{O}{F}                                {
                                        token_content = strdup(yytext);
                                        return(OF);
                                      }
{O}{R}                                {
                                        token_content = strdup(yytext);
                                        return(OR);
                                      }
{B}{E}{G}{I}{N}                       {
                                        token_content = strdup(yytext);
                                        return(PBEGIN);
                                      }
{P}{R}{O}{C}{E}{D}{U}{R}{E}           {
                                        token_content = strdup(yytext);
                                        return(PROCEDURE);
                                      }
{P}{R}{O}{G}{R}{A}{M}                 {
                                        token_content = strdup(yytext);
                                        return(PROGRAM);
                                      }
{R}{E}{A}{L}                          {
                                        token_content = strdup(yytext);
                                        return(REAL);
                                      }
{S}{T}{R}{I}{N}{G}                    {
                                        token_content = strdup(yytext);
                                        return(STRING);
                                      }
{T}{H}{E}{N}                          {
                                        token_content = strdup(yytext);
                                        return(THEN);
                                      }
{V}{A}{R}                             {
                                        token_content = strdup(yytext);
                                        return(VAR);
                                      }
{W}{H}{I}{L}{E}                       {
                                        token_content = strdup(yytext);
                                        return(WHILE);
                                      }

":="                                  {
                                        token_content = strdup(yytext);
                                        return(ASSIGNMENT);
                                      }
":"                                   {
                                        token_content = strdup(yytext);
                                        return(COLON);
                                      }
","                                   {
                                        token_content = strdup(yytext);
                                        return(COMMA);
                                      }
"."                                   {
                                        token_content = strdup(yytext);
                                        return(DOT);
                                      }
".."                                  {
                                        token_content = strdup(yytext);
                                        return(DOTDOT);
                                      }
"="                                   {
                                        token_content = strdup(yytext);
                                        return(EQUAL);
                                      }
"!="                                  {
                                        token_content = strdup(yytext);
                                        return(notEQUAL);
                                      }
">="                                  {
                                        token_content = strdup(yytext);
                                        return(GE);
                                      }
">"                                   {
                                        token_content = strdup(yytext);
                                        return(GT);
                                      }
"["                                   {
                                        token_content = strdup(yytext);
                                        return(LBRAC);
                                      }
"<="                                  {
                                        token_content = strdup(yytext);
                                        return(LE);
                                      }
"("                                   {
                                        token_content = strdup(yytext);
                                        return(LPAREN);
                                      }
"<"                                   {
                                        token_content = strdup(yytext);
                                        return(LT);
                                      }
"-"                                   {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_MINUS);
                                        return(MINUS);
                                      }
"+"                                   {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_PLUS);
                                        return(PLUS);
                                      }
"]"                                   {
                                        token_content = strdup(yytext);
                                        return(RBRAC);
                                      }
")"                                   {
                                        token_content = strdup(yytext);
                                        return(RPAREN);
                                      }
";"                                   {
                                        token_content = strdup(yytext);
                                        return(SEMICOLON);
                                      }
"/"                                   {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_SLASH);
                                        return(SLASH);
                                      }
"*"                                   {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_STAR);
                                        return(STAR);
                                      }

[a-zA-Z]([a-zA-Z0-9_])*               {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_IDENTIFIER);
                                        yylval.node->content = strdup(yytext);
                                        return(IDENTIFIER);
                                      }
[0-9]+                                {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_INT);
                                        yylval.node->integer_value = atoi(yytext);
                                        return(NUM);
                                      }
[0-9]+\.[0-9]+                        {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_REAL);
                                        yylval.node->real_value = atof(yytext);
                                        return(NUM);
                                      }
[0-9]+(\.[0-9]+)?E[+-]?[0-9]+         {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_REAL);
                                        yylval.node->real_value = atof(yytext);
                                        return(NUM);
                                      }
\"((\\.)|[^\\\"\n])*\"                {
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_STRING);
                                        yylval.node->content = strdup(yytext);
                                        return(STRINGCONST);
                                      }

\/\/.*$                               ;
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
