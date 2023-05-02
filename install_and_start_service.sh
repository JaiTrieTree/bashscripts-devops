#!/bin/bash

# Check if the service name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

# Store the service name
SERVICE_NAME=$1

# Detect the Linux distribution and set the package manager
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$NAME
else
  echo "Error: Could not detect the Linux distribution."
  exit 1
fi

case $OS in
  "Ubuntu"|"Debian GNU/Linux")
    PKG_MANAGER="apt-get"
    ;;
  "CentOS Linux"|"Red Hat Enterprise Linux Server")
    PKG_MANAGER="yum"
    ;;
  *)
    echo "Error: Unsupported Linux distribution."
    exit 1
    ;;
esac

# Update package repository
echo "Updating package repository..."
$PKG_MANAGER update

# Install the service
echo "Installing $SERVICE_NAME..."
$PKG_MANAGER install -y $SERVICE_NAME

# Check if the service is installed
if ! systemctl list-unit-files | grep -q "$SERVICE_NAME.service"; then
  echo "Error: $SERVICE_NAME could not be installed."
  exit 1
fi

# Start the service
echo "Starting $SERVICE_NAME..."
systemctl start $SERVICE_NAME

# Enable the service to start on boot
echo "Enabling $SERVICE_NAME to start on boot..."
systemctl enable $SERVICE_NAME

# Check if the service is running
if systemctl is-active --quiet $SERVICE_NAME; then
  echo "$SERVICE_NAME is now running."
else
  echo "Error: $SERVICE_NAME could not be started."
  exit 1
fi

