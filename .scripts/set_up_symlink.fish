# This Script sets up a symbolic link from my dotfiles to a target location.

set source_dir $HOME/Dev/dotfiles/
set target_path $HOME/.config/

set -l all_sources (ls $source_dir)
set -l default_sources_dirs nvim fish hypr fastfetch kitty mako walker waybar wlogout
