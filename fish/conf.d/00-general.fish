set -gx EDITOR nvim
set -gx HYPRSHOT_DIR $HOME/Pictures/Screenshots

# Set Proxy for GO Dependency
set -Ux GOPROXY https://goproxy.cn,direct

set -gx http_proxy http://127.0.0.1:12334
set -gx https_proxy http://127.0.0.1:12334
set -gx all_proxy socks5://127.0.0.1:12334

if test -r /etc/os-release
    set -g OS linux
    set -g OS_ID ( grep '^ID=' /etc/os-release | cut -d= -f2 )
else
    set -g OS windows
    set -g OS_ID windows
end



