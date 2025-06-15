#!/bin/fish

set -l src (dirname (status filename))

set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME/caelestia || set -l config $HOME/.config/caelestia

cp $src/templates/hyprlock/base.conf $src/../hyprlock.conf

test -f $config/hypr.json && set -l style (jq -r '.hyprlock.style' $config/hypr.json)
test -f "$src/templates/hyprlock/$style/main.conf" || set -l style round

cat $src/templates/hyprlock/$style/main.conf >> $src/../hyprlock.conf

if test -f $src/templates/hyprlock/$style/per-monitor.conf
    for monitor in (hyprctl monitors -j | jq -r '.[] | "\(.name) \(.width) \(.height)"')
        set -l monitor (string split ' ' $monitor)
        set -l name $monitor[1]
        set -l width $monitor[2]
        set -l height $monitor[3]

        set -l tmp (mktemp)
        cp $src/templates/hyprlock/$style/per-monitor.conf $tmp
        sed -n 's/.*{{ \(.*\) }}.*/\1/p' $src/templates/hyprlock/$style/per-monitor.conf | while read expr
            sed -i "s|{{ $expr }}|$(echo "echo $expr" | .)|g" $tmp
        end
        cat $tmp >> $src/../hyprlock.conf
    end
end
