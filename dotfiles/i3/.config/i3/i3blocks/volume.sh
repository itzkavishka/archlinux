#!/bin/bash

# Get the explicit default sink
SINK=$(pactl info 2>/dev/null | grep 'Default Sink' | cut -d' ' -f3)
[ -z "$SINK" ] && SINK="@DEFAULT_SINK@"

# Handle clicks
case $BLOCK_BUTTON in
    1) pactl set-sink-mute "$SINK" toggle >/dev/null 2>&1 || amixer set Master toggle >/dev/null 2>&1 ;;
    2) pactl set-sink-volume "$SINK" 50% >/dev/null 2>&1 || amixer set Master 50% >/dev/null 2>&1 ;;
    3) exec pavucontrol >/dev/null 2>&1 ;;
    4) pactl set-sink-volume "$SINK" +5% >/dev/null 2>&1 || amixer set Master 5%+ >/dev/null 2>&1 ;;
    5) pactl set-sink-volume "$SINK" -5% >/dev/null 2>&1 || amixer set Master 5%- >/dev/null 2>&1 ;;
esac

# Get mute status
mute_status=$(pactl get-sink-mute "$SINK" 2>/dev/null | awk '{print $2}')
if [ -z "$mute_status" ]; then
    # Fallback to ALSA for mute status
    if amixer sget Master 2>/dev/null | grep -q '\[off\]'; then
        mute_status="yes"
    fi
fi

if [[ "$mute_status" == *"yes"* ]]; then
    echo "󰖁 Muted"
    echo "󰖁 Muted"
    echo "#ff7f81"
else
    # Get volume percentage
    vol=$(pactl get-sink-volume "$SINK" 2>/dev/null | grep -o '[0-9]*%' | head -1 | tr -d '%')
    
    if [ -z "$vol" ]; then
        # Fallback to amixer if pactl fails to get volume
        vol=$(amixer sget Master 2>/dev/null | grep -o '[0-9]*%' | head -1 | tr -d '%')
        if [ -z "$vol" ]; then
            echo "󰕿 Err"
            echo "󰕿 Err"
            echo "#ff7f81"
            exit 0
        fi
    fi
    
    if [ "$vol" -eq 0 ]; then
        icon="󰕿"
    elif [ "$vol" -lt 50 ]; then
        icon="󰖀"
    else
        icon="󰕾"
    fi
    
    echo "$icon $vol%"
    echo "$icon $vol%"
    echo "#7f3fbf"
fi
