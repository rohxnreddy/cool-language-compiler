/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_HPP_INCLUDED
# define YY_YY_PARSER_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 13 "parser.y"

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

#line 96 "parser.tab.hpp"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    CLASS = 258,                   /* CLASS  */
    IF = 259,                      /* IF  */
    THEN = 260,                    /* THEN  */
    ELSE = 261,                    /* ELSE  */
    FI = 262,                      /* FI  */
    LET = 263,                     /* LET  */
    IN = 264,                      /* IN  */
    WHILE = 265,                   /* WHILE  */
    LOOP = 266,                    /* LOOP  */
    POOL = 267,                    /* POOL  */
    NOT = 268,                     /* NOT  */
    AND = 269,                     /* AND  */
    OR = 270,                      /* OR  */
    ASSIGN = 271,                  /* ASSIGN  */
    FLOAT = 272,                   /* FLOAT  */
    BOOL = 273,                    /* BOOL  */
    STRING = 274,                  /* STRING  */
    TYPE_ID = 275,                 /* TYPE_ID  */
    OBJECT_ID = 276,               /* OBJECT_ID  */
    LT = 277,                      /* LT  */
    EQ = 278,                      /* EQ  */
    NEQ = 279,                     /* NEQ  */
    PLUS = 280,                    /* PLUS  */
    MINUS = 281,                   /* MINUS  */
    MUL = 282,                     /* MUL  */
    DIV = 283,                     /* DIV  */
    LPAREN = 284,                  /* LPAREN  */
    RPAREN = 285,                  /* RPAREN  */
    LBRACE = 286,                  /* LBRACE  */
    RBRACE = 287,                  /* RBRACE  */
    COLON = 288,                   /* COLON  */
    SEMI = 289                     /* SEMI  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 60 "parser.y"

    float fval;
    bool bval;
    std::string* sval;
    Node* node;

#line 154 "parser.tab.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_HPP_INCLUDED  */
