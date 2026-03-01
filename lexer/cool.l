%{
#include <stdio.h>
#include <stdlib.h>
%}

DIGIT       [0-9]
LOWER       [a-z]
UPPER       [A-Z]
ALPHANUM    [a-zA-Z0-9_]
TYPEID      {UPPER}{ALPHANUM}*
OBJECTID    {LOWER}{ALPHANUM}*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+"."{DIGIT}+
STRING      \"([^\\\"\n]|\\.)*\"

%x COMMENT

%%

"(*"                    { BEGIN(COMMENT); }
<COMMENT>"*)"           { BEGIN(INITIAL); }
<COMMENT>.|\n           { /* Skip everything inside the comment state */ }
<COMMENT><<EOF>>        { fprintf(yyout, "LEXER ERROR: EOF inside comment\n"); return 0; }

[ \t\r\n\f\v]+          { /* Skip whitespace */ }
"--".*                  { /* Skip single line comments */ }
"class"|"else"|"fi"|"if"|"in"|"inherits"|"isvoid"|"let"|"loop"|"pool"|"then"|"while"|"case"|"esac"|"new"|"of"|"not"|"and"|"or" { fprintf(yyout, "KEYWORD: %s\n", yytext); }
"true"|"false"          {fprintf(yyout, "BOOLEAN: %s\n", yytext);}
{TYPEID}                {fprintf(yyout, "TYPE_ID: %s\n", yytext);}
{OBJECTID}              {fprintf(yyout, "OBJECT_ID: %s\n", yytext);}
{FLOAT}                 {fprintf(yyout, "FLOAT: %s\n", yytext);}
{INTEGER}               {fprintf(yyout, "INTEGER: %s\n", yytext);}
{STRING}                {fprintf(yyout, "STRING: %s\n", yytext);}
"<-"                    {fprintf(yyout, "ASSIGN\n"); }
"=>"                    {fprintf(yyout, "DARROW\n"); }
"<="                    {fprintf(yyout, "LE\n"); }
">="                    {fprintf(yyout, "GE\n"); }
"!="                    {fprintf(yyout, "NE\n"); }
"{"                     {fprintf(yyout, "LBRACE\n"); }
"}"                     {fprintf(yyout, "RBRACE\n"); }
"("                     {fprintf(yyout, "LPAREN\n"); }
")"                     {fprintf(yyout, "RPAREN\n"); }
":"                     {fprintf(yyout, "COLON\n"); }
";"                     {fprintf(yyout, "SEMICOLON\n"); }
","                     {fprintf(yyout, "COMMA\n"); }
"."                     {fprintf(yyout, "DOT\n"); }
"+"                     {fprintf(yyout, "PLUS\n"); }
"-"                     {fprintf(yyout, "MINUS\n"); }
"*"                     {fprintf(yyout, "MULT\n"); }
"/"                     {fprintf(yyout, "DIV\n"); }
"~"                     {fprintf(yyout, "NEG\n"); }
"<"                     {fprintf(yyout, "LT\n"); }
">"                     {fprintf(yyout, "GT\n"); }
"="                     {fprintf(yyout, "EQ\n"); }
"@"                     {fprintf(yyout, "AT\n"); }
.                       {fprintf(yyout, "LEXER ERROR: Unrecognized character '%s'\n", yytext); }

%%

int main(int argc, char *argv[]) {
    
    const char *filename = (argc > 1) ? argv[1] : "validprogram.cl";
    FILE *in = fopen(filename, "r");
    if (!in) {
        perror("Error opening input file");
        return 1;
    }

    yyin = in;

    FILE *out = fopen("output.txt", "w");
    if (!out) {
        perror("Error opening output file");
        return 1;
    }

    yyout = out;

    yylex();

    fclose(in);
    fclose(out);

    return 0;
}