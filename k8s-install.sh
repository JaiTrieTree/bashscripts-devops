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
        sudo yum update && sudo yum install -y containerd
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

# Load kernel modules
if ! lsmod | grep br_netfilter > /dev/null; then
    echo "Loading kernel module br_netfilter..."
    sudo modprobe br_netfilter
fi

# Enable IP forwarding
if [[ $(cat /proc/sys/net/ipv4/ip_forward) -ne 1 ]]; then
    echo "Enabling IP forwarding..."
    sudo sysctl -w net.ipv4.ip_forward=1
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
    sudo yum update && sudo yum install -y kubectl
else
    echo "Error: Unsupported Linux distribution."
    exit 1
fi

# Install kubeadm
echo "Installing kubeadm..."
if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
    sudo apt-get update && sudo apt-get install -y kubeadm
elif [[ "$os_name" == "centos" || "$os_name" == "redhat" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
    sudo yum update && sudo yum install -y kubeadm
else
    echo "Error: Unsupported Linux distribution."
    exit 1
fi

# Install kubelet
echo "Installing kubelet..."
if [[ "$os_name" == "ubuntu" || "$os_name" == "debian" ]]; then
    sudo apt-get update && sudo apt-get install -y kubelet
elif [[ "$os_name" == "centos" || "$os_name" == "redhat" || "$os_name" == "almalinux" || "$os_name" == "rocky" ]]; then
    sudo yum update && sudo yum install -y kubelet
else
    echo "Error: Unsupported Linux distribution."
    exit 1
fi

# Configure kubelet
echo "Configuring kubelet..."
sudo systemctl enable kubelet && sudo systemctl start kubelet

# Initialize the cluster
echo "Initializing the cluster..."
sudo kubeadm init

# Configure kubectl for the current user
echo "Configuring kubectl..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install flannel networking
echo "Installing flannel networking..."
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Show the join command for worker nodes
echo "To add worker nodes to the cluster, run the following command on each worker node:"
sudo kubeadm token create --print-join-command

