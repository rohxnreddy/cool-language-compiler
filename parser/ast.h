#ifndef AST_H
#define AST_H

#include <stdbool.h>

/* Enum for all possible AST Node Types */
typedef enum {
    NODE_PROGRAM,
    NODE_CLASS,
    NODE_FEATURE,
    NODE_LET,
    NODE_LET_DECL,
    NODE_ASSIGN,
    NODE_WHILE,
    NODE_IF,
    NODE_BLOCK,
    NODE_ARITH,
    NODE_BOOL_EXPR,
    NODE_ID,
    NODE_INT,
    NODE_BOOL,
    NODE_STRING,
    NODE_FUNC_CALL
} NodeType;

/* Enum for Operators (Arithmetic and Boolean) */
typedef enum {
    OP_PLUS,
    OP_MINUS,
    OP_MULT,
    OP_DIV,
    OP_LT,
    OP_LE,
    OP_AND,
    OP_NOT
} Operator;

/* Abstract Syntax Tree Node */
typedef struct ASTNode {
    NodeType type;
    
    union {
        /* Program: Holds the list of classes */
        struct { struct ASTNode* class_list; } program;

        /* Class: id and feature list */
        struct { char* type_name; struct ASTNode* features; } class_node;

        /* Feature: id, return type, and body expression */
        struct { char* id; char* return_type; struct ASTNode* body; } feature;

        /* Let Expression: declarations and body */
        struct { struct ASTNode* declarations; struct ASTNode* body; } let_expr;

        /* Let Declaration: id, type, and optional init expression */
        struct { char* id; char* type_name; struct ASTNode* init_expr; } let_decl;

        /* Assignment: id <- expr */
        struct { char* id; struct ASTNode* expr; } assign;

        /* While Loop: condition and body */
        struct { struct ASTNode* condition; struct ASTNode* body; } while_expr;

        /* If Statement: if condition then body else alternate */
        struct { struct ASTNode* condition; struct ASTNode* then_branch; struct ASTNode* else_branch; } if_expr;

        /* Block: list of expressions */
        struct { struct ASTNode* expr_list; } block;

        /* Arithmetic and Boolean Binary/Unary Operations */
        struct { Operator op; struct ASTNode* left; struct ASTNode* right; } op_expr;

        /* Function Call: id and list of arguments */
        struct { char* id; struct ASTNode* arg_list; } func_call;

        /* Literals and Identifiers */
        char* id_val;
        int int_val;
        bool bool_val;
        char* string_val;
    } data;

    /* Pointer to link lists of nodes (e.g., ClassList, ExprList, ArgList) */
    struct ASTNode* next;

} ASTNode;

/* Helper functions for chaining lists */
ASTNode* append_node(ASTNode* list, ASTNode* node);

/* Constructor Functions */
ASTNode* make_program(ASTNode* class_list);
ASTNode* make_class(const char* type_name, ASTNode* features);
ASTNode* make_feature(const char* id, const char* return_type, ASTNode* body);
ASTNode* make_let(ASTNode* declarations, ASTNode* body);
ASTNode* make_let_decl(const char* id, const char* type_name, ASTNode* init_expr);
ASTNode* make_assign(const char* id, ASTNode* expr);
ASTNode* make_while(ASTNode* condition, ASTNode* body);
ASTNode* make_if(ASTNode* condition, ASTNode* then_branch, ASTNode* else_branch);
ASTNode* make_block(ASTNode* expr_list);
ASTNode* make_op(NodeType type, Operator op, ASTNode* left, ASTNode* right);
ASTNode* make_func_call(const char* id, ASTNode* arg_list);

/* Leaf Node Constructors */
ASTNode* make_id(const char* id);
ASTNode* make_int(int value);
ASTNode* make_bool(bool value);
ASTNode* make_string(const char* str);

#endif /* AST_H */