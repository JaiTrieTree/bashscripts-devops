#!/bin/bash

# Determine the Linux distribution
if [[ -e /etc/os-release ]]; then
    . /etc/os-release
    os_name="$ID"
else
    echo "Error: Unable to determine the Linux distribution."
    exit 1
fi

# Prompt the user for the log file path
read -p "Enter the log file path to check for errors: " log_file

# Check if the log file exists
if [[ ! -f "$log_file" ]]; then
    echo "Error: Log file does not exist."
    exit 1
fi

# Prompt the user for the application name
read -p "Enter the application name to check for errors: " app_name

# Check if the log file contains the application name
if grep -q -i "$app_name" "$log_file"; then
    echo "Showing errors in log file: $log_file"
    grep -i -E "error|fail|fatal|warn|exception" "$log_file" | tail -n 20
else
    echo "No log entries found for the application: $app_name"
fi

