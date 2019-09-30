# hw0

## Environment
- Linux Mint 19.1 (Ubuntu 18.04)
- `apt install flex libfl-dev`

## Test
- Without Makefile
  - `flex hw1.l`
  - `cc lex.yy.c -ll`
  - `./a.out inut/{?}.p`
- Use Makefile
  - `make`
  - `./scanner < inut/{?}.p`

## Code
### INTEGER (2)
```
{I}{N}{T}{E}{G}{E}{R}                  return(INTEGER);
```

### REAL (3)
```
{R}{E}{A}{L}                           return(REAL);
```

### NUM (4)
In this part, we didn't define unclear number expression, ex. `1.` or `.1`.
The notation `+` and `-` are optional in each number.

- integer
```
[+-]?[0-9]+                            return(NUM);
```

- floating point
```
[+-]?[0-9]+\.[0-9]+                    return(NUM);
```

- scientific notation
```
[+-]?[0-9]+(\.[0-9]+)?E[+-]?[0-9]+     return(NUM);
```

### STRINGCONST (5)
In `STRINGCONST`, it can be split into many parts. And each part would be
  - escaped character: `\.`
  - normal sub-string: `[^\\\"\n]` (any character excluding `\`, `"`, and `\n`).
```
\"((\\.)|[^\\\"\n])*\"                 return(STRINGCONST);
```

### COMMENT (6)
- single line comment
```
\/\/.*$                                {fprintf(stderr, "  # Comment at line %d: %s\n", line_no, yytext);}
```

- multiple line comment
```
"/*" { register int c;
      fprintf(stderr, "  # Comment at line %d: %s", line_no, yytext);
      while ((c = input())) {
        fprintf(stderr, "%c", c);
        if (c == '*') {
          if ((c = input()) == '/'){
            fprintf(stderr, "%c\n", c);
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
```

### ID (11)
```
[a-zA-Z]([a-zA-Z0-9_])*                return(ID);
```
