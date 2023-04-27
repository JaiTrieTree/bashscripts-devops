#!/bin/bash

# User and Permissions Management Script
# Author: TIF

function create_user() {
  read -rp "Enter the username: " USERNAME
  sudo adduser "${USERNAME}"
}

function delete_user() {
  read -rp "Enter the username: " USERNAME
  sudo deluser --remove-home "${USERNAME}"
}

function modify_user() {
  read -rp "Enter the current username: " CURRENT_USERNAME
  read -rp "Enter the new username: " NEW_USERNAME
  sudo usermod -l "${NEW_USERNAME}" "${CURRENT_USERNAME}"
}

function manage_permissions() {
  read -rp "Enter the username: " USERNAME
  read -rp "Enter the directory path: " DIR_PATH
  read -rp "Enter the desired permissions (e.g., rwx, r-x): " PERMISSIONS
  sudo setfacl -m "u:${USERNAME}:${PERMISSIONS}" "${DIR_PATH}"
}

echo "Select an option:"
echo "1. Create user"
echo "2. Delete user"
echo "3. Modify user"
echo "4. Manage permissions"

read -rp "Enter the option number: " OPTION

case $OPTION in
  1) create_user ;;
  2) delete_user ;;
  3) modify_user ;;
  4) manage_permissions ;;
  *) echo "Invalid option" ;;
esac

