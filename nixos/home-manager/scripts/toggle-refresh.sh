#!/usr/bin/env bash
MONITOR="eDP-2"
CURRENT=$(hyprctl monitors | grep "$MONITOR" -A 1 | grep "@" | grep -oP '\d+(?=\.' | head -1)

if [ "$CURRENT" = "144" ]; then
    hyprctl keyword "monitor $MONITOR,1920x1200@60,0x0,1.5"
    notify-send "Refresh Rate" "Set to 60Hz (Battery Saver)"
else
    hyprctl keyword "monitor $MONITOR,1920x1200@144,0x0,1.5"
    notify-send "Refresh Rate" "Set to 144Hz (High Performance)"
fi
