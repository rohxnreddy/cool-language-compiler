#!/bin/bash

# Loop through all files in the inputs directory
for file in inputs/*; do
    # Check if it is a regular file (skips sub-directories)
    if [ -f "$file" ]; then
        echo "========================================"
        echo "Compiling: $file"
        echo "========================================"

        # Run your compiler with the file
        ./coolc "$file"
        echo ""
        echo -e "\n--- Runner Output ---${NC}"
        ./coolc "$file" | python tac_runner.py

        # Optional: Add a blank line for readability between outputs
        echo ""
    fi
done
