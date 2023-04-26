#!/bin/bash

# Check if two arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 file1 file2"
    exit 1
fi

file1="$1"
file2="$2"

# Check if both files exist
if [[ ! -e "$file1" ]]; then
    echo "Error: $file1 does not exist."
    exit 1
fi

if [[ ! -e "$file2" ]]; then
    echo "Error: $file2 does not exist."
    exit 1
fi

# Compare file sizes and find the larger file
if [[ $(stat -c%s "$file1") -gt $(stat -c%s "$file2") ]]; then
    larger_file="$file1"
else
    larger_file="$file2"
fi

# Display the larger file and prompt for confirmation to remove it
echo "The larger file is: $larger_file"

while true; do
    read -p "Do you want to remove this file? (y/n): " choice
    case $choice in
        [Yy]*)
            rm "$larger_file"
            echo "Removed $larger_file"
            break
            ;;
        [Nn]*)
            echo "Not removing $larger_file"
            break
            ;;
        *)
            echo "Please answer 'y' or 'n'."
            ;;
    esac
done

