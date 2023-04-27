#!/bin/bash

# System Vulnerability Monitor Script for Linux

# Email settings
EMAIL="youremail@example.com"
SUBJECT="System Vulnerability Alert"

# Check if the user is root or has sudo privileges
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root or with sudo privileges." >&2
  exit 1
fi

# Function to check for security updates on Ubuntu/Debian
check_updates_debian() {
  apt-get update > /dev/null
  UPDATES=$(apt-get -s upgrade | awk '/^Inst/ { if (NF > 4) print $2 " " $5; else print $2 " " $4}' | grep -i security)
  if [ -n "$UPDATES" ]; then
    echo "Security updates available:"$'\n'"$UPDATES"
  fi
}

# Function to check for security updates on CentOS/RHEL
check_updates_centos() {
  yum check-update -q --security
  if [ $? -eq 100 ]; then
    UPDATES=$(yum updateinfo list security -q | grep -v "updateinfo list done")
    echo "Security updates available:"$'\n'"$UPDATES"
  fi
}

# Detect Linux distribution
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian|ubuntu)
      UPDATE_INFO=$(check_updates_debian)
      ;;
    centos|rhel)
      UPDATE_INFO=$(check_updates_centos)
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

# Send email notification if updates are available
if [ -n "$UPDATE_INFO" ]; then
  echo "$UPDATE_INFO" | mailx -s "$SUBJECT" "$EMAIL"
  echo "Security updates found, email sent."
else
  echo "No security updates found."
fi

