%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef AST_H
#define AST_H

#include <stdbool.h>

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

typedef struct ASTNode {
    NodeType type;
    
    union {
        struct { struct ASTNode* class_list; } program;
        struct { char* type_name; struct ASTNode* features; } class_node;
        struct { char* id; char* return_type; struct ASTNode* body; } feature;
        struct { struct ASTNode* declarations; struct ASTNode* body; } let_expr;
        struct { char* id; char* type_name; struct ASTNode* init_expr; } let_decl;
        struct { char* id; struct ASTNode* expr; } assign;
        struct { struct ASTNode* condition; struct ASTNode* body; } while_expr;
        struct { struct ASTNode* condition; struct ASTNode* then_branch; struct ASTNode* else_branch; } if_expr;
        struct { struct ASTNode* expr_list; } block;
        struct { Operator op; struct ASTNode* left; struct ASTNode* right; } op_expr;

        struct { char* id; struct ASTNode* arg_list; } func_call;

        char* id_val;
        int int_val;
        bool bool_val;
        char* string_val;
    } data;

    struct ASTNode* next;

} ASTNode;

ASTNode* append_node(ASTNode* list, ASTNode* node);
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
ASTNode* make_id(const char* id);
ASTNode* make_int(int value);
ASTNode* make_bool(bool value);
ASTNode* make_string(const char* str);

#endif 

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

#ifndef TAC_H
#define TAC_H

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

/* Flex declarations */
extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;

void yyerror(const char *s);

/* Global AST root */
ASTNode *ast_root;
%}

/* Union */
%union {
    int ival;
    float fval;
    char *str;
    ASTNode *node;
}

/* Tokens */
%token <str> TYPEID OBJECTID STR_CONST
%token <ival> INT_CONST BOOL_CONST
%token <fval> FLOAT_CONST

%token CLASS ELSE FI IF IN LET LOOP POOL THEN WHILE OF NOT AND
%token ASSIGN LE NE LBRACE RBRACE LPAREN RPAREN COLON SEMICOLON COMMA DOT
%token PLUS MINUS MULT DIV NEG LT AT ERROR_TOKEN

/* Precedence */
%right IN
%right ASSIGN
%left AND
%right NOT
%nonassoc LT LE NE
%left PLUS MINUS
%left MULT DIV

/* Types */
%type <node> Program ClassList Class FeatureList Feature
%type <node> Expr LetExpr AssignExpr WhileExpr IfExpr Block
%type <node> ArithExpr Term Factor BoolExpr FunctionCall
%type <node> ExprList ArgList LetDeclList LetDecl

%%

Program:
    ClassList {
        $$ = make_program($1);
        ast_root = $$;
    }
;

ClassList:
    Class ClassList { $$ = append_node($1, $2); }
  | Class           { $$ = $1; }
;

Class:
    CLASS TYPEID LBRACE FeatureList RBRACE SEMICOLON {
        $$ = make_class($2, $4);
    }
;

FeatureList:
    Feature FeatureList { $$ = append_node($1, $2); }
  | /* empty */         { $$ = NULL; }
;

Feature:
    OBJECTID LPAREN RPAREN COLON TYPEID LBRACE Expr RBRACE SEMICOLON {
        $$ = make_feature($1, $5, $7);
    }
;

/* Expressions */

Expr:
    LetExpr      { $$ = $1; }
  | AssignExpr   { $$ = $1; }
  | WhileExpr    { $$ = $1; }
  | IfExpr       { $$ = $1; }
  | Block        { $$ = $1; }
  | ArithExpr    { $$ = $1; }
  | BoolExpr     { $$ = $1; }
  | STR_CONST    { $$ = make_string($1); }
  | FunctionCall { $$ = $1; }
;

/* Let */

LetExpr:
    LET LetDeclList IN Expr {
        $$ = make_let($2, $4);
    }
;

LetDeclList:
    LetDecl COMMA LetDeclList { $$ = append_node($1, $3); }
  | LetDecl                  { $$ = $1; }
;

LetDecl:
    OBJECTID COLON TYPEID {
        $$ = make_let_decl($1, $3, NULL);
    }
  | OBJECTID COLON TYPEID ASSIGN Expr {
        $$ = make_let_decl($1, $3, $5);
    }
;

/* Assignment */

AssignExpr:
    OBJECTID ASSIGN Expr {
        $$ = make_assign($1, $3);
    }
;

/* While */

WhileExpr:
    WHILE Expr LOOP Expr POOL {
        $$ = make_while($2, $4);
    }
;

/* If */

IfExpr:
    IF Expr THEN Expr ELSE Expr FI {
        $$ = make_if($2, $4, $6);
    }
;

/* Block */

Block:
    LBRACE ExprList RBRACE {
        $$ = make_block($2);
    }
;

ExprList:
    Expr SEMICOLON            { $$ = $1; }
  | Expr SEMICOLON ExprList  { $$ = append_node($1, $3); }
;

/* Arithmetic */

ArithExpr:
    ArithExpr PLUS Term  { $$ = make_op(NODE_ARITH, OP_PLUS, $1, $3); }
  | ArithExpr MINUS Term { $$ = make_op(NODE_ARITH, OP_MINUS, $1, $3); }
  | Term                 { $$ = $1; }
;

Term:
    Term MULT Factor { $$ = make_op(NODE_ARITH, OP_MULT, $1, $3); }
  | Term DIV Factor  { $$ = make_op(NODE_ARITH, OP_DIV, $1, $3); }
  | Factor           { $$ = $1; }
;

Factor:
    OBJECTID           { $$ = make_id($1); }
  | INT_CONST          { $$ = make_int($1); }
  | LPAREN Expr RPAREN { $$ = $2; }
;

/* Boolean */

BoolExpr:
    Expr LE Expr   { $$ = make_op(NODE_BOOL_EXPR, OP_LE, $1, $3); }
  | Expr LT Expr   { $$ = make_op(NODE_BOOL_EXPR, OP_LT, $1, $3); }
  | Expr AND Expr  { $$ = make_op(NODE_BOOL_EXPR, OP_AND, $1, $3); }
  | NOT Expr       { $$ = make_op(NODE_BOOL_EXPR, OP_NOT, $2, NULL); }
  | BOOL_CONST     { $$ = make_bool($1); }
;

/* Function Call */

FunctionCall:
    OBJECTID LPAREN ArgList RPAREN {
        $$ = make_func_call($1, $3);
    }
;

ArgList:
    Expr COMMA ArgList { $$ = append_node($1, $3); }
  | Expr               { $$ = $1; }
  | /* empty */        { $$ = NULL; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parser Error at line %d near \"%s\": %s\n",
            yylineno, yytext, s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file.cl>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error opening input file");
        return EXIT_FAILURE;
    }

    yyin = input_file;

    printf("Starting compilation for: %s\n", argv[1]);
    int parse_result = yyparse();

    if (parse_result == 0) {
        printf("Parsing completed successfully. Generating TAC...\n\n");

        if (ast_root != NULL) {
            TACList tac_list;

            init_tac_list(&tac_list);
            generate_tac(ast_root, &tac_list);
            print_tac_list(&tac_list);
            free_tac_list(&tac_list);
        } else {
            fprintf(stderr, "Error: AST root is NULL\n");
        }
    } else {
        printf("Parsing failed.\n");
    }

    fclose(input_file);
    return parse_result == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}