#!/bin/bash

# Get the Linux distribution
if command -v lsb_release &> /dev/null; then
    os_name=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
elif [[ -f /etc/os-release ]]; then
    os_name=$(awk -F= '/^ID=/ {print tolower($2)}' /etc/os-release)
else
    echo "Error: Unable to determine Linux distribution."
    exit 1
fi

# Install containerd if it's not already installed
if ! command -v containerd > /dev/null; then
    echo "Installing containerd..."
    if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
        sudo apt-get update && sudo apt-get install -y containerd
    elif [[ "$os_name" == "centos" || "$os_name" == "redhat" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
        if [[ "$(cut -d. -f1 /etc/redhat-release | tr -dc '0-9')" == "8" ]]; then
            # Install podman-docker for Red Hat Enterprise Linux 8
            sudo yum module enable -y container-tools
            sudo yum install -y podman-docker
        else
            sudo yum update && sudo yum install -y containerd
        fi
    else
        echo "Error: Unsupported Linux distribution."
        exit 1
    fi
fi

# Check if containerd is running
if ! pgrep containerd > /dev/null; then
    echo "Starting containerd service..."
    sudo systemctl start containerd
fi

# Install kubectl
echo "Installing kubectl..."
if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
    # Add the Kubernetes package repository for Ubuntu and Debian
    sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    # Install kubectl
    sudo apt-get update && sudo apt-get install -y kubectl
elif [[ "$os_name" == "centos" || "$os_name" == "redhat" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
    if [[ "$(cut -d. -f1 /etc/redhat-release | tr -dc '0-9')" == "8" ]]; then
        # Install kubectl for Red Hat Enterprise Linux 8
        sudo dnf config-manager --add-repo=https://packages.cloud.google.com/yum/repos/kubernetes-el8-x86_64
        sudo rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
        sudo rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        sudo yum install -y kubectl
    else
        sudo yum update && sudo yum install -y kubectl
    fi
else
    echo "Error: Unsupported Linux distribution."
    exit 1
fi

# Install kubelet
echo "Installing kubelet..."
if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
    sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
elif [[ "$os_name" == "centos" || "$os_name" == "redhat" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
    if [[ "$(cut -d. -f1 /etc/redhat-release | tr -dc '0-9')" == "8" ]]; then
        # Install kubelet for Red Hat Enterprise Linux 8
        sudo dnf config-manager --add-repo=https://packages.cloud.google.com/yum/repos/kubernetes-el8-x86_64
        sudo rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg
        sudo rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        sudo dnf install -y kubelet kubeadm kubectl
    else
        sudo yum update && sudo yum install -y kubelet kubeadm kubectl
    fi
else
    echo "Error: Unsupported Linux distribution."
    exit 1
fi

# Enable and start kubelet
echo "Enabling and starting kubelet..."
sudo systemctl enable kubelet && sudo systemctl start kubelet

