#!/bin/bash

# Network Diagnostics Script
# Author: TIF

function ping_host() {
  read -rp "Enter the target hostname or IP address: " TARGET
  ping -c 4 "${TARGET}"
}

function traceroute_host() {
  read -rp "Enter the target hostname or IP address: " TARGET
  traceroute "${TARGET}"
}

function analyze_traffic() {
  read -rp "Enter the network interface (e.g., eth0, wlan0): " INTERFACE
  read -rp "Enter the number of packets to capture (e.g., 10, 100): " PACKET_COUNT
  sudo tcpdump -i "${INTERFACE}" -c "${PACKET_COUNT}"
}

echo "Select an option:"
echo "1. Ping host"
echo "2. Traceroute host"
echo "3. Analyze network traffic"

read -rp "Enter the option number: " OPTION

case $OPTION in
  1) ping_host ;;
  2) traceroute_host ;;
  3) analyze_traffic ;;
  *) echo "Invalid option" ;;
esac

