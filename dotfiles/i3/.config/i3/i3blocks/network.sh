#!/bin/bash

iface=$(ip route | awk '/default/ {print $5}' | head -n1)

if [[ -z "$iface" ]]; then
    echo "Offline"
    exit 0
fi

wifi=$(iwgetid -r 2>/dev/null)

if [[ -n "$wifi" ]]; then
    echo "  Connected"
else
    echo "󰈀 Connected"
fi
