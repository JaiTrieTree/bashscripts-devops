#!/bin/bash

function confirm_removal() {
    local file="$1"
    local size="$2"
    local choice

    while true; do
        read -p "Do you want to remove this file: $file (Size: $size bytes)? (y/n): " choice
        case $choice in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer 'y' or 'n'.";;
        esac
    done
}

# Find top 5 largest files in the root directory
mapfile -t top_files < <(find / -type f -printf "%s %p\n" 2>/dev/null | sort -nr | head -n 5)

# Display the top 5 largest files
echo "Top 5 largest files:"
printf "%s\n" "${top_files[@]}"

# Read each file from the list of top 5 largest files
for entry in "${top_files[@]}"; do
    size="$(echo "$entry" | cut -d ' ' -f1)"
    file="$(echo "$entry" | cut -d ' ' -f2-)"
    
    # Prompt for confirmation to remove the file
    if confirm_removal "$file" "$size"; then
        rm "$file"
        echo "Removed $file"
    else
        echo "Not removing $file"
    fi
done

