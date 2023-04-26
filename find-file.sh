#!/bin/bash

# Prompt for the directory to search
read -p "Enter the directory to search in: " search_dir

# Validate the provided directory
if [[ ! -d "$search_dir" ]]; then
    echo "Error: Directory not found."
    exit 1
fi

# Prompt for the file name to search for
read -p "Enter the file name to search for: " file_name

# Set the output file
output_file="search_results.txt"

# Search for the file in the specified directory and save the output to the file
find "$search_dir" -type f -name "$file_name" > "$output_file"

# Check if the output file contains any results
if [[ -s "$output_file" ]]; then
    echo "Search results saved to $output_file"
else
    echo "No files found matching the search criteria."
    rm "$output_file"
fi

