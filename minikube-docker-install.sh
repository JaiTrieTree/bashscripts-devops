#!/bin/bash

# Set the Minikube version
MINIKUBE_VERSION="latest"

# Check the Linux distribution
if [ -f /etc/redhat-release ]; then
  # Install Podman on Red Hat-based systems
  echo "Installing Podman on Red Hat-based system..."
  sudo dnf install -y curl
  curl -LO https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
  chmod +x minikube-linux-amd64
  sudo mv minikube-linux-amd64 /usr/local/bin/minikube
  sudo dnf install -y podman

  # Uninstall Minikube and Podman on Red Hat-based systems
  echo "Do you want to uninstall Minikube and Podman? (y/n)"
  read uninstall
  if [ "$uninstall" = "y" ]; then
    sudo minikube delete
    sudo rm /usr/local/bin/minikube
    sudo dnf remove -y podman
  fi

elif [ -f /etc/debian_version ]; then
  # Install Docker on Debian-based systems
  echo "Installing Docker on Debian-based system..."
  sudo apt-get update
  sudo apt-get install -y curl
  curl -LO https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
  chmod +x minikube-linux-amd64
  sudo mv minikube-linux-amd64 /usr/local/bin/minikube
  sudo apt-get install -y docker.io

  # Uninstall Minikube and Docker on Debian-based systems
  echo "Do you want to uninstall Minikube and Docker? (y/n)"
  read uninstall
  if [ "$uninstall" = "y" ]; then
    sudo minikube delete
    sudo rm /usr/local/bin/minikube
    sudo apt-get remove -y docker.io
  fi

else
  # Unsupported Linux distribution
  echo "Error: Unsupported Linux distribution."
  exit 1
fi

# Start Minikube with specified driver
echo "Starting Minikube..."
minikube start --driver=docker

# Verify the installation
echo "Verifying the installation..."
kubectl version --short
