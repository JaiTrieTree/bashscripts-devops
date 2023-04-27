#!/bin/bash

# Basic Monitor Script for Linux

# Set output log file
LOGFILE="/var/log/monitor.log"

# Set monitoring interval in seconds
INTERVAL=1

# Function to get CPU usage
get_cpu_usage() {
  local cpu_usage=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  echo "CPU Usage: $cpu_usage%"
}

# Function to get memory usage
get_memory_usage() {
  local mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo "Memory Usage: $mem_usage%"
}

# Function to get disk usage
get_disk_usage() {
  local disk_usage=$(df -h / | grep "/" | awk '{print $5}')
  echo "Disk Usage: $disk_usage"
}

# Main monitoring loop
while true; do
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

  # Get system metrics
  CPU_USAGE=$(get_cpu_usage)
  MEMORY_USAGE=$(get_memory_usage)
  DISK_USAGE=$(get_disk_usage)

  # Output to log file
  echo "[$TIMESTAMP] $CPU_USAGE | $MEMORY_USAGE | $DISK_USAGE" >> $LOGFILE

  # Wait for the interval
  sleep $INTERVAL
done

