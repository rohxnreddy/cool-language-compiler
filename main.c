#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "tac.h"

/* External declarations for Flex and Bison */
extern FILE *yyin;
extern int yyparse();

/* * This global variable should be defined in your cool.y or ast.c file.
 * The parser will assign the root of the constructed AST to this variable 
 * upon successful parsing of the Start Symbol.
 */
extern ASTNode* ast_root; 

int main(int argc, char **argv) {
    // 1. Handle command-line arguments
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file.cl>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // 2. Open the input file
    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error opening input file");
        return EXIT_FAILURE;
    }

    // 3. Set Flex's input stream to our file
    yyin = input_file;

    // 4. Call the parser
    printf("Starting compilation for: %s\n", argv[1]);
    int parse_result = yyparse();

    // 5. Check parsing result and generate TAC
    if (parse_result == 0) {
        printf("Parsing completed successfully. Generating Three-Address Code...\n\n");
        
        if (ast_root != NULL) {
            // 1. Create the list structure on the stack
            TACList tac_list;
            
            // 2. Initialize it
            init_tac_list(&tac_list);
            
            // 3. Generate the TAC
            generate_tac(ast_root, &tac_list);
            
            // 4. Print the generated instructions
            print_tac_list(&tac_list);
            
            // 5. Clean up
            free_tac_list(&tac_list);
            
        } else {
            fprintf(stderr, "Error: AST root is NULL after successful parsing.\n");
        }
    } else {
        // yyerror() will have already printed the specific syntax error.
        printf("Parsing failed due to syntax errors. Compilation halted.\n");
    }

    // 6. Cleanup
    fclose(input_file);
    return parse_result == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}