%{
#include <stdio.h>
#include <stdlib.h>
%}

%%



%%

int main(int argc, char *argv[]) {
    
    FILE* in = fopen("validprogram.cl", "r");
    if (argc > 1) {
        in = fopen(argv[1], "r");
        if (!in) {
            perror("Error opening input file");
            return 1;
        }
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