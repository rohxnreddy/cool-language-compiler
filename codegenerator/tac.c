#include "tac.h"

// Global counters for temporaries and labels
static int temp_counter = 1;
static int label_counter = 1;

// Initialize an empty TAC list
void init_tac_list(TACList* list) {
    list->head = NULL;
    list->tail = NULL;
}

// Generate a new temporary variable (e.g., "_t1", "_t2")
char* new_temp() {
    char buffer[16];
    snprintf(buffer, sizeof(buffer), "_t%d", temp_counter++);
    return strdup(buffer);
}

// Generate a new label (e.g., "L1", "L2")
char* new_label() {
    char buffer[16];
    snprintf(buffer, sizeof(buffer), "L%d", label_counter++);
    return strdup(buffer);
}

// Create a new quad and append it to the TAC list
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

static const char* get_op_string(Operator op) {
    switch (op) {
        case OP_PLUS:  return "+";
        case OP_MINUS: return "-";
        case OP_MULT:  return "*";
        case OP_DIV:   return "/";
        case OP_LT:    return "<";
        case OP_LE:    return "<=";
        case OP_AND:   return "AND";
        case OP_NOT:   return "NOT";
        default:       return "";
    }
}

static char* int_to_str(int v) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%d", v);
    return strdup(buf);
}

static char* bool_to_str(bool v) {
    return strdup(v ? "true" : "false");
}

static char* generate_node(ASTNode* node, TACList* list) {
    if (!node) return NULL;

    switch (node->type) {
        case NODE_PROGRAM: {
            ASTNode* c = node->data.program.class_list;
            while (c) { generate_node(c, list); c = c->next; }
            return NULL;
        }
        case NODE_CLASS: {
            ASTNode* f = node->data.class_node.features;
            while (f) { generate_node(f, list); f = f->next; }
            return NULL;
        }
        case NODE_FEATURE:
            return generate_node(node->data.feature.body, list);

        case NODE_BLOCK: {
            ASTNode* e = node->data.block.expr_list;
            char* last = NULL;
            while (e) { last = generate_node(e, list); e = e->next; }
            return last;
        }

        case NODE_LET: {
            ASTNode* d = node->data.let_expr.declarations;
            while (d) { generate_node(d, list); d = d->next; }
            return generate_node(node->data.let_expr.body, list);
        }

        case NODE_LET_DECL:
            if (node->data.let_decl.init_expr) {
                char* rhs = generate_node(node->data.let_decl.init_expr, list);
                emit(list, "=", rhs, NULL, node->data.let_decl.id);
            }
            return node->data.let_decl.id;

        case NODE_ASSIGN: {
            char* rhs = generate_node(node->data.assign.expr, list);
            emit(list, "=", rhs, NULL, node->data.assign.id);
            return node->data.assign.id;
        }

        case NODE_ARITH:
        case NODE_BOOL_EXPR: {
            if (node->data.op_expr.op == OP_NOT) {
                char* v = generate_node(node->data.op_expr.left, list);
                char* t = new_temp();
                emit(list, "NOT", v, NULL, t);
                return t;
            }
            char* l = generate_node(node->data.op_expr.left, list);
            char* r = generate_node(node->data.op_expr.right, list);
            char* t = new_temp();
            emit(list, get_op_string(node->data.op_expr.op), l, r, t);
            return t;
        }

        case NODE_IF: {
            char* cond = generate_node(node->data.if_expr.condition, list);
            char* lfalse = new_label();
            emit(list, "IFFALSE", cond, NULL, lfalse);

            generate_node(node->data.if_expr.then_branch, list);

            if (node->data.if_expr.else_branch) {
                char* lend = new_label();
                emit(list, "GOTO", NULL, NULL, lend);
                emit(list, "LABEL", NULL, NULL, lfalse);
                generate_node(node->data.if_expr.else_branch, list);
                emit(list, "LABEL", NULL, NULL, lend);
            } else {
                emit(list, "LABEL", NULL, NULL, lfalse);
            }
            return NULL;
        }

        case NODE_WHILE: {
            char* lstart = new_label();
            char* lend = new_label();
            emit(list, "LABEL", NULL, NULL, lstart);

            char* cond = generate_node(node->data.while_expr.condition, list);
            emit(list, "IFFALSE", cond, NULL, lend);

            generate_node(node->data.while_expr.body, list);
            emit(list, "GOTO", NULL, NULL, lstart);
            emit(list, "LABEL", NULL, NULL, lend);
            return NULL;
        }

        case NODE_FUNC_CALL: {
            ASTNode* a = node->data.func_call.arg_list;
            while (a) {
                char* av = generate_node(a, list);
                emit(list, "PARAM", av, NULL, NULL);
                a = a->next;
            }
            char* t = new_temp();
            emit(list, "CALL", node->data.func_call.id, NULL, t);
            return t;
        }

        case NODE_ID:     return node->data.id_val;
        case NODE_INT:    return int_to_str(node->data.int_val);
        case NODE_BOOL:   return bool_to_str(node->data.bool_val);
        case NODE_STRING: return node->data.string_val;

        default:
            fprintf(stderr, "Unsupported AST node in TAC generation\n");
            return NULL;
    }
}

void print_tac_list(TACList* list) {
    Quad* curr = list->head;
    while (curr) {
        if (curr->op && strcmp(curr->op, "LABEL") == 0) {
            printf("%s:\n", curr->result);
        } else if (curr->op && strcmp(curr->op, "GOTO") == 0) {
            printf("    goto %s\n", curr->result);
        } else if (curr->op && strcmp(curr->op, "IFFALSE") == 0) {
            printf("    ifFalse %s goto %s\n", curr->arg1 ? curr->arg1 : "", curr->result ? curr->result : "");
        } else if (curr->op && strcmp(curr->op, "=") == 0) {
            printf("    %s = %s\n", curr->result ? curr->result : "", curr->arg1 ? curr->arg1 : "");
        } else if (curr->op && strcmp(curr->op, "PARAM") == 0) {
            printf("    param %s\n", curr->arg1 ? curr->arg1 : "");
        } else if (curr->op && strcmp(curr->op, "CALL") == 0) {
            printf("    %s = call %s\n", curr->result ? curr->result : "", curr->arg1 ? curr->arg1 : "");
        } else if (curr->arg2) {
            printf("    %s = %s %s %s\n",
                   curr->result ? curr->result : "", curr->arg1 ? curr->arg1 : "",
                   curr->op ? curr->op : "", curr->arg2);
        } else {
            printf("    %s = %s %s\n",
                   curr->result ? curr->result : "", curr->op ? curr->op : "",
                   curr->arg1 ? curr->arg1 : "");
        }
        curr = curr->next;
    }
}

// Free memory allocated for the TAC list
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

void generate_tac(ASTNode* root) {
    TACList list;
    init_tac_list(&list);
    generate_node(root, &list);
    print_tac_list(&list);
    free_tac_list(&list);
}