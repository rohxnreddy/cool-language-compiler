%{
#include <stdio.h>
#include <stdlib.h>

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