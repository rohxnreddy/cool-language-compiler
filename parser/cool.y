%{
#include <stdio.h>
#include <stdlib.h>

/* Declare functions provided by Flex */
extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;

void yyerror(const char *s);

%}

/* * THE FIX: %code requires forces BISON to put this include into the 
 * generated header file (cool.tab.h) BEFORE the %union definition.
 */
%code requires {
    #include "ast.h"
}

/* Global variable to hold the root of the parsed AST */
%code {
    ASTNode *ast_root;
}

/* Define the types of data that tokens and non-terminals can carry */
%union {
    int ival;
    float fval;
    char *str;
    
    /* Unified AST Node Pointer from ast.h */
    ASTNode *node;
}

/* Tokens that carry data */
%token <str> TYPEID OBJECTID STR_CONST
%token <ival> INT_CONST BOOL_CONST
%token <fval> FLOAT_CONST

/* Keyword Tokens */
%token CLASS ELSE FI IF IN  LET LOOP POOL THEN WHILE OF NOT AND 

/* Symbol Tokens */
%token ASSIGN LE NE LBRACE RBRACE LPAREN RPAREN COLON SEMICOLON COMMA DOT PLUS MINUS MULT DIV NEG LT AT ERROR_TOKEN

/* * Precedence and Associativity Rules 
 * From lowest to highest precedence 
 */
%right ASSIGN
%left AND OR
%right NOT
%nonassoc LT LE NE
%left PLUS MINUS
%left MULT DIV

/* Non-terminal type definitions for AST construction */
%type <node> Program ClassList Class FeatureList Feature 
%type <node> Expr LetExpr AssignExpr WhileExpr IfExpr Block ArithExpr Term Factor BoolExpr FunctionCall
%type <node> ExprList ArgList LetDeclList LetDecl

%%

/* ---------------------------------------------------------------------------
 * 2.1 Start Symbol
 * --------------------------------------------------------------------------- */
Program:
    ClassList { 
        $$ = make_program($1); 
        ast_root = $$; 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.2 Classes
 * --------------------------------------------------------------------------- */
ClassList:
    Class ClassList { 
        /* Right-recursive chaining: $1 is the head, $2 is the tail */
        $$ = append_node($1, $2); 
    }
  | Class { 
        $$ = $1; 
    }
    ;

Class:
    CLASS TYPEID LBRACE FeatureList RBRACE SEMICOLON { 
        $$ = make_class($2, $4); 
    }
    ;

FeatureList:
    Feature FeatureList { 
        $$ = append_node($1, $2); 
    }
  | /* epsilon */ { 
        $$ = NULL; 
    }
    ;

Feature:
    OBJECTID LPAREN RPAREN COLON TYPEID LBRACE Expr RBRACE SEMICOLON { 
        $$ = make_feature($1, $5, $7); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.3 Expressions
 * --------------------------------------------------------------------------- */
Expr:
    LetExpr       { $$ = $1; }
  | AssignExpr    { $$ = $1; }
  | WhileExpr     { $$ = $1; }
  | IfExpr        { $$ = $1; }
  | Block         { $$ = $1; }
  | ArithExpr     { $$ = $1; }
  | BoolExpr      { $$ = $1; }
  | OBJECTID      { $$ = make_id($1); }
  | INT_CONST     { $$ = make_int($1); }
  | BOOL_CONST    { $$ = make_bool($1); }
  | STR_CONST     { $$ = make_string($1); }
  | FunctionCall  { $$ = $1; }
    ;

/* ---------------------------------------------------------------------------
 * 2.4 Let Expression
 * --------------------------------------------------------------------------- */
LetExpr:
    LET LetDeclList IN Expr { 
        $$ = make_let($2, $4); 
    }
    ;

LetDeclList:
    LetDecl COMMA LetDeclList { 
        $$ = append_node($1, $3); 
    }
  | LetDecl { 
        $$ = $1; 
    }
    ;

LetDecl:
    OBJECTID COLON TYPEID { 
        $$ = make_let_decl($1, $3, NULL); 
    }
  | OBJECTID COLON TYPEID ASSIGN Expr { 
        $$ = make_let_decl($1, $3, $5); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.5 Assignment
 * --------------------------------------------------------------------------- */
AssignExpr:
    OBJECTID ASSIGN Expr { 
        $$ = make_assign($1, $3); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.6 While Loop
 * --------------------------------------------------------------------------- */
WhileExpr:
    WHILE Expr LOOP Expr POOL { 
        $$ = make_while($2, $4); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.7 If Statement
 * --------------------------------------------------------------------------- */
IfExpr:
    IF Expr THEN Expr ELSE Expr FI { 
        $$ = make_if($2, $4, $6); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.8 Block
 * --------------------------------------------------------------------------- */
Block:
    LBRACE ExprList RBRACE { 
        $$ = make_block($2); 
    }
    ;

ExprList:
    Expr SEMICOLON { 
        $$ = $1; 
    }
  | Expr SEMICOLON ExprList { 
        $$ = append_node($1, $3); 
    }
    ;

/* ---------------------------------------------------------------------------
 * 2.9 Arithmetic Expressions (With Precedence applied via Grammar)
 * --------------------------------------------------------------------------- */
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

/* ---------------------------------------------------------------------------
 * 2.10 Boolean Expressions
 * --------------------------------------------------------------------------- */
BoolExpr:
    Expr LT Expr   { $$ = make_op(NODE_BOOL_EXPR, OP_LT, $1, $3); }
  | Expr AND Expr  { $$ = make_op(NODE_BOOL_EXPR, OP_AND, $1, $3); }
  | NOT Expr       { $$ = make_op(NODE_BOOL_EXPR, OP_NOT, $2, NULL); }
  | BOOL_CONST     { $$ = make_bool($1); }
    ;

/* ---------------------------------------------------------------------------
 * 2.11 Function Call
 * --------------------------------------------------------------------------- */
FunctionCall:
    OBJECTID LPAREN ArgList RPAREN { 
        $$ = make_func_call($1, $3); 
    }
    ;

ArgList:
    Expr COMMA ArgList { 
        $$ = append_node($1, $3); 
    }
  | Expr { 
        $$ = $1; 
    }
  | /* epsilon */ { 
        $$ = NULL; 
    }
    ;

%%

/* ---------------------------------------------------------------------------
 * Error handling and Main Function
 * --------------------------------------------------------------------------- */

void yyerror(const char *s) {
    fprintf(stderr, "Parser Error at line %d near \"%s\": %s\n", yylineno, yytext, s);
}

