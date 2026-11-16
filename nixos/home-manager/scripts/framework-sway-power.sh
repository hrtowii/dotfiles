#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

apply_power_mode() {
  local refresh=60000 supply online socket outputs command reply
  # Check external supplies rather than battery "Charging": a full battery
  # remains on AC, and USB-C supplies may appear under several names.
  for supply in /sys/class/power_supply/*; do
    [[ -r "$supply/online" ]] || continue
    [[ "$(cat "$supply/type")" == "Battery" ]] && continue
    online=$(cat "$supply/online")
    if [[ "$online" == 1 ]]; then
      refresh=120000
      break
    fi
  done

  # Discover sockets on each event, including after a compositor restart.
  for socket in "${XDG_RUNTIME_DIR:?}"/sway-ipc.*.sock; do
    outputs=$(swaymsg -s "$socket" -t get_outputs -r) || continue
    command=$(jq -r --argjson refresh "$refresh" '
      .[] | select(.name == "eDP-1" and .active and .power) |
      . as $output |
      [.modes[] | select(
        .width == $output.current_mode.width and
        .height == $output.current_mode.height and
        .refresh == $refresh
      )][0] as $mode |
      select($mode != null) |
      select(.current_mode.refresh != $refresh or .adaptive_sync_status != "enabled") |
      "output \(.name) mode \($mode.width)x\($mode.height)@\($mode.refresh / 1000)Hz adaptive_sync on"
    ' <<< "$outputs") || continue
    [[ -n "$command" ]] || continue
    if reply=$(swaymsg -s "$socket" -r "$command") &&
        jq -e 'all(.[]; .success)' <<< "$reply" >/dev/null; then
      echo "$command"
    else
      echo "Failed to apply: $command ($reply)" >&2
    fi
  done
}

apply_power_mode
# The initial monitor message also reconciles changes during subscription.
stdbuf -oL upower --monitor | while IFS= read -r _event; do
  apply_power_mode
done
