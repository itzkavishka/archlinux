#!/bin/bash
# Startup script - runs on i3 start

# --- Start V2Ray ---
CONFIG="/etc/v2ray/config.json"
PIDFILE="/tmp/v2ray.pid"
LOGFILE="/tmp/v2ray.log"

if [ -f "$CONFIG" ]; then
    # Kill any existing v2ray process
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
        kill $(cat "$PIDFILE") 2>/dev/null
    fi
    v2ray run -c "$CONFIG" > "$LOGFILE" 2>&1 &
    echo $! > "$PIDFILE"
fi

# --- Set brightness on display ---
# Wait for displays to be fully initialized
sleep 2
display=$(xrandr --query | awk '/ connected/{print $1; exit}')
if [ -n "$display" ]; then
    xrandr --output "$display" --brightness 0.6 --gamma 1:1:1 2>/dev/null
fi
