#include "tac.h"

static int temp_counter = 1;
static int label_counter = 1;

void init_tac_list(TACList* list) {
    list->head = NULL;
    list->tail = NULL;
}

char* new_temp() {
    char buffer[16];
    snprintf(buffer, sizeof(buffer), "_t%d", temp_counter++);
    return strdup(buffer);
}

char* new_label() {
    char buffer[16];
    snprintf(buffer, sizeof(buffer), "L%d", label_counter++);
    return strdup(buffer);
}

void emit(TACList* list, const char* op, const char* arg1, const char* arg2, const char* result) {
    Quad* q = (Quad*)malloc(sizeof(Quad));
    q->op = op ? strdup(op) : NULL;
    q->arg1 = arg1 ? strdup(arg1) : NULL;
    q->arg2 = arg2 ? strdup(arg2) : NULL;
    q->result = result ? strdup(result) : NULL;
    q->next = NULL;

    if (list->tail == NULL) {
        list->head = q;
        list->tail = q;
    } else {
        list->tail->next = q;
        list->tail = q;
    }
}

const char* get_op_string(Operator op) {
    switch(op) {
        case OP_PLUS:  return "+";
        case OP_MINUS: return "-";
        case OP_MULT:  return "*";
        case OP_DIV:   return "/";
        case OP_LT:    return "<";
        case OP_LE:    return "<=";
        case OP_AND:   return "AND";
        case OP_NOT:   return "NOT";
        default:       return "??";
    }
}

char* generate_tac(ASTNode* node, TACList* list) {
    if (node == NULL) return NULL;

    char* result = NULL; 

    switch (node->type) {
        
        case NODE_PROGRAM: {
            ASTNode* current_class = node->data.program.class_list;
            while (current_class) {
                generate_tac(current_class, list);
                current_class = current_class->next;
            }
            break;
        }

        case NODE_CLASS: {
            ASTNode* current_feature = node->data.class_node.features;
            while (current_feature) {
                generate_tac(current_feature, list);
                current_feature = current_feature->next;
            }
            break;
        }

        case NODE_FEATURE: {
            emit(list, "FUNC_START", NULL, NULL, node->data.feature.id);
            char* body_res = generate_tac(node->data.feature.body, list);
            emit(list, "RETURN", body_res, NULL, NULL);
            emit(list, "FUNC_END", NULL, NULL, node->data.feature.id);
            break;
        }

        case NODE_BLOCK: {
            
            ASTNode* current_expr = node->data.block.expr_list;
            while (current_expr) {
                result = generate_tac(current_expr, list);
                current_expr = current_expr->next;
            }
            break;
        }

        case NODE_LET: {
            ASTNode* current_decl = node->data.let_expr.declarations;
            while (current_decl) {
                generate_tac(current_decl, list);
                current_decl = current_decl->next;
            }
            result = generate_tac(node->data.let_expr.body, list);
            break;
        }

        case NODE_LET_DECL: {
            if (node->data.let_decl.init_expr) {
                char* init_val = generate_tac(node->data.let_decl.init_expr, list);
                emit(list, "=", init_val, NULL, node->data.let_decl.id);
            }
            result = node->data.let_decl.id;
            break;
        }

        case NODE_ASSIGN: {
            char* expr_val = generate_tac(node->data.assign.expr, list);
            emit(list, "=", expr_val, NULL, node->data.assign.id);
            result = node->data.assign.id; 
            break;
        }

        case NODE_WHILE: {
            char* l_start = new_label();
            char* l_end = new_label();
            
            emit(list, "LABEL", NULL, NULL, l_start);
            char* cond_val = generate_tac(node->data.while_expr.condition, list);
            emit(list, "IFFALSE", cond_val, NULL, l_end);
            
            generate_tac(node->data.while_expr.body, list);
            
            emit(list, "GOTO", NULL, NULL, l_start);
            emit(list, "LABEL", NULL, NULL, l_end);
            break;
        }

        case NODE_IF: {
            char* cond_val = generate_tac(node->data.if_expr.condition, list);
            char* l_else = new_label();
            char* l_end = new_label();
            
            emit(list, "IFFALSE", cond_val, NULL, l_else);
            
            char* then_res = generate_tac(node->data.if_expr.then_branch, list);
            result = new_temp();
            if (then_res) emit(list, "=", then_res, NULL, result);
            
            emit(list, "GOTO", NULL, NULL, l_end);
            
            emit(list, "LABEL", NULL, NULL, l_else);
            if (node->data.if_expr.else_branch) {
                char* else_res = generate_tac(node->data.if_expr.else_branch, list);
                if (else_res) emit(list, "=", else_res, NULL, result);
            }
            
            emit(list, "LABEL", NULL, NULL, l_end);
            break;
        }

        case NODE_ARITH:
        case NODE_BOOL_EXPR: {
            char* left_val = generate_tac(node->data.op_expr.left, list);
            char* right_val = NULL;
            
            if (node->data.op_expr.op != OP_NOT && node->data.op_expr.right != NULL) {
                right_val = generate_tac(node->data.op_expr.right, list);
            }

            result = new_temp();
            const char* op_str = get_op_string(node->data.op_expr.op);
            emit(list, op_str, left_val, right_val, result);
            break;
        }

        case NODE_FUNC_CALL: {
            int arg_count = 0;
            ASTNode* current_arg = node->data.func_call.arg_list;
            
            while (current_arg) {
                char* arg_val = generate_tac(current_arg, list);
                emit(list, "PARAM", arg_val, NULL, NULL);
                arg_count++;
                current_arg = current_arg->next;
            }

            char count_str[16];
            snprintf(count_str, sizeof(count_str), "%d", arg_count);
            
            result = new_temp();
            emit(list, "CALL", node->data.func_call.id, count_str, result);
            break;
        }
        case NODE_ID: {
            result = node->data.id_val;
            break;
        }
        case NODE_INT: {
            char buffer[32];
            snprintf(buffer, sizeof(buffer), "%d", node->data.int_val);
            result = strdup(buffer);
            break;
        }
        case NODE_BOOL: {
            result = node->data.bool_val ? strdup("true") : strdup("false");
            break;
        }
        case NODE_STRING: {
            char buffer[256]; 
            snprintf(buffer, sizeof(buffer), "\"%s\"", node->data.string_val);
            result = strdup(buffer);
            break;
        }

        default:
            fprintf(stderr, "TAC Generator: Unknown AST Node type\n");
            break;
    }

    return result;
}

void print_tac_list(TACList* list) {
    Quad* curr = list->head;
    while (curr != NULL) {
        if (!curr->op) {
            curr = curr->next;
            continue;
        }
        
        if (strcmp(curr->op, "LABEL") == 0) {
            printf("%s:\n", curr->result);
        } else if (strcmp(curr->op, "GOTO") == 0) {
            printf("    goto %s\n", curr->result);
        } else if (strcmp(curr->op, "IFFALSE") == 0) {
            printf("    ifFalse %s goto %s\n", curr->arg1, curr->result);
        } else if (strcmp(curr->op, "=") == 0) {
            printf("    %s = %s\n", curr->result, curr->arg1);
        } else if (strcmp(curr->op, "PARAM") == 0) {
            printf("    param %s\n", curr->arg1);
        } else if (strcmp(curr->op, "CALL") == 0) {
            printf("    %s = call %s, %s\n", curr->result, curr->arg1, curr->arg2);
        } else if (strcmp(curr->op, "FUNC_START") == 0) {
            printf("\n%s:\n", curr->result);
        } else if (strcmp(curr->op, "FUNC_END") == 0) {
            printf("    end %s\n", curr->result);
        } else if (strcmp(curr->op, "RETURN") == 0) {
            printf("    return %s\n", curr->arg1 ? curr->arg1 : "");
        } else {
            if (curr->arg2) {
                printf("    %s = %s %s %s\n", curr->result, curr->arg1, curr->op, curr->arg2);
            } else {
                printf("    %s = %s %s\n", curr->result, curr->op, curr->arg1);
            }
        }
        curr = curr->next;
    }
}

void free_tac_list(TACList* list) {
    Quad* curr = list->head;
    while (curr != NULL) {
        Quad* next = curr->next;
        if (curr->op) free(curr->op);
        if (curr->arg1) free(curr->arg1);
        if (curr->arg2) free(curr->arg2);
        if (curr->result) free(curr->result);
        free(curr);
        curr = next;
    }
    list->head = NULL;
    list->tail = NULL;
}