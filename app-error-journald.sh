#!/bin/bash

# Determine the Linux distribution
if [[ -e /etc/os-release ]]; then
    . /etc/os-release
    os_name="$ID"
else
    echo "Error: Unable to determine the Linux distribution."
    exit 1
fi

# Check if journalctl is available
if ! command -v journalctl &> /dev/null; then
    echo "Error: journalctl is not available on this system."
    exit 1
fi

# Prompt the user for the application name
read -p "Enter the application name to check for errors: " app_name

# Check logs for the application and show the latest 20 error messages
journalctl -t "$app_name" -p err -n 20 --no-pager

