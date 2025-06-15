#!/bin/fish

set -l src (dirname (status filename))

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read line
    switch $line
        case 'monitor*'
            $src/gen-hyprlock.fish
    end
end
