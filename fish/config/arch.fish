# Pacman
alias sps "sudo pacman -S"
alias spu "sudo pacman -Syu"
alias spr "sudo pacman -Rns"

# AUR
if type -q paru
    alias sga "sudo paru -Syu"
    alias sgi "sudo paru -S"
    alias sgr "sudo paru -Rns"
else if type -q yay
    alias sga "sudo yay -Syu"
    alias sgi "sudo yay -S"
    alias sgr "sudo yay -Rns"
else
    echo "No AUR helper found (paru or yay)"
end



