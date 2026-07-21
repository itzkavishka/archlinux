#!/bin/bash

# Get active network interface
iface=$(ip route | awk '/default/ {print $5}' | head -n1)

if [[ -z "$iface" ]]; then
    echo "No network"
    exit 0
fi

# Get IP address
ip=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Get Wi-Fi SSID (if applicable)
wifi=$(iwgetid -r)

if [[ -n "$wifi" ]]; then
    quality=$(grep "$iface" /proc/net/wireless | awk '{ print int($3 * 100 / 70) "%"}')
    echo "$wifi ($quality $ip)"
else
    if [[ -n "$ip" ]]; then
        echo "ETH ($ip)"
    else
        echo "Disconnected"
    fi
fi