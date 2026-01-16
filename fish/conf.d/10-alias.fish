alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

alias la "ls -Gla"
alias ld 'ls -l | grep "^d"'
alias ll 'ls -ahlF'
if type -q exa
    alias l exa
    alias la 'exa --long --all --group --header --binary --links --inode --blocks'
    alias ld 'exa --long --all --group --header --list-dirs'
    alias ll 'exa --long --all --group --header --git'
    alias lt='exa --long --all --group --header --tree --level'
end

if type -q bat
    alias cat 'bat --paging=never'
end

alias s sudo

# Editor
alias v nvim
alias vi nvim
alias V nvim

# Git
alias g git
alias ga "git add"
alias gst "git status"
alias gb "git branch"
alias gba "git branch -a"
alias gbd "git branch -D"
alias gcb "git checkout -b"
alias gph "git push"
alias gpl "git pull"

# Grep aliases
alias grep 'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'

# Long running command alert
alias alert 'notify-send --urgency=low -i "$([ $status = 0 ] && echo terminal || echo error)" (history | tail -n 1 | sed "s/^[0-9]* //")'

# Ls hyperlinks
if type -q eza
    alias ls 'eza --icons --hyperlink'
else
    alias ls 'ls --hyperlink --color=auto'
end
alias rg 'rg --hyperlink-format=kitty'

# Time
alias d "date '+%Y-%m-%d %H:%M:%S'"

# Execute command in background without hangup
function nh
    nohup $argv > /dev/null 2>&1 &
    disown
end

