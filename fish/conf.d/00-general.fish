set -gx EDITOR nvim

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



