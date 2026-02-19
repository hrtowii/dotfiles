#!/usr/bin/env bash

MONITORS=$(hyprctl monitors -j)

MONITOR=$(echo "$MONITORS" | jq -r '.[] | select(.focused==true) | .name')
[ -z "$MONITOR" ] && exit 1

RES=$(echo "$MONITORS" | jq -r \
  ".[] | select(.name==\"$MONITOR\") | \"\(.width)x\(.height)\"")

CURRENT=$(echo "$MONITORS" | jq -r \
  ".[] | select(.name==\"$MONITOR\") | .refreshRate" | cut -d. -f1)

MAX=$(echo "$MONITORS" | jq -r \
  ".[] | select(.name==\"$MONITOR\") | .availableModes[]" |
  sed -E 's/.*@([0-9]+).*/\1/' |
  sort -nr | head -n1)

[ -z "$MAX" ] && exit 1

if [ "$CURRENT" = "$MAX" ]; then
  hyprctl keyword "monitor $MONITOR,${RES}@60,auto,1.25"
  notify-send "Refresh Rate" "$MONITOR → 60Hz"
else
  hyprctl keyword "monitor $MONITOR,${RES}@${MAX},auto,1.25"
  notify-send "Refresh Rate" "$MONITOR → ${MAX}Hz"
fi
