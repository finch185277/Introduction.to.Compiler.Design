YACC = yacc
LEX = flex
CXX = cc
YACC_ARG = -d
CXX_ARG = -ly -g -o
LEX_FILE = scanner.l
YACC_FILE = parser.y

C_FILE = lex.yy.c y.tab.c y.tab.h
EXEC_FILE = parser

all: $(LEX_FILE) $(YACC_FILE)
	$(LEX) $(LEX_FILE)
	$(YACC) $(YACC_ARG) $(YACC_FILE)
	$(CXX) $(C_FILE) $(CXX_ARG) $(EXEC_FILE)

.PHONY:  clean

clean:
	rm -rf $(C_FILE) $(EXEC_FILE)
