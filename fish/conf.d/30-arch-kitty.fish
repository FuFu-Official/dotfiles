# Arch Linux specific aliases
if test "$OS_ID" = arch

    set -gx HYPRSHOT_DIR $HOME/Pictures/Screenshots

    # Pacman
    alias sps "sudo pacman -S"
    alias spu "sudo pacman -Syu"
    alias spr "sudo pacman -Rns"

    # AUR
    if type -q paru
        alias gu "paru -Syu"
        alias gs "paru -S"
        alias gr "paru -Rns"
    else if type -q yay
        alias gu "yay -Syu"
        alias gs "yay -S"
        alias gr "yay -Rns"
    else
        echo "No AUR helper found (paru or yay)"
    end

    function switch_waybar --description "Switch waybar style via symlink"
        set -l waybar_dir "$HOME/.config/waybar"

        # List available styles (subdirectories with config.jsonc)
        set -l styles
        for d in $waybar_dir/*/
            set -l name (basename $d)
            if test -f "$d/config.jsonc"
                set -a styles $name
            end
        end

        if test (count $styles) -eq 0
            echo "No waybar styles found in $waybar_dir"
            return 1
        end

        # Determine target style
        if test (count $argv) -ge 1
            set -l target $argv[1]
            if not contains $target $styles
                echo "Unknown style: $target"
                echo "Available: $styles"
                return 1
            end
        else
            # No argument: show current and list options
            set -l current ""
            if test -L "$waybar_dir/config.jsonc"
                # e.g. pill-top/config.jsonc -> extract folder name
                set current (string split / (readlink "$waybar_dir/config.jsonc"))[1]
            end
            echo "Current: $current"
            echo "Available:"
            for s in $styles
                if test "$s" = "$current"
                    echo "  * $s"
                else
                    echo "    $s"
                end
            end
            return 0
        end

        set -l target $argv[1]

        # Create/update symlinks in waybar root
        ln -sf $target/config.jsonc $waybar_dir/config.jsonc
        ln -sf $target/style.css $waybar_dir/style.css

        # Restart waybar
        pkill -i waybar; or true
        sleep 0.3
        waybar &>/dev/null &
        disown

        echo "Switched waybar to: $target"
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

# Kitty specific settings
if test "$TERM" = xterm-kitty
    function ssh --description "Aliasing ssh to kitty kitten for terminfo support"
        kitty +kitten ssh $argv
    end
end
