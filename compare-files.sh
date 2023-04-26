#!/bin/bash

# Prompt for the first file
read -p "Enter the path to the first file: " file1

# Check if the first file exists
if [[ ! -f "$file1" ]]; then
    echo "Error: $file1 does not exist or is not a file."
    exit 1
fi

# Prompt for the second file
read -p "Enter the path to the second file: " file2

# Check if the second file exists
if [[ ! -f "$file2" ]]; then
    echo "Error: $file2 does not exist or is not a file."
    exit 1
fi

# Prompt for the output file
read -p "Enter the path to the output file: " output_file

# Compare the files and print the differences
diff_output=$(diff -u "$file1" "$file2")

# Check if there are any differences
if [[ -z "$diff_output" ]]; then
    echo "No differences found."
else
    # Print the differences to the output file with line numbers
    echo "$diff_output" | grep -E '^[\+\-]' | awk '{print NR, $0}' > "$output_file"
    echo "Differences written to $output_file."
fi

