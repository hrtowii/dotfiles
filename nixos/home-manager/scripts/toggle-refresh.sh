#!/usr/bin/env bash

MONITORS=$(hyprctl monitors -j)
MONITOR=$(echo "$MONITORS" | jq -r '.[] | select(.focused==true) | .name')
[ -z "$MONITOR" ] && {
  notify-send "Error" "No focused monitor"
  exit 1
}

HEIGHT_MM=$(echo "$MONITORS" | jq -r ".[] | select(.name == \"$MONITOR\") | .physicalHeight")
RES=$(echo "$MONITORS" | jq -r ".[] | select(.name == \"$MONITOR\") | \"\(.width)x\(.height)\"")
CURRENT=$(echo "$MONITORS" | jq -r ".[] | select(.name == \"$MONITOR\") | .refreshRate" | cut -d. -f1)

MAX=$(echo "$MONITORS" | jq -r \
  ".[] | select(.name == \"$MONITOR\") | .availableModes[]" |
  sed -E 's/.*@([0-9]+).*/\1/' |
  sort -nr | head -n1)

[ -z "$MAX" ] && {
  notify-send "Error" "No modes found"
  exit 1
}

SCALE=1.00
if [[ "$HEIGHT_MM" =~ ^[0-9]+$ ]] && [ "$HEIGHT_MM" -lt 300 ]; then
  SCALE=1.25
  notify-send "Monitor Scale" "$MONITOR → ${SCALE}x (${HEIGHT_MM} mm)"
fi

if [ "$CURRENT" = "$MAX" ]; then
  hyprctl keyword "monitor $MONITOR,${RES}@60,auto,${SCALE}"
  notify-send "Refresh" "$MONITOR → 60 Hz @ ${SCALE}"
else
  hyprctl keyword "monitor $MONITOR,${RES}@${MAX},auto,${SCALE}"
  notify-send "Refresh" "$MONITOR → ${MAX} Hz @ ${SCALE}"
fi
