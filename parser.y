%{
#define YYDEBUG 1

#include <iostream>
#include <string>
#include <vector>

void yyerror(const char *s);
extern int yylex();
%}

%define parse.error verbose
%code requires {
    #include <string>
    #include <vector>
    #include <iostream>

    class Node {
    public:
        virtual ~Node() {}
        virtual void print(int indent) = 0;
    };

    class LiteralNode : public Node {
        std::string val;
    public:
        LiteralNode(std::string v) : val(v) {}
        void print(int indent) override {
            for(int i=0; i<indent; i++) std::cout << " ";
            std::cout << "Literal: " << val << std::endl;
        }
    };

    class OpNode : public Node {
        std::string op;
        Node *l, *r;
    public:
        OpNode(std::string o, Node* left, Node* right) : op(o), l(left), r(right) {}
        void print(int indent) override {
            for(int i=0; i<indent; i++) std::cout << " ";
            std::cout << "Op: " << op << std::endl;
            if(l) l->print(indent + 2);
            if(r) r->print(indent + 2);
        }
    };

    class BlockNode : public Node {
        std::vector<Node*> exprs;
    public:
        BlockNode(Node* first) { if(first) exprs.push_back(first); }
        void addExpr(Node* next) { if(next) exprs.push_back(next); }
        void print(int indent) override {
            for(int i=0; i<indent; i++) std::cout << " ";
            std::cout << "Block:" << std::endl;
            for(auto e : exprs) e->print(indent + 2);
        }
    };
}

%union {
    float fval;
    bool bval;
    std::string* sval;
    Node* node;
}

%token CLASS IF THEN ELSE FI LET IN WHILE LOOP POOL NOT AND OR ASSIGN
%token <fval> FLOAT
%token <bval> BOOL
%token <sval> STRING TYPE_ID OBJECT_ID
%token LT EQ NEQ PLUS MINUS MUL DIV LPAREN RPAREN LBRACE RBRACE COLON SEMI

%type <node> Program Class Feature FeatureList Expr AssignExpr LogicExpr LogicTerm LogicFactor CompareExpr ArithExpr Term Factor ExprList
%%

Program     : Class { extern Node* root; root = $1; } ;

Class       : CLASS TYPE_ID LBRACE FeatureList RBRACE SEMI { $$ = $4; } ;

FeatureList : Feature { $$ = new BlockNode($1); }
            | FeatureList Feature { ((BlockNode*)$1)->addExpr($2); $$ = $1; }
            ;

Feature     : OBJECT_ID LPAREN RPAREN COLON TYPE_ID LBRACE Expr RBRACE SEMI { $$ = $7; } 
            | OBJECT_ID LPAREN RPAREN COLON TYPE_ID LBRACE ExprList RBRACE SEMI { $$ = $7; } 
            ;
Expr        : AssignExpr | LogicExpr ;

AssignExpr  : OBJECT_ID ASSIGN Expr { $$ = new OpNode("<-", new LiteralNode(*$1), $3); } ;

LogicExpr   : LogicExpr OR LogicTerm    { $$ = new OpNode("OR", $1, $3); }
            | LogicTerm                 { $$ = $1; }
            ;

LogicTerm   : LogicTerm AND LogicFactor { $$ = new OpNode("AND", $1, $3); }
            | LogicFactor               { $$ = $1; }
            ;

LogicFactor : NOT LogicFactor           { $$ = new OpNode("NOT", $2, nullptr); }
            | CompareExpr               { $$ = $1; }
            ;

CompareExpr : ArithExpr LT ArithExpr    { $$ = new OpNode("<", $1, $3); }
            | ArithExpr EQ ArithExpr    { $$ = new OpNode("=", $1, $3); }
            | ArithExpr NEQ ArithExpr   { $$ = new OpNode("!=", $1, $3); }
            | ArithExpr                 { $$ = $1; }
            ;

ArithExpr   : ArithExpr PLUS Term       { $$ = new OpNode("+", $1, $3); }
            | ArithExpr MINUS Term      { $$ = new OpNode("-", $1, $3); }
            | Term                      { $$ = $1; }
            ;

Term        : Term MUL Factor           { $$ = new OpNode("*", $1, $3); }
            | Term DIV Factor           { $$ = new OpNode("/", $1, $3); }
            | Factor                    { $$ = $1; }
            ;

Factor      : MINUS Factor              { $$ = new OpNode("NEGATE", $2, nullptr); }
            | OBJECT_ID                 { $$ = new LiteralNode(*$1); }
            | FLOAT                     { $$ = new LiteralNode(std::to_string($1)); }
            | STRING                    { $$ = new LiteralNode(*$1); }
            | BOOL                      { $$ = new LiteralNode($1 ? "true" : "false"); }
            | LPAREN Expr RPAREN        { $$ = $2; }
            | LBRACE RBRACE             { $$ = new BlockNode(nullptr); }
            | LBRACE ExprList RBRACE    { $$ = $2; }
            | WHILE LogicExpr LOOP Expr POOL { $$ = new OpNode("WHILE", $2, $4); }
            | IF LogicExpr THEN Expr ELSE Expr FI { $$ = new OpNode("IF", $2, new OpNode("THEN_ELSE", $4, $6)); }
            ;

ExprList    : Expr SEMI                 { $$ = new BlockNode($1); }
            | ExprList Expr SEMI         { ((BlockNode*)$1)->addExpr($2); $$ = $1; }
            ;

%%

Node* root = nullptr;
extern int yylineno; 
void yyerror(const char *s) { 
    std::cerr << "Syntax Error on line " << yylineno << ": " << s << std::endl; 
}