function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    # printf '%s@%s %s%s%s > ' $USER $hostname \
    #     (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

    echo

    set -l last_status $status
    if test $last_status -eq 0
        if test $OS = linux
            if test "$OS_ID" = "arch"
                set_color -o 168cc7
                echo -n ' '
            else
                set_color -o white 
                echo -n ' '
            end
        else
            set_color green
            echo -n '✔ '
        end
    else
        set_color red
        echo -n '✖ '
    end

    echo -n ' '

    set_color -i CAA5F8
    echo -n (prompt_pwd)

    set_color -o 86B1F8
    echo -n (fish_git_prompt)

    echo

    set_color normal
    echo -n '> '
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    # Use starship
    # starship init fish | source
    # if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    #     cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    # end
end

source $HOME/.config/fish/.scripts/auto-Hypr.fish

