# Arch Linux specific aliases
if test "$OS_ID" = arch

    set -gx HYPRSHOT_DIR $HOME/Pictures/Screenshots

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

   function change_wallpaper --description "Update hyprpaper.conf and restart"
        if test (count $argv) -eq 0
            echo "Usage: change_wallpaper <path_to_image>"
            return 1
        end

        set -l wall_path (realpath $argv[1])
        if not test -e "$wall_path"
            echo "Error: Path not found: $wall_path"
            return 1
        end

        set -l config_file "$HOME/.config/hypr/hyprpaper.conf"

        sed -i "/monitor =/,/}/ s|path = .*|path = $wall_path|" "$config_file"

        killall hyprpaper; or true
        sleep 0.2
        nh hyprpaper

        echo "Hyprpaper config updated and hyprpaper restarted with: $wall_path"
    end
end
