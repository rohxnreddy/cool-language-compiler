%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "ast.h"

/* External declarations for Flex */
extern int yylex();
extern int yylineno;
extern char* yytext;

/* Root of the Abstract Syntax Tree */
ASTNode* ast_root;

/* Function to handle syntax errors */
void yyerror(const char *s);
%}

/* * -------------------------------------------------------------------
 * Union definition to hold token values and AST Node pointers
 * -------------------------------------------------------------------
 */
%union {
    int int_val;
    bool bool_val;
    char* str_val;
    struct ASTNode* ast_node;
}

/* * -------------------------------------------------------------------
 * Token Definitions
 * -------------------------------------------------------------------
 */
/* Keywords */
%token CLASS LET IN WHILE LOOP POOL IF THEN ELSE FI
%token AND NOT

/* Literal and Identifier Tokens mapped to the %union */
%token <str_val> ID TYPE STRING
%token <int_val> INT
%token <bool_val> BOOL

/* Multi-character operators */
%token ASSIGN "<-"
%token LE "<="

/* * -------------------------------------------------------------------
 * Precedence and Associativity Rules
 * -------------------------------------------------------------------
 */
%left AND
%nonassoc '<' LE '='
%left '+' '-'
%left '*' '/'
%right NOT

/* * -------------------------------------------------------------------
 * Non-Terminal Type Declarations
 * -------------------------------------------------------------------
 */
%type <ast_node> Program ClassList Class FeatureList Feature 
%type <ast_node> Expr LetExpr LetDeclList LetDecl AssignExpr 
%type <ast_node> WhileExpr IfExpr Block ExprList
%type <ast_node> LogicExpr RelExpr AddExpr MulExpr UnaryExpr Primary ArgList

%start Program

%%

/* * -------------------------------------------------------------------
 * Grammar Rules and Semantic Actions
 * -------------------------------------------------------------------
 */

/* 2.1 Start Symbol */
Program:
    ClassList { 
        $$ = make_program($1); 
        ast_root = $$; 
    }
    ;

/* 2.2 Classes */
ClassList:
    Class ClassList { $$ = append_node($1, $2); }
    | Class         { $$ = $1; }
    ;

Class:
    CLASS TYPE '{' FeatureList '}' ';' { 
        $$ = make_class($2, $4); 
    }
    ;

FeatureList:
    Feature FeatureList { $$ = append_node($1, $2); }
    | /* empty */       { $$ = NULL; }
    ;

Feature:
    ID '(' ')' ':' TYPE '{' Expr '}' ';' { 
        $$ = make_feature($1, $5, $7); 
    }
    ;

/* 2.3 Expressions */
Expr:
    LetExpr          { $$ = $1; }
    | AssignExpr     { $$ = $1; }
    | WhileExpr      { $$ = $1; }
    | IfExpr         { $$ = $1; }
    | Block          { $$ = $1; }
    ;
/* ArithExpr and BoolExpr */
AssignExpr:
    ID ASSIGN AssignExpr {
        $$ = make_assign($1, $3);
    }
    | LogicExpr {
        $$ = $1;
    }
    ;

LogicExpr:
    LogicExpr AND RelExpr {
        $$ = make_op(NODE_BOOL_EXPR, OP_AND, $1, $3);
    }
    | NOT LogicExpr {
        $$ = make_op(NODE_BOOL_EXPR, OP_NOT, $2, NULL);
    }
    | RelExpr {
        $$ = $1;
    }
    ;

RelExpr:
    AddExpr '<' AddExpr {
        $$ = make_op(NODE_BOOL_EXPR, OP_LT, $1, $3);
    }
    | AddExpr LE AddExpr {
        $$ = make_op(NODE_BOOL_EXPR, OP_LE, $1, $3);
    }
    | AddExpr {
        $$ = $1;
    }
    ;

AddExpr:
    AddExpr '+' MulExpr {
        $$ = make_op(NODE_ARITH, OP_PLUS, $1, $3);
    }
    | AddExpr '-' MulExpr {
        $$ = make_op(NODE_ARITH, OP_MINUS, $1, $3);
    }
    | MulExpr {
        $$ = $1;
    }
    ;

MulExpr:
    MulExpr '*' UnaryExpr {
        $$ = make_op(NODE_ARITH, OP_MULT, $1, $3);
    }
    | MulExpr '/' UnaryExpr {
        $$ = make_op(NODE_ARITH, OP_DIV, $1, $3);
    }
    | UnaryExpr {
        $$ = $1;
    }
    ;

UnaryExpr:
    Primary {
        $$ = $1;
    }
    ;

Primary:
    ID '(' ArgList ')' {
        $$ = make_func_call($1, $3);
    }
    | ID {
        $$ = make_id($1);
    }
    | INT {
        $$ = make_int($1);
    }
    | BOOL {
        $$ = make_bool($1);
    }
    | STRING {
        $$ = make_string($1);
    }
    | '(' Expr ')' {
        $$ = $2;
    }
    ;

/* 2.4 Let Expression */
LetExpr:
    LET LetDeclList IN Expr { 
        $$ = make_let($2, $4); 
    }
    ;

LetDeclList:
    LetDecl ',' LetDeclList { $$ = append_node($1, $3); }
    | LetDecl               { $$ = $1; }
    ;

LetDecl:
    ID ':' TYPE { 
        $$ = make_let_decl($1, $3, NULL); 
    }
    | ID ':' TYPE ASSIGN Expr { 
        $$ = make_let_decl($1, $3, $5); 
    }
    ;

/* 2.5 Assignment */
/* REMOVE this duplicate old rule block entirely:
AssignExpr:
    ID ASSIGN Expr { 
        $$ = make_assign($1, $3); 
    }
    ;
*/

/* 2.6 While Loop */
WhileExpr:
    WHILE Expr LOOP Expr POOL { 
        $$ = make_while($2, $4); 
    }
    ;

/* 2.7 If Statement */
IfExpr:
    IF Expr THEN Expr ELSE Expr FI { 
        $$ = make_if($2, $4, $6); 
    }
    ;

/* 2.8 Block */
Block:
    '{' ExprList '}' { 
        $$ = make_block($2); 
    }
    ;

ExprList:
    Expr ';' { 
        $$ = $1; 
    }
    | Expr ';' ExprList { 
        $$ = append_node($1, $3); 
    }
    ;

/* add this missing non-terminal */
ArgList:
    Expr ',' ArgList {
        $$ = append_node($1, $3);
    }
    | Expr {
        $$ = $1;
    }
    | /* empty */ {
        $$ = NULL;
    }
    ;

/* 2.9 Arithmetic Expressions (With Precedence) */
/* REMOVE entire old block:
ArithExpr:
    ArithExpr '+' Term { ... }
    | ArithExpr '-' Term { ... }
    | Term { ... }
    ;

Term:
    Term '*' Factor { ... }
    | Term '/' Factor { ... }
    | Factor { ... }
    ;

Factor:
    ID { ... }
    | INT { ... }
    | '(' Expr ')' { ... }
    ;
*/

/* 2.10 Boolean Expressions */
/* REMOVE entire old block:
BoolExpr:
    Expr '<' Expr { ... }
    | Expr AND Expr { ... }
    | NOT Expr { ... }
    ;
*/

/* 2.11 Function Call */
/* REMOVE entire old block:
FunctionCall:
    ID '(' ArgList ')' {
        $$ = make_func_call($1, $3);
    }
    ;
*/

// keep ArgList as-is (used by Primary)
// ...existing code...

%%

/* * -------------------------------------------------------------------
 * Epilogue: C Code Section
 * -------------------------------------------------------------------
 */

/* yyerror implementation for syntax error handling */
void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error at line %d: %s near '%s'\n", yylineno, s, yytext);
    exit(1);
}
