CC = gcc
# Added -I./parser so lexer and main can find y.tab.h
CFLAGS = -Wall -Wextra -std=gnu11 -g -I./parser -I./codegenerator
TARGET = coolc

# Updated paths for source files
SRCS = parser/y.tab.c lexer/lex.yy.c parser/ast.c codegenerator/tac.c main.c

all: $(TARGET)

# Rule for Bison (Parser)
# Generates y.tab.c and y.tab.h inside the parser folder
parser/y.tab.c parser/y.tab.h: parser/cool.y
	bison -d -o parser/y.tab.c parser/cool.y

# Rule for Flex (Lexer)
# Generates lex.yy.c inside the lexer folder
lexer/lex.yy.c: lexer/cool.l parser/y.tab.h
	flex -o lexer/lex.yy.c lexer/cool.l

# Link everything into the final executable
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) -lfl

clean:
	rm -f $(TARGET) parser/y.tab.c parser/y.tab.h lexer/lex.yy.c
