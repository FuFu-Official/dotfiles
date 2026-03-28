alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

if type -q eza
    alias ls 'eza --icons'
    alias ll 'eza -l --icons --git'
    alias la 'eza -la --icons --git'
    alias lh 'eza -lah --icons --git'
    alias ld 'eza -l --icons --only-dirs'
    function lt
        eza --tree --level=$argv --icons
    end
    alias ltt 'eza --tree --level=2 --icons'
    alias lg 'eza -la --icons --git --git-ignore'
    alias lsize 'eza -lah --sort=size'
    alias ltime 'eza -lah --sort=modified'
else
    alias ll 'ls -lh'
    alias la 'ls -lah'
end

alias s sudo

# Editor
alias v nvim
alias vi nvim
alias V nvim

# Git
alias g git
alias ga "git add"
alias gcl "git clone"
alias gcm "git commit -m"
alias gst "git status"
alias gb "git branch"
alias gba "git branch -a"
alias gbd "git branch -D"
alias gcb "git checkout -b"
alias gph "git push"
alias gpl "git pull"

# Lazygit
alias gg lazygit

# Grep aliases
alias grep 'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'

# Long running command alert
function alert
    set -l exit_status $status

    set -l symbol "✅ [SUCCESS]"
    if test $exit_status -ne 0
        set symbol "❌ [FAILED ($exit_status)]"
    end

    notify-send --urgency=low "$symbol" "$history[1]"
end

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
    nohup $argv >/dev/null 2>&1 &
    disown
end

# Coding
alias CC gcc
set -g FF_CXX_FLAGS \
    -Wall -Wextra -Weffc++ \
    -Werror=uninitialized \
    -Werror=return-type \
    -Wconversion -Wsign-compare \
    -Werror=unused-result \
    -Werror=suggest-override \
    -Wzero-as-null-pointer-constant \
    -Wmissing-declarations \
    -Wold-style-cast -Werror=vla \
    -Wnon-virtual-dtor \
    -Wlogical-op -Wduplicated-cond -Wduplicated-branches -Wformat=2
alias CXX "g++ $FF_CXX_FLAGS"
alias py python
