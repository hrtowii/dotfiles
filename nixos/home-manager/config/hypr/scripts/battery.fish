#!/bin/fish

for battery in /sys/class/power_supply/*BAT*
    if test -f "$battery/uevent"
        set has_battery
        break
    end
end

if set -q has_battery
    if test "$(cat /sys/class/power_supply/*/status | head -1)" = "Charging"
        echo -n "(+) "
    end
    echo "$(cat /sys/class/power_supply/*/capacity | head -1)% remaining"
else
    exit 1
end
