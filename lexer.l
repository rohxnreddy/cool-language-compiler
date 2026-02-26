%{
#include <string>
#include "parser.tab.hpp"
%}

%option noyywrap
%option yylineno

%%

"class"     { return CLASS; }
"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"fi"        { return FI; }
"let"       { return LET; }
"in"        { return IN; }
"while"     { return WHILE; }
"loop"      { return LOOP; }
"pool"      { return POOL; }
"not"       { return NOT; }
"and"       { return AND; }
"or"        { return OR; }
"<-"        { return ASSIGN; }
"<"         { return LT; }
"="         { return EQ; }
"!="        { return NEQ; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
":"         { return COLON; }
";"         { return SEMI; }

[0-9]+"."[0-9]* { yylval.fval = atof(yytext); return FLOAT; }
\"[^\"]*\"       { yylval.sval = new std::string(yytext); return STRING; }
"true"|"false"  { yylval.bval = (std::string(yytext) == "true"); return BOOL; }
[a-z][a-zA-Z0-9_]* { yylval.sval = new std::string(yytext); return OBJECT_ID; }
[A-Z][a-zA-Z0-9_]* { yylval.sval = new std::string(yytext); return TYPE_ID; }

[ \t\n\r]+  { /* skip */ }
"--".* { /* skip */ }
.           { return yytext[0]; }

%%