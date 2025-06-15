#!/bin/fish

set -q XDG_CACHE_HOME && set -l cache $XDG_CACHE_HOME || set -l cache $HOME/.cache
set -l cache $cache/caelestia/weather.json

if test -f $cache
    jq -r '.current | "\(.condition.text) • \(.temp_c)°C | UV \(.uv) •  \(.wind_kph) kph"' $cache
    exit
end

set -l format '\(.weatherDesc[0].value) • \(.temp_C)°C | UV \(.uvIndex) •  \(.windspeedKmph) kph'
set -l city (curl ipinfo.io | jq -r '.city')
curl "wttr.in/$city?format=j1" | jq -er '.current_condition[0] | "'$format'"'
