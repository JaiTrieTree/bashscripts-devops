#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

# Ensure that the current directory is a git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: Not in a git repository."
    exit 1
fi

# Check for modified files and folders
modified_files=$(git status --porcelain | grep -E "^(M|A)")

if [[ -z "$modified_files" ]]; then
    echo "No modified files or folders to push."
    exit 0
else
    echo "Modified files and folders:"
    echo "$modified_files"
fi

# Prompt for confirmation
read -p "Do you want to push these changes to GitHub? (y/n): " confirm_push

if [[ "$confirm_push" != "y" ]]; then
    echo "Aborting push."
    exit 0
fi

# Add modified files and folders to the staging area
git add -A

# Commit the changes
read -p "Enter a commit message: " commit_message
git commit -m "$commit_message"

# Push the changes to GitHub
git push
echo "Changes pushed to GitHub."

