# hw2
# Introduction
Combining the scanner(hw1), we build the parser of mini-pascal.
We assume scanner would not return error while scanning input.

## Environment
- Linux Mint 19.2 (Ubuntu 18.04)
- `apt install flex bison libfl-dev gcc`
  - bison version: `3.0.4`
  - flex version: `2.6.4`
  - cc version: `7.4.0`

## Test
- Manual:
  - `flex scanner.l`
  - `yacc -d parser.y`
  - `cc -g -o parser lex.yy.c y.tab.c y.tab.h`
  - `./parser < inut/{?}.p`

- Use script (recommended):
  - `make test`
  - check files in `output` folder

Result depend on input:
- parse successfully:
  - standard output
  ```
  OK
  ```

- parse interrupt:
  - standard error
  ```
  line <no.>: error token <token content>
  <error message>
  ```
  - standard output
  ```
  ERROR
  ```

## Code
### scanner.l
Scan the input file, and return token or pass value to parser.
- `%option yylineno`: turn on line number option.
- `char* token_content`: consider token content as value, which will be passed to parser.
example:
```
{A}{R}{R}{A}{Y}                       {
                                        token_content = strdup(yytext);
                                        return(ARRAY);
                                      }
```
- `NUM`: will not be differentiated by positive or negative in this part.
(it will be processed in parser)

### parser.y
Parse tokens by grammar.
- `yyerror()`: trigger when error occur.
```
void yyerror(const char* msg) {
  extern int yylineno;
  extern char* token_content;
  fprintf(stderr, "line %d: error token %s\n%s\n", yylineno, token_content, msg);
}
```
  - `extern int yylineno`: catch the current line number passed from scanner.
  - `extern char* token_content`: catch the current token content passed from scanner.

- `%error-verbose`: return __detailed__ error message.
(this option have been removed in latest version, because this option cannot use in workstation)

- `factor`: the smallest element of grammar.
```
factor : IDENTIFIER tail
	| IDENTIFIER LPAREN expression_list RPAREN
	| NUM
	| PLUS NUM
	| MINUS NUM
	| STRING
	| LPAREN expression RPAREN
	| NOT factor
  ;
```
  - `PLUS NUM`: consider as positive number.
  - `MINUS NUM`: consider as negative number.

## Grammar bug
### optional_statements
`optional_statements` and `statement` both reduce to `lambda`,
so `lambda` could be reduced from two way:
- `statement` -> `lambda`
- `statement` -> `statement_list` -> `optional_statements` -> `lambda`

And this would cause yacc error
```
parser.y: warning: 1 reduce/reduce conflict [-Wconflicts-rr]
```
Solution: remove `lambda` from `optional_statements` section.

## Extra files
- `test.sh`:
generate output of parser

- `output` folder:
content generated by `test.sh`

- `terminal-output.txt`:
content generated by command `make test > terminal-output.txt 2>&1`
