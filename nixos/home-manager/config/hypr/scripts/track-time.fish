#!/bin/fish

function fmt-time -a secs
    printf "%d:%02d" (math -s 0 $secs / 60 % 60) (math -s 0 $secs % 60)
end

set -l position (caelestia shell mpris getActive position)
set -l length (caelestia shell mpris getActive length)

test $position != 'No media' && echo "$(fmt-time $position)/$(fmt-time $length)"
