#ifndef TAC_H
#define TAC_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h" 
typedef struct Quad {
    char* op;
    char* arg1;
    char* arg2;
    char* result;
    struct Quad* next;
} Quad;

typedef struct TACList {
    Quad* head;
    Quad* tail;
} TACList;

void init_tac_list(TACList* list);
char* new_temp();
char* new_label();
void emit(TACList* list, const char* op, const char* arg1, const char* arg2, const char* result);
char* generate_tac(ASTNode* node, TACList* list);
void print_tac_list(TACList* list);
void free_tac_list(TACList* list);

#endif 