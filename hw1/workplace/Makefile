LEX = flex
CXX = gcc
ARG = -ll -g -o
LEX_FILE = hw1.l
INPUT_FILE = input.p
SAMPLE_OUTPUT = sample_output.txt

C_FILE = lex.yy.c
EXEC_FILE = scanner
OUTPUT_FILE = output.txt

all: $(LEX_FILE)
	$(LEX) $^
	$(CXX) $(C_FILE) $(ARG) $(EXEC_FILE)

.PHONY: check clean
check: make $(INPUT_FILE) $(SAMPLE_OUTPUT)
	$(EXEC_FILE) < $(INPUT_FILE) > $(OUTPUT_FILE)
	diff $(OUTPUT_FILE) $(SAMPLE_OUTPUT)
clean:
	rm -rf $(C_FILE) $(EXEC_FILE) $(OUTPUT_FILE)
