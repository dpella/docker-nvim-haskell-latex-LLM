#!/bin/bash
# Fix line endings - convert CRLF to LF

echo "Fixing line endings in otherfiles and ssh directories..."

for dir in otherfiles ssh; do
    if [ -d "$dir" ]; then
        find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
            echo "Processing: $file"
            sed -i 's/\r$//' "$file"
        done
    fi
done

echo "Done! All files converted to Unix line endings (LF)"
