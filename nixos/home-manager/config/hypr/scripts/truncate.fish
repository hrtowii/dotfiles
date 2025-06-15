#!/bin/fish

function get-width -a font size string
    magick -font $font -font Noto-Sans-CJK-JP -font Noto-Sans-CJK-SC -font Noto-Sans-CJK-TC -font Noto-Sans-CJK-KR -font Noto-Sans-CJK-HK -font Noto-Sans-CJK-TC \
        -pointsize $size label:$string -format '%w' info:
end

set -l font $argv[1]
set -l size $argv[2]
set -l max_width $argv[3]
set -l string $argv[4]
set -l dot_width (get-width $font $size '...')

if test (get-width $font $size $string) -gt $max_width
    # Cut in half until less than max width
    set -l st 0
    set -l ed (string length $string)
    while ! set -q done
        set -l idx (math -s 0 $st + \( $ed - $st \) / 2)
        set -l width (math (get-width $font $size (string sub -e $idx $string)) + $dot_width)
        if test $width -gt $max_width
            set ed $idx
        else
            if test (math abs $st - $ed) -le 1
                set done
                set string (string sub -e $idx $string)
            else
                set st $idx
            end
        end
    end
    echo "$(string trim -r $string)..."
else
    echo $string
end
