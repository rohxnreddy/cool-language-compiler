CC = gcc
CFLAGS = -Wall -Wextra -std=gnu11 -g -Iparser -Icodegenerator -I.
LIBS = -lfl

TARGET = coolc

# Source paths
LEX_SRC = lexer/cool.l
YACC_SRC = parser/cool.y
# Note: I've updated the paths for your manual C files
C_SRCS = parser/ast.c codegenerator/tac.c main.c

# Generated source filenames (placed in the root or specific folders)
# Putting them in the root is often easier for linking
LEX_OUT = lex.yy.c
YACC_OUT_C = cool.tab.c
YACC_OUT_H = cool.tab.h

# Object files
# We map the C sources to object files. 
# This handles both the generated files and the subdirectory files.
OBJS = cool.tab.o lex.yy.o ast.o tac.o main.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LIBS)

# Generate Bison parser
$(YACC_OUT_C) $(YACC_OUT_H): $(YACC_SRC)
	bison -d -o $(YACC_OUT_C) $(YACC_SRC)

# Generate Flex lexer
$(LEX_OUT): $(LEX_SRC) $(YACC_OUT_H)
	flex -o $(LEX_OUT) $(LEX_SRC)

# Pattern rules for objects in subdirectories
ast.o: parser/ast.c
	$(CC) $(CFLAGS) -c parser/ast.c -o ast.o

tac.o: codegenerator/tac.c
	$(CC) $(CFLAGS) -c codegenerator/tac.c -o tac.o

main.o: main.c $(YACC_OUT_H)
	$(CC) $(CFLAGS) -c main.c -o main.o

cool.tab.o: $(YACC_OUT_C)
	$(CC) $(CFLAGS) -c $(YACC_OUT_C) -o cool.tab.o

lex.yy.o: $(LEX_OUT) $(YACC_OUT_H)
	$(CC) $(CFLAGS) -c $(LEX_OUT) -o lex.yy.o

clean:
	rm -f $(TARGET) $(OBJS) $(LEX_OUT) $(YACC_OUT_C) $(YACC_OUT_H)

.PHONY: all clean
