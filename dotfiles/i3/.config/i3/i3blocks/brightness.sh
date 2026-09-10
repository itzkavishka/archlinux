#!/bin/bash

# Cache file for fast responsiveness during scrolling
CACHE_FILE="/tmp/.brightness_level_${UID:-$(id -u)}"

get_system_brightness() {
    local lvl=""
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        if command -v brightnessctl &>/dev/null; then
            local max curr
            max=$(brightnessctl max 2>/dev/null)
            curr=$(brightnessctl get 2>/dev/null)
            if [[ -n "$max" && "$max" -gt 0 && -n "$curr" ]]; then
                lvl=$(( (curr * 10 + max / 2) / max ))
            fi
        fi
    else
        local display b_val
        display=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')
        if [[ -n "$display" ]]; then
            b_val=$(xrandr --verbose 2>/dev/null | awk -v d="$display" '$1 == d {p=1; next} p && /connected/ {p=0} p && /Brightness:/ {print $2; exit}')
            if [[ -n "$b_val" ]]; then
                lvl=$(awk -v v="$b_val" 'BEGIN {
                    l = int(v * 10 + 0.5);
                    if (l < 1) l = 1;
                    if (l > 10) l = 10;
                    print l;
                }')
            fi
        fi
    fi

    if [[ "$lvl" =~ ^([1-9]|10)$ ]]; then
        echo "$lvl"
    else
        echo 6
    fi
}

set_brightness() {
    local lvl="$1"
    local value

    if [ "$lvl" -eq 10 ]; then
        value="1.0"
    else
        value="0.$lvl"
    fi

    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        # Wayland: use brightnessctl (hardware backlight)
        local pct=$(( lvl * 10 ))
        if command -v brightnessctl &>/dev/null; then
            brightnessctl set "${pct}%" >/dev/null 2>&1
        fi
    else
        # X11: use xrandr software brightness
        local display
        display=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')
        if [[ -n "$display" ]]; then
            xrandr --output "$display" --brightness "$value" --gamma 1:1:1 2>/dev/null
        fi
    fi

    echo "$lvl" > "$CACHE_FILE" 2>/dev/null
}

# Support command-line arguments for manual testing or keybindings
case "$1" in
    up|+|-i|increase)   BLOCK_BUTTON=4 ;;
    down|-|--decrease) BLOCK_BUTTON=5 ;;
    [1-9]|10)
        set_brightness "$1"
        ;;
esac

# Retrieve current brightness level
if [[ -f "$CACHE_FILE" ]]; then
    level=$(cat "$CACHE_FILE" 2>/dev/null)
    if [[ ! "$level" =~ ^([1-9]|10)$ ]]; then
        level=$(get_system_brightness)
        echo "$level" > "$CACHE_FILE" 2>/dev/null
    fi
else
    level=$(get_system_brightness)
    echo "$level" > "$CACHE_FILE" 2>/dev/null
fi

# Handle mouse interaction (i3blocks sets BLOCK_BUTTON)
case "$BLOCK_BUTTON" in
    2)
        # Middle click: reset to default level 6 (60%)
        level=6
        set_brightness "$level"
        ;;
    4)
        # Scroll up: increase brightness by 1 (max 10)
        (( level < 10 )) && (( level++ ))
        set_brightness "$level"
        ;;
    5)
        # Scroll down: decrease brightness by 1 (min 1)
        (( level > 1 )) && (( level-- ))
        set_brightness "$level"
        ;;
    *)
        # If invoked without button (interval/signal refresh), re-sync with display
        if [[ -z "$BLOCK_BUTTON" && -z "$1" ]]; then
            level=$(get_system_brightness)
            echo "$level" > "$CACHE_FILE" 2>/dev/null
        fi
        ;;
esac

# Choose icon based on brightness tier
if [ "$level" -ge 7 ]; then
    icon="󰃠"
elif [ "$level" -ge 4 ]; then
    icon="󰃟"
else
    icon="󰃞"
fi

pct=$(( level * 10 ))

# Output for i3blocks:
# Line 1: full text
# Line 2: short text
# Line 3: color
echo "$icon $pct%"
echo "$icon $pct%"
echo "#e5c07b"
