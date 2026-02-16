#!/usr/bin/env fish

# This script sets up symbolic links for configuration files from a dotfiles repository
# -f/--force: The existing file is directly overwritten
# -b/--backup: The existing file is backed up with a timestamp before linking
# -n/--dry-run: Simulates the actions without making any changes

set source_dir $HOME/Dev/dotfiles/
set target_path $HOME/.config/
set default_sources nvim fish hypr fastfetch kitty mako walker waybar wlogout feishu-flags.conf mimeapps.list zathura imv bat mpv
set ignore_list .git .gitignore .DS_Store README.md LICENSE

argparse f/force b/backup n/dry-run -- $argv
or return

function link_file
    set -l src $argv[1]
    set -l dest $argv[2]

    if set -q _flag_dry_run
        echo "Example: ln -s $src $dest"
        return
    end

    ln -s "$src" "$dest"
    echo -e "🔗 \e[32mLinked\e[0m: $dest -> $src"
end

function process_source
    set -l source_name $argv[1]
    set -l source_path (realpath "$source_dir$source_name")
    set -l target_link "$target_path$source_name"

    if not test -d (dirname "$target_link")
        if not set -q _flag_dry_run
            mkdir -p (dirname "$target_link")
        end
    end

    if test -L "$target_link"
        set -l current_target (readlink -f "$target_link")
        if test "$current_target" = "$source_path"
            echo -e "✅ \e[90mSkipping (Already linked)\e[0m: $source_name"
            return
        else
            echo -e "⚠️ \e[33mMismatch\e[0m: Symlink points to $current_target"
        end
    end

    if test -e "$target_link"

        if diff -rNq "$source_path" "$target_link" >/dev/null 2>&1
            if not set -q _flag_dry_run
                rm -rf "$target_link"
            end
            echo -e "♻️  \e[32mReplaced identical file\e[0m: $source_name"
            link_file "$source_path" "$target_link"
        else
            echo -e "🛑 \e[31mConflict\e[0m: $source_name exists and content differs."

            set -l action ""

            if set -q _flag_force
                set action o
            else if set -q _flag_backup
                set action b
            else
                echo -ne "   Choose: [b]ackup & link, [o]verwrite & link, [s]kip? (b/o/s) "
                read action
            end

            switch $action
                case b backup
                    set -l backup_name "$target_link.bak."(date +%Y%m%d_%H%M%S)
                    if not set -q _flag_dry_run
                        mv "$target_link" "$backup_name"
                    end
                    echo -e "📦 \e[34mBacked up\e[0m to $backup_name"
                    link_file "$source_path" "$target_link"
                case o overwrite
                    if not set -q _flag_dry_run
                        rm -rf "$target_link"
                    end
                    echo -e "🔥 \e[31mOverwrote\e[0m existing file."
                    link_file "$source_path" "$target_link"
                case '*'
                    echo -e "⏭️  \e[90mSkipped\e[0m: $source_name"
            end
        end
    else
        link_file "$source_path" "$target_link"
    end
end

echo "Starting dotfiles setup..."
if set -q _flag_dry_run
    echo "🚧 DRY RUN MODE"
end

for full_path in $source_dir/*
    set -l filename (path basename "$full_path")

    if contains "$filename" $ignore_list
        continue
    end

    if contains "$filename" $default_sources
        process_source "$filename"
    else
        set -a missing_sources "$filename"
    end
end

if set -q missing_sources[1]
    echo -e "\n🔍 Unmanaged files in dotfiles repo:"
    for missing in $missing_sources
        echo " - $missing"
    end
end
