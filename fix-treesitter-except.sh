#!/bin/bash

# Script to fix the except* treesitter query issue
# This removes the problematic except* entries from treesitter query files

echo "Fixing treesitter except* query issue..."

NVIM_DATA_DIR="$HOME/.local/share/nvim"
QUERY_FILES=(
    "$NVIM_DATA_DIR/lazy/nvim-treesitter/queries/python/highlights.scm"
    "$NVIM_DATA_DIR/lazy/nvim-treesitter/queries/bitbake/highlights.scm"
)

for file in "${QUERY_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        # Create backup if it doesn't exist
        if [ ! -f "$file.backup" ]; then
            cp "$file" "$file.backup"
            echo "  Created backup: $file.backup"
        fi
        
        # Remove the problematic except* line
        sed -i '/^  "except\*"$/d' "$file"
        echo "  Removed except* entries from $file"
    else
        echo "File not found: $file"
    fi
done

echo "Fix applied! You should now be able to open files in Neo-tree without errors."