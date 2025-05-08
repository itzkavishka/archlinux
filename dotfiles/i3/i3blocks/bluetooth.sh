#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
        device=$(bluetoothctl info | awk -F': ' '/Alias/ {print $2}')
        echo "Connected: $device"
    else
        echo "Bluetooth: On"
    fi
else
    echo "Bluetooth: Off"
fi
