%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "y.tab.h"
%}

%option yylineno
%option noyywrap

DIGIT       [0-9]
LOWER       [a-z]
UPPER       [A-Z]
ALPHANUM    [a-zA-Z0-9_]
TYPEID      {UPPER}{ALPHANUM}*
OBJECTID    {LOWER}{ALPHANUM}*
INTEGER     {DIGIT}+
STRING      \"([^\\\"\n]|\\.)*\"

%x COMMENT

%%

"(*"                    { BEGIN(COMMENT); }
<COMMENT>"*)"           { BEGIN(INITIAL); }
<COMMENT>(.|\n)         { /* skip */ }
<COMMENT><<EOF>>        { fprintf(stderr, "LEXER ERROR: EOF inside comment at line %d\n", yylineno); return 0; }

[ \t\r\n\f\v]+          { /* skip */ }
"--".*                  { /* skip line comment */ }

"class"                 { return CLASS; }
"let"                   { return LET; }
"in"                    { return IN; }
"while"                 { return WHILE; }
"loop"                  { return LOOP; }
"pool"                  { return POOL; }
"if"                    { return IF; }
"then"                  { return THEN; }
"else"                  { return ELSE; }
"fi"                    { return FI; }
"and"                   { return AND; }
"not"                   { return NOT; }

"true"                  { yylval.bool_val = true;  return BOOL; }
"false"                 { yylval.bool_val = false; return BOOL; }
{INTEGER}               { yylval.int_val = atoi(yytext); return INT; }
{STRING}                { yylval.str_val = strdup(yytext); return STRING; }

{TYPEID}                { yylval.str_val = strdup(yytext); return TYPE; }
{OBJECTID}              { yylval.str_val = strdup(yytext); return ID; }

"<-"                    { return ASSIGN; }
"{"                     { return '{'; }
"}"                     { return '}'; }
"("                     { return '('; }
")"                     { return ')'; }
":"                     { return ':'; }
";"                     { return ';'; }
","                     { return ','; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"<"                     { return '<'; }
"<="                    { return LE; }

.                       { fprintf(stderr, "LEXER ERROR line %d: Unrecognized character '%s'\n", yylineno, yytext); return yytext[0]; }

%%
