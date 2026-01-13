function typewrite
    for arg in $argv
        for i in (seq (string length $arg))
            echo -n (string sub -s $i -l 1 $arg)
            sleep 0.01
        end
    end
    echo ""
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

        echo $today > $datefile
    end
end

