YACC = yacc
LEX = flex
CXX = cc
YACC_ARG = -d
CXX_ARG = -g -o
LEX_FILE = scanner.l
YACC_FILE = parser.y

MID_FILE = lex.yy.c y.tab.c y.tab.h
EXEC_FILE = parser

all: $(LEX_FILE) $(YACC_FILE)
	$(LEX) $(LEX_FILE)
	$(YACC) $(YACC_ARG) $(YACC_FILE)
	$(CXX) $(CXX_ARG) $(EXEC_FILE) $(MID_FILE)

.PHONY: test clean

test: all
	./test.sh

clean:
	rm -rf $(MID_FILE) $(EXEC_FILE)
