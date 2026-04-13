#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "tac.h"

extern int yyparse(void);
extern FILE* yyin;
extern ASTNode* ast_root;

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input.cool>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("fopen");
        return 1;
    }

    if (yyparse() == 0) {
        generate_tac(ast_root);
    } else {
        fclose(yyin);
        return 1;
    }

    fclose(yyin);
    return 0;
}
