#!/bin/bash

# Mail Server Installation Script for Linux
# Author: TIF

# Check if the user is root or has sudo privileges
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root or with sudo privileges." >&2
  exit 1
fi

# Function to install Postfix on Ubuntu/Debian
install_postfix_debian() {
  apt-get update
  apt-get install -y postfix mailutils
}

# Function to install Postfix on CentOS/RHEL
install_postfix_centos() {
  yum install -y epel-release
  yum install -y postfix mailx
  systemctl enable postfix
  systemctl start postfix
}

# Detect Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian|ubuntu)
      echo "Detected distribution: $PRETTY_NAME"
      install_postfix_debian
      ;;
    centos|rhel)
      echo "Detected distribution: $PRETTY_NAME"
      install_postfix_centos
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

echo "Postfix mail server installation completed."

