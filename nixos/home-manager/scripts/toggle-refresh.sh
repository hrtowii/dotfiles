#!/usr/bin/env bash
MONITOR="eDP-2"
CURRENT=$(hyprctl monitors | grep -A 15 "$MONITOR" | grep "refresh rate" | awk '{print $3}')

if [ "$CURRENT" = "144.00" ]; then
    hyprctl keyword "monitor $MONITOR,1920x1200@60,0x0,1.5"
    notify-send "Refresh Rate" "Set to 60Hz (Battery Saver)"
else
    hyprctl keyword "monitor $MONITOR,1920x1200@144,0x0,1.5"
    notify-send "Refresh Rate" "Set to 144Hz (High Performance)"
fi
