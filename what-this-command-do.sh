#!/bin/bash

# Prompt the user to enter a command
read -p "Enter a command to get its definition and syntax: " cmd

# Check if the command exists
if ! command -v "$cmd" &> /dev/null; then
    echo "Error: $cmd command not found."
    exit 1
fi

# Get the command's definition and syntax
echo "Definition of $cmd command:"
man "$cmd" | grep -m 1 -A1 "DESCRIPTION" | tail -n 1
echo ""
echo "Syntax of $cmd command:"
"$cmd" --help | head -n 10

