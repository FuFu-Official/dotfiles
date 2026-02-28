#!/usr/bin/env fish

set path_prefix $HOME/Dev/dotfiles/
set matugen_color_file_paths btop/themes/fufu-matugen.theme cava/themes/fufu-matugen gtk-3.0/colors.css \
    gtk-4.0/colors.css hypr/colors.conf kitty/themes/fufu-matugen.conf mako/mako-colors nvim/matugen.lua \
    opencode/themes/fufu-matugen.json qt5ct/colors/fufu-matugen.conf qt6ct/colors/fufu-matugen.conf \
    kitty/current-theme.conf rmpc/themes/fufu-matugen.ron yazi/theme.toml wlogout/colors.css \
    wlogout/.scripts/recolor-icons.sh wlogout/icons/*.png zathura/zathurarc obs-studio/themes/matugen.obt \
    AdwSteamGtk/custom.css fish/conf.d/50-fish-prompt.fish zen/chrome/colors.css waybar/colors.css

for file in $matugen_color_file_paths
    set full_path "$path_prefix$file"
    if test -e "$full_path"
        echo "Setting skip-worktree for $file"
        git update-index --skip-worktree "$full_path"
    else
        echo "[⁉️⁉️⁉️] Warning: File not found, skip processing $file"
    end
end
