#!/bin/bash

# Prompt the user for package names
read -p "Enter the package names to check (separated by spaces): " input_packages

# Convert the input string to an array
IFS=' ' read -ra packages <<< "$input_packages"

# Determine the Linux distribution
if [[ -e /etc/os-release ]]; then
    . /etc/os-release
    os_name="$ID"
else
    echo "Error: Unable to determine the Linux distribution."
    exit 1
fi

# Define package manager and package query command based on the Linux distribution
case $os_name in
    "ubuntu"|"debian")
        package_manager="apt"
        package_query_command="dpkg-query -W -f='\${Status}'"
        ;;
    "rhel"|"centos"|"fedora"|"almalinux"|"rocky")
        package_manager="yum"
        package_query_command="rpm -q"
        ;;
    *)
        echo "Error: Unsupported Linux distribution."
        exit 1
        ;;
esac

# Check if the packages are installed
for package in "${packages[@]}"; do
    if $package_query_command "$package" &> /dev/null; then
        echo "$package is installed."
    else
        echo "$package is not installed."
    fi
done

