#!/bin/bash

# Get the kernel version
kernel_version=$(uname -r)

# Get the OS release information
if [[ -e /etc/os-release ]]; then
    . /etc/os-release
    os_name="$NAME"
    os_version="$VERSION"
elif [[ -e /etc/lsb-release ]]; then
    . /etc/lsb-release
    os_name="$DISTRIB_ID"
    os_version="$DISTRIB_RELEASE"
else
    echo "Error: Unable to determine the Linux distribution."
    exit 1
fi

# Display the Linux distribution, kernel version, and system information
echo "Linux Distribution: $os_name $os_version"
echo "Kernel Version: $kernel_version"
echo "System Information:"
uname -a

