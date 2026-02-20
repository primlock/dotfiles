#!/usr/bin/env bash

# If a menu already open, close it
if pgrep -f "wofi.*wofi-wifi" > /dev/null; then
    pkill -f "wofi.*wofi-wifi"
    exit 0
fi

# Trigger a fresh scan
nmcli device wifi rescan &>/dev/null

# Pick the icon for the signal strength
get_icon() {
    signal=$1

    if [ "$signal" -ge 80 ]; then
        echo "󰤨"
    elif [ "$signal" -ge 60 ]; then
        echo "󰤥"
    elif [ "$signal" -ge 40 ]; then
        echo "󰤢"
    elif [ "$signal" -ge 20 ]; then
        echo "󰤟"
    else
        echo "󰤯"
    fi
}

menu=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi list \
    | awk -F: '!seen[$1]++' \
    | while IFS=: read -r ssid security signal; do

        [ -z "$ssid" ] && continue

        icon=$(get_icon "$signal")

        if [ -n "$security" ]; then
            lock="󰌾"
        else
            lock=""
        fi

        printf "%s  %s  %s %s\n" "$icon" "$lock" "$ssid" 
    done \
    | wofi --dmenu \
           --style ~/.config/waybar/scripts/style.css \
           --prompt "Search Networks" \
           --width 270 \
           -x -15 \
           --height 400 \
           --location 3 \
           --gtk-dark \
           --name "wofi-wifi")

[ -z "$menu" ] && exit

# Extract SSID (strip icons + percentage)
ssid=$(echo "$menu" | awk '{for(i=3;i<=NF;i++) printf $i " "; print ""}' | sed 's/ $//')

nmcli device wifi connect "$ssid"

