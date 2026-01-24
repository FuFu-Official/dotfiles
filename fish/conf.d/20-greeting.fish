function typewrite
    for arg in $argv
        for i in (seq (string length $arg))
            echo -n (string sub -s $i -l 1 $arg)
            sleep 0.01
        end
    end
    echo ""
end

function chafa_smart_clamp --argument picture max_width
    # Get width data
    set -l width (identify -format "%w" "$picture" 2>/dev/null)
    
    if test -z "$width"
        echo "Error: Cannot read image file."
        return 1
    end

    # Cal scale
    set -l scale 1.0
    if test $width -gt $max_width
        set scale (math -s 3 "$max_width / $width")
    end

    chafa --fill=block --symbols=block --scale=$scale "$picture"
end

function gen_random_pictures
    set -l primary_dirs $HOME/Pictures/Hiten $HOME/Pictures/竹嶋えく
    set -l fallback_dirs $HOME/Pictures/Wallpapers

    set -l image_dirs

    for d in $primary_dirs
        test -d $d; and set image_dirs $image_dirs $d
    end

    if test (count $image_dirs) -eq 0
        for d in $fallback_dirs
            test -d $d; and set image_dirs $image_dirs $d
        end
    end

    test (count $image_dirs) -eq 0; and return

    set -l picture (
        find $image_dirs -type f \
            \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) \
            2>/dev/null | shuf -n 1
    )

    test -n "$picture"; or return

    if set -q KITTY_WINDOW_ID
        chafa_smart_clamp "$picture" 650
    end
end

function fish_greeting
    if set -q XDG_CACHE_HOME
        set cachedir $XDG_CACHE_HOME/fish
    else
        set cachedir $HOME/.cache/fish
    end

    set datefile $cachedir/fish_greeting_date
    set today (date '+%Y-%m-%d')

    mkdir -p $cachedir

    if test -f $datefile
        set lastdate (cat $datefile)
    else
        set lastdate ""
    end

    if test "$lastdate" != "$today"
        typewrite ""
        typewrite " Hello, $USER!"
        typewrite " Welcome back! Today is "(date '+%A, %B %d, %Y')"."
        typewrite " The current time is "(date '+%H:%M:%S')"."
        typewrite " Study hard, Play hard!"
        typewrite ""

        gen_random_pictures

        echo $today > $datefile
    end
end

