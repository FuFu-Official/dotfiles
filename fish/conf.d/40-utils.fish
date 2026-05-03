function check_caps
    sleep 0.15
    set -l state (brightnessctl --device="*capslock" get)
    if test "$state" = 1
        notify-send -t 800 -u low "CAPS LOCK: ON"
    else
        notify-send -t 800 -u low "caps lock: off"
    end
end

function treesum
    set -l target (test -n "$argv[1]"; and echo "$argv[1]"; or echo ".")
    find $target -maxdepth 2 -type d | sort | while read -l dir
        set -l count (find "$dir" -maxdepth 1 -type f | wc -l)
        set -l total (find "$dir" -type f | wc -l)
        set -l indent (echo "$dir" | string split "/" | count)
        set -l spaces (string repeat -n (math $indent \* 2) " ")
        echo -e "$spaces\e[34m📂 $dir\e[0m \e[90m(Local: $count | Total: $total)\e[0m"
    end
end
