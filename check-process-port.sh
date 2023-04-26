#!/bin/bash

function confirm_kill() {
    local pid="$1"
    local choice

    while true; do
        read -p "Do you want to kill the process with PID $pid? (y/n): " choice
        case $choice in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer 'y' or 'n'.";;
        esac
    done
}

# Prompt for the process name
read -p "Enter the process name to check: " process_name

# Exit if no process name is provided
if [[ -z "$process_name" ]]; then
    echo "No process name provided. Exiting."
    exit 1
fi

# Check if the process is running
process_pid=$(pgrep -f "$process_name")

if [[ -n "$process_pid" ]]; then
    echo "Process $process_name is running with PID(s): $process_pid"
    # Ask if the user wants to kill the process
    for pid in $process_pid; do
        if confirm_kill "$pid"; then
            kill "$pid"
            echo "Killed process with PID $pid"
        else
            echo "Not killing process with PID $pid"
        fi
    done
else
    echo "Process $process_name is not running."
fi

# Prompt for the port number
read -p "Enter the port number to check: " port_number

# Exit if no port number is provided
if [[ -z "$port_number" ]]; then
    echo "No port number provided. Exiting."
    exit 1
fi

# Check if the port is listening
if ss -tln | grep -q ":$port_number"; then
    echo "Port $port_number is listening."
else
    echo "Port $port_number is not listening."
fi

