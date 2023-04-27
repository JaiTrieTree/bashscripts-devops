#!/bin/bash

# System Update and Upgrade Script for Linux
# Author: TIF

# Check if the user is root or has sudo privileges
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root or with sudo privileges." >&2
  exit 1
fi

# Function to update and upgrade packages on Ubuntu/Debian
update_upgrade_debian() {
  apt-get update
  apt-get upgrade -y
  apt-get autoremove -y
  apt-get autoclean
}

# Function to update and upgrade packages on CentOS/RHEL
update_upgrade_centos() {
  yum update -y
  yum clean all
}

# Detect Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian|ubuntu)
      echo "Detected distribution: $PRETTY_NAME"
      update_upgrade_debian
      ;;
    centos|rhel)
      echo "Detected distribution: $PRETTY_NAME"
      update_upgrade_centos
      ;;
    *)
      echo "Unsupported distribution: $PRETTY_NAME" >&2
      exit 1
      ;;
  esac
else
  echo "Unable to detect the Linux distribution." >&2
  exit 1
fi

echo "System update and upgrade completed."

