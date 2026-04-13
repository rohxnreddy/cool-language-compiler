#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

/* Utility to allocate a new node and initialize it */
static ASTNode* alloc_node(NodeType type) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Out of memory!\n");
        exit(1);
    }
    node->type = type;
    node->next = NULL;
    return node;
}

/* Appends a node to the end of a linked list (useful for BISON rules) */
ASTNode* append_node(ASTNode* list, ASTNode* node) {
    if (!list) return node;
    ASTNode* current = list;
    while (current->next != NULL) {
        current = current->next;
    }
    current->next = node;
    return list;
}

ASTNode* make_program(ASTNode* class_list) {
    ASTNode* node = alloc_node(NODE_PROGRAM);
    node->data.program.class_list = class_list;
    return node;
}

ASTNode* make_class(const char* type_name, ASTNode* features) {
    ASTNode* node = alloc_node(NODE_CLASS);
    node->data.class_node.type_name = strdup(type_name);
    node->data.class_node.features = features;
    return node;
}

ASTNode* make_feature(const char* id, const char* return_type, ASTNode* body) {
    ASTNode* node = alloc_node(NODE_FEATURE);
    node->data.feature.id = strdup(id);
    node->data.feature.return_type = strdup(return_type);
    node->data.feature.body = body;
    return node;
}

ASTNode* make_let(ASTNode* declarations, ASTNode* body) {
    ASTNode* node = alloc_node(NODE_LET);
    node->data.let_expr.declarations = declarations;
    node->data.let_expr.body = body;
    return node;
}

ASTNode* make_let_decl(const char* id, const char* type_name, ASTNode* init_expr) {
    ASTNode* node = alloc_node(NODE_LET_DECL);
    node->data.let_decl.id = strdup(id);
    node->data.let_decl.type_name = strdup(type_name);
    node->data.let_decl.init_expr = init_expr;
    return node;
}

ASTNode* make_assign(const char* id, ASTNode* expr) {
    ASTNode* node = alloc_node(NODE_ASSIGN);
    node->data.assign.id = strdup(id);
    node->data.assign.expr = expr;
    return node;
}

ASTNode* make_while(ASTNode* condition, ASTNode* body) {
    ASTNode* node = alloc_node(NODE_WHILE);
    node->data.while_expr.condition = condition;
    node->data.while_expr.body = body;
    return node;
}

ASTNode* make_if(ASTNode* condition, ASTNode* then_branch, ASTNode* else_branch) {
    ASTNode* node = alloc_node(NODE_IF);
    node->data.if_expr.condition = condition;
    node->data.if_expr.then_branch = then_branch;
    node->data.if_expr.else_branch = else_branch;
    return node;
}

ASTNode* make_block(ASTNode* expr_list) {
    ASTNode* node = alloc_node(NODE_BLOCK);
    node->data.block.expr_list = expr_list;
    return node;
}

/* Handles both Arithmetic and Boolean operations */
ASTNode* make_op(NodeType type, Operator op, ASTNode* left, ASTNode* right) {
    ASTNode* node = alloc_node(type);
    node->data.op_expr.op = op;
    node->data.op_expr.left = left;
    node->data.op_expr.right = right;
    return node;
}

ASTNode* make_func_call(const char* id, ASTNode* arg_list) {
    ASTNode* node = alloc_node(NODE_FUNC_CALL);
    node->data.func_call.id = strdup(id);
    node->data.func_call.arg_list = arg_list;
    return node;
}

ASTNode* make_id(const char* id) {
    ASTNode* node = alloc_node(NODE_ID);
    node->data.id_val = strdup(id);
    return node;
}

ASTNode* make_int(int value) {
    ASTNode* node = alloc_node(NODE_INT);
    node->data.int_val = value;
    return node;
}

ASTNode* make_bool(bool value) {
    ASTNode* node = alloc_node(NODE_BOOL);
    node->data.bool_val = value;
    return node;
}

ASTNode* make_string(const char* str) {
    ASTNode* node = alloc_node(NODE_STRING);
    node->data.string_val = strdup(str);
    return node;
}