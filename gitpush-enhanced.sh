#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    # Prompt the user to install git based on the Linux distribution
    if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
        read -p "git is not installed. Do you want to install it? (y/n): " confirm_install
        if [[ "$confirm_install" == "y" ]]; then
            sudo apt-get update && sudo apt-get install git
        else
            echo "Aborting push. git is not installed."
            exit 1
        fi
    elif [[ "$os_name" == "rhel" || "$os_name" == "centos" || "$os_name" == "fedora" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
        read -p "git is not installed. Do you want to install it? (y/n): " confirm_install
        if [[ "$confirm_install" == "y" ]]; then
            sudo yum update && sudo yum install git
        else
            echo "Aborting push. git is not installed."
            exit 1
        fi
    else
        echo "Error: Unsupported Linux distribution."
        exit 1
    fi
fi

# Check if the user is logged in to GitHub
if ! git config user.username &> /dev/null; then
    echo "You are not logged in to GitHub."
    read -p "Enter your GitHub username: " github_username
    read -p "Enter your GitHub access token: " github_token
    git config --global user.username "$github_username"
    git config --global user.password "$github_token"
fi

# Ensure that the current directory is a git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    read -p "This directory is not a git repository. Do you want to initialize it? (y/n): " confirm_init
    if [[ "$confirm_init" == "y" ]]; then
        git init
    else
        echo "Aborting push. This directory is not a git repository."
        exit 1
    fi
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

