#!/bin/bash

# Set the Minikube version
MINIKUBE_VERSION="latest"

# Check the Linux distribution
if [ -f /etc/redhat-release ]; then
  # Install Minikube on Red Hat-based systems
  echo "Installing Minikube on Red Hat-based system..."
  sudo dnf install -y curl
  curl -LO https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
  chmod +x minikube-linux-amd64
  sudo mv minikube-linux-amd64 /usr/local/bin/minikube

elif [ -f /etc/debian_version ]; then
  # Install Minikube on Debian-based systems
  echo "Installing Minikube on Debian-based system..."
  sudo apt-get update
  sudo apt-get install -y curl
  curl -LO https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
  chmod +x minikube-linux-amd64
  sudo mv minikube-linux-amd64 /usr/local/bin/minikube

else
  # Unsupported Linux distribution
  echo "Error: Unsupported Linux distribution."
  exit 1
fi

# Start Minikube
echo "Starting Minikube..."
minikube start --vm-driver=docker

# Verify the installation
echo "Verifying the installation..."
kubectl version --short

