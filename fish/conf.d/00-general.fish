set -gx EDITOR nvim
set -gx nvm_default_version lts

# Set Proxy for GO Dependency
set -Ux GOPROXY https://goproxy.cn,direct

function proxy_on
    set -gx http_proxy http://127.0.0.1:12334
    set -gx https_proxy http://127.0.0.1:12334
    set -gx all_proxy socks5://127.0.0.1:12334
    # Ignore no_proxy address
    set -gx no_proxy localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12
    echo "Proxy enabled."
end

function proxy_off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
    set -e no_proxy
    echo "Proxy disabled."
end

if test -r /etc/os-release
    set -g OS linux
    set -g OS_ID ( grep '^ID=' /etc/os-release | cut -d= -f2 )
else
    set -g OS windows
    set -g OS_ID windows
end

function fish_prompt -d "Write out the prompt"
    echo

    set -l last_status $status

    if test $last_status -eq 0
        if test $OS = linux
            if test "$OS_ID" = arch
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

    echo -n ' '

    switch $fish_bind_mode
        case default
            set_color 88b3fb
            echo -n "[N]"
        case insert
            set_color acd8a6
            echo -n "[I]"
        case visual
            set_color caa8ed
            echo -n "[V]"
        case replace_one
            set_color d08770
            echo -n "[R]"
    end

    echo

    set_color normal
    echo -n '> '
end
