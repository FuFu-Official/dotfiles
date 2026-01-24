#!/usr/bin/env fish

# This Script sets up a symbolic link from my dotfiles to a target location.

set source_dir $HOME/Dev/dotfiles/
set target_path $HOME/.config/

set ignore_list .git .gitignore .DS_Store README.md LICENSE

function process_source
    set -l source_name $argv[1]
    set -l source_path (realpath "$source_dir$source_name")
    set -l target_link "$target_path$source_name"

    # Make sure the target directory exists
    if not test -d (dirname "$target_link")
        mkdir -p (dirname "$target_link")
    end

    # Check if the symlink already exists
    if test -L "$target_link"
        # Check if it points to the correct source
        set -l current_target (readlink -f "$target_link")
        if test "$current_target" = "$source_path"
            echo "✅ [OK] $source_name is correctly linked."
            return
        else
            echo "⚠️ [Mismatch] $source_name links to $current_target, expected $source_path"
        end
    end

    if test -e "$target_link"
        if diff -rNq "$source_path" "$target_link" >/dev/null 2>&1
            echo "ℹ️ [Info] $source_name exists as physical file/dir but content is identical."
        end

        echo "🛑 [Conflict] $target_link exists."
        echo "   Do you want to backup and replace it? (y/n)"
        read -l backup_choice

        if test "$backup_choice" = y
            set -l backup_name "$target_link.bak."(date +%Y%m%d_%H%M%S)
            mv "$target_link" "$backup_name"
            echo "📦 [Backup] Moved to $backup_name"

            ln -s "$source_path" "$target_link"
            echo "🔗 [Linked] $target_link -> $source_path"
        else
            echo "⏭️ [Skip] Skipping $source_name"
        end
    else
        ln -s "$source_path" "$target_link"
        echo "✨ [New] Created symlink: $target_link"
    end
end

for full_path in $source_dir/*
    set -l filename (path basename "$full_path")

    if contains "$filename" $ignore_list
        continue
    end

    set -l default_sources nvim fish hypr fastfetch kitty mako walker waybar wlogout feishu-flags.conf mimeapps.list

    if contains "$filename" $default_sources
        process_source "$filename"
    else
        set -a missing_sources "$filename"
    end
end

if set -q missing_sources[1]
    echo -e "\n🔍 [Notice] The following files in dotfiles were NOT linked (not in allowed list):"
    for missing in $missing_sources
        echo " - $missing"
    end
end
