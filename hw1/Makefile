LEX = flex
CXX = cc
ARG = -ll -g -o
LEX_FILE = hw1.l

C_FILE = lex.yy.c
EXEC_FILE = scanner

all: $(LEX_FILE)
	$(LEX) $^
	$(CXX) $(C_FILE) $(ARG) $(EXEC_FILE)

.PHONY:  clean

clean:
	rm -rf $(C_FILE) $(EXEC_FILE)
