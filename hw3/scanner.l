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
                                        printf("[  Shift  ] | AND\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_AND);
                                        return(AND);
                                      }
{A}{R}{R}{A}{Y}                       {
                                        printf("[  Shift  ] | ARRAY\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_ARRAY);
                                        return(ARRAY);
                                      }
{D}{O}                                {
                                        printf("[  Shift  ] | DO\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_DO);
                                        return(DO);
                                      }
{E}{L}{S}{E}                          {
                                        printf("[  Shift  ] | ELSE\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_ELSE);
                                        return(ELSE);
                                      }
{E}{N}{D}                             {
                                        printf("[  Shift  ] | END\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_END);
                                        return(END);
                                      }
{F}{U}{N}{C}{T}{I}{O}{N}              {
                                        printf("[  Shift  ] | FUNCTION\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_FUNCTION);
                                        return(FUNCTION);
                                      }
{I}{F}                                {
                                        printf("[  Shift  ] | IF\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_IF);
                                        return(IF);
                                      }
{I}{N}{T}{E}{G}{E}{R}                 {
                                        printf("[  Shift  ] | INTEGER\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_INTEGER);
                                        return(INTEGER);
                                      }
{N}{O}{T}                             {
                                        printf("[  Shift  ] | NOT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_NOT);
                                        return(NOT);
                                      }
{O}{F}                                {
                                        printf("[  Shift  ] | OF\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_OF);
                                        return(OF);
                                      }
{O}{R}                                {
                                        printf("[  Shift  ] | OR\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_OR);
                                        return(OR);
                                      }
{B}{E}{G}{I}{N}                       {
                                        printf("[  Shift  ] | PBEGIN\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_PBEGIN);
                                        return(PBEGIN);
                                      }
{P}{R}{O}{C}{E}{D}{U}{R}{E}           {
                                        printf("[  Shift  ] | PROCEDURE\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_PROCEDURE);
                                        return(PROCEDURE);
                                      }
{P}{R}{O}{G}{R}{A}{M}                 {
                                        printf("[  Shift  ] | PROGRAM\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_PROGRAM);
                                        return(PROGRAM);
                                      }
{R}{E}{A}{L}                          {
                                        printf("[  Shift  ] | REAL\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_REAL);
                                        return(REAL);
                                      }
{S}{T}{R}{I}{N}{G}                    {
                                        printf("[  Shift  ] | STRING\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_STRING);
                                        return(STRING);
                                      }
{T}{H}{E}{N}                          {
                                        printf("[  Shift  ] | THEN\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_THEN);
                                        return(THEN);
                                      }
{V}{A}{R}                             {
                                        printf("[  Shift  ] | VAR\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_VAR);
                                        return(VAR);
                                      }
{W}{H}{I}{L}{E}                       {
                                        printf("[  Shift  ] | WHILE\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_WHILE);
                                        return(WHILE);
                                      }

":="                                  {
                                        printf("[  Shift  ] | ASSIGNMENT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_ASSIGNMENT);
                                        return(ASSIGNMENT);
                                      }
":"                                   {
                                        printf("[  Shift  ] | COLON\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_COLON);
                                        return(COLON);
                                      }
","                                   {
                                        printf("[  Shift  ] | COMMA\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_COMMA);
                                        return(COMMA);
                                      }
"."                                   {
                                        printf("[  Shift  ] | DOT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_DOT);
                                        return(DOT);
                                      }
".."                                  {
                                        printf("[  Shift  ] | DOTDOT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_DOTDOT);
                                        return(DOTDOT);
                                      }
"="                                   {
                                        printf("[  Shift  ] | EQUAL\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_EQUAL);
                                        return(EQUAL);
                                      }
"!="                                  {
                                        printf("[  Shift  ] | notEQUAL\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_notEQUAL);
                                        return(notEQUAL);
                                      }
">="                                  {
                                        printf("[  Shift  ] | GE\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_GE);
                                        return(GE);
                                      }
">"                                   {
                                        printf("[  Shift  ] | GT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_GT);
                                        return(GT);
                                      }
"["                                   {
                                        printf("[  Shift  ] | LBRAC\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_LBRAC);
                                        return(LBRAC);
                                      }
"<="                                  {
                                        printf("[  Shift  ] | LE\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_LE);
                                        return(LE);
                                      }
"("                                   {
                                        printf("[  Shift  ] | LPAREN\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_LPAREN);
                                        return(LPAREN);
                                      }
"<"                                   {
                                        printf("[  Shift  ] | LT\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_LT);
                                        return(LT);
                                      }
"-"                                   {
                                        printf("[  Shift  ] | MINUS\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_MINUS);
                                        return(MINUS);
                                      }
"+"                                   {
                                        printf("[  Shift  ] | PLUS\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_PLUS);
                                        return(PLUS);
                                      }
"]"                                   {
                                        printf("[  Shift  ] | RBRAC\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_RBRAC);
                                        return(RBRAC);
                                      }
")"                                   {
                                        printf("[  Shift  ] | RPAREN\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_RPAREN);
                                        return(RPAREN);
                                      }
";"                                   {
                                        printf("[  Shift  ] | SEMICOLON\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_SEMICOLON);
                                        return(SEMICOLON);
                                      }
"/"                                   {
                                        printf("[  Shift  ] | SLASH\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_SLASH);
                                        return(SLASH);
                                      }
"*"                                   {
                                        printf("[  Shift  ] | STAR\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_STAR);
                                        return(STAR);
                                      }

[a-zA-Z]([a-zA-Z0-9_])*               {
                                        printf("[  Shift  ] | IDENTIFIER\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_IDENTIFIER);
                                        yylval.node->node_str = (char*)malloc(yyleng+1);
                                        strcpy(yylval.node->node_str, yytext);
                                        return(IDENTIFIER);
                                      }
[0-9]+                                {
                                        printf("[  Shift  ] | NUM\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_NUM);
                                        yylval.node->integer_value = atoi(yytext);
                                        return(NUM);
                                      }
[0-9]+\.[0-9]+                        {
                                        printf("[  Shift  ] | NUM\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_NUM);
                                        yylval.node->real_value = atof(yytext);
                                        return(NUM);
                                      }
[0-9]+(\.[0-9]+)?E[+-]?[0-9]+         {
                                        printf("[  Shift  ] | NUM\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_NUM);
                                        yylval.node->real_value = atof(yytext);
                                        return(NUM);
                                      }
\"((\\.)|[^\\\"\n])*\"                {
                                        printf("[  Shift  ] | STRING\n");
                                        token_content = strdup(yytext);
                                        yylval.node = new_node(TOKEN_STRING);
                                        yylval.node->node_str = (char*)malloc(yyleng+1);
                                        strcpy(yylval.node->node_str, yytext);
                                        return(STRING);
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
