#!/bin/bash

for file in inputs/*; do
    if [ -f "$file" ]; then
        echo "========================================"
        echo "Compiling: $file"
        echo "========================================"
        ./coolc "$file"
        echo ""
        echo -e "\n--- Runner Output ---${NC}"
        ./coolc "$file" | python3 tac_runner.py
        echo ""
    fi
done
