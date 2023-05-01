#!/bin/bash
# Usage: sudo ./install_and_start_service.sh <service_name>
# Replace <service_name> with the name of the service you want to install and start, such as nginx, apache2, or mysql.

# Check if the service name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

# Store the service name
SERVICE_NAME=$1

# Update package repository
echo "Updating package repository..."
apt-get update

# Install the service
echo "Installing $SERVICE_NAME..."
apt-get install -y $SERVICE_NAME

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
