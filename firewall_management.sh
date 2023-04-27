#!/bin/bash

# Firewall and Security Management Script
# Author: TIF

function add_rule() {
  read -rp "Enter the protocol (e.g., tcp, udp): " PROTOCOL
  read -rp "Enter the source IP address (or 'any' for any IP address): " SOURCE_IP
  read -rp "Enter the destination port: " DEST_PORT

  if [ "$SOURCE_IP" = "any" ]; then
    SOURCE_IP="0.0.0.0/0"
  fi

  sudo iptables -A INPUT -p "${PROTOCOL}" -s "${SOURCE_IP}" --dport "${DEST_PORT}" -j ACCEPT
}

function delete_rule() {
  read -rp "Enter the rule number: " RULE_NUMBER
  sudo iptables -D INPUT "${RULE_NUMBER}"
}

function list_rules() {
  sudo iptables -L INPUT --line-numbers
}

echo "Select an option:"
echo "1. Add firewall rule"
echo "2. Delete firewall rule"
echo "3. List firewall rules"

read -rp "Enter the option number: " OPTION

case $OPTION in
  1) add_rule ;;
  2) delete_rule ;;
  3) list_rules ;;
  *) echo "Invalid option" ;;
esac

