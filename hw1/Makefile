LEX = flex
CXX = gcc
ARG = -ll -g -o
LEX_FILE = hw1.l
INPUT_FILE = input.p
SAMPLE_OUTPUT = sample_output.txt

C_FILE = lex.yy.c
EXEC_FILE = scanner

all: $(LEX_FILE)
	$(LEX) $^
	$(CXX) $(C_FILE) $(ARG) $(EXEC_FILE)

.PHONY:  clean

clean:
	rm -rf $(C_FILE) $(EXEC_FILE)
