YACC = yacc
LEX = flex
CXX = cc
YACC_ARG = -d
LEX_FILE = scanner.l
YACC_FILE = parser.y

MID_FILE = lex.yy.c y.tab.c y.tab.h
O_FILE = node.o symtab.o
EXEC_FILE = parser
OUTPUT_FOLDER = output

node: node.c
	$(CXX) -c -o node.o $^

symtab: symtab.c
	$(CXX) -c -o symtab.o $^

all: $(LEX_FILE) $(YACC_FILE) node symtab
	$(LEX) $(LEX_FILE)
	$(YACC) $(YACC_ARG) $(YACC_FILE)
	$(CXX) -o $(EXEC_FILE) $(MID_FILE) $(O_FILE)

.PHONY: test clean

test: all
	./test.sh

clean:
	rm -rf $(MID_FILE) $(O_FILE) $(EXEC_FILE) $(OUTPUT_FOLDER)
