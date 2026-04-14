#!/usr/bin/env fish

set src_dir (path resolve $HOME/Dev/dotfiles/nvim)
set dest_dir (path resolve $HOME/Dev/nvim)
set ignore_lists lua/plugins/ui.lua lua/plugins/mason.lua lua/config/screenlocker.lua

argparse f/force b/backup n/dry-run -- $argv
or return

set targets init.lua LICENSE lazy-lock.json lazyvim.json stylua.toml dots

if test -d "$src_dir/lua/config"
    for f in $src_dir/lua/config/*
        set -l rel_path (string replace "$src_dir/" "" "$f")
        if not contains "$rel_path" $ignore_lists
            set -a targets "$rel_path"
        end
    end
end

if test -d "$src_dir/lua/plugins"
    for f in $src_dir/lua/plugins/*
        set -l rel_path (string replace "$src_dir/" "" "$f")
        if not contains "$rel_path" $ignore_lists
            set -a targets "$rel_path"
        end
    end
end

function copy_source -a src dest
    if set -q _flag_dry_run
        echo -e "⏭️  \e[90m[DRY RUN]\e[0m cp -a $src $dest"
        return
    end

    if cp -a "$src" "$dest"
        echo -e "📄 \e[32mCopied\e[0m: $src -> $dest"
    else
        echo -e "❌ \e[31mFailed to copy\e[0m: $src -> $dest"
        return 1
    end
end

function process_source -a rel_path
    set -l source_path "$src_dir/$rel_path"
    set -l target_path "$dest_dir/$rel_path"
    set -l target_dir (path dirname "$target_path")

    if not test -d "$target_dir"
        if not set -q _flag_dry_run
            mkdir -p "$target_dir"
        else
            echo -e "📁 \e[90m[DRY RUN]\e[0m mkdir -p $target_dir"
        end
    end

    if test -e "$target_path"
        set -l identical 1
        if test -f "$source_path"; and test -f "$target_path"
            if cmp -s "$source_path" "$target_path"
                set identical 0
            end
        else if test -d "$source_path"; and test -d "$target_path"
            if diff -qr "$source_path" "$target_path" >/dev/null 2>&1
                set identical 0
            end
        end

        if test $identical -eq 0
            echo -e "✅ \e[90mSkipping (Already identical)\e[0m: $rel_path"
            return
        end

        echo -e "🛑 \e[31mConflict\e[0m: $rel_path exists and differs."

        set -l action ""

        if set -q _flag_force
            set action o
        else if set -q _flag_backup
            set action b
        else
            set -l prompt_text (echo -e "   Choose: [\e[1mb\e[0m]ackup, [\e[1mo\e[0m]verwrite, [\e[1ms\e[0m]kip? (b/o/s) ")
            read -l -P "$prompt_text" input

            set action (string lower "$input")[1]
        end

        switch "$action"
            case b backup
                set -l backup_name "$target_path.bak."(date +%Y%m%d_%H%M%S)
                if not set -q _flag_dry_run
                    mv "$target_path" "$backup_name"
                end
                echo -e "📦 \e[34mBacked up\e[0m to "(path basename "$backup_name")
                copy_source "$source_path" "$target_path"
            case o overwrite
                if not set -q _flag_dry_run
                    rm -rf "$target_path"
                end
                echo -e "🔥 \e[31mOverwrote\e[0m existing file/dir."
                copy_source "$source_path" "$target_path"
            case '*'
                echo -e "⏭️  \e[90mSkipped\e[0m: $rel_path"
        end
    else
        copy_source "$source_path" "$target_path"
    end
end

echo -e "\n🚀 \e[1;36mStarting dotfiles setup...\e[0m"
if set -q _flag_dry_run
    echo -e "🚧 \e[1;33mDRY RUN MODE ENABLED\e[0m - No files will be modified\n"
end

for target in $targets
    process_source "$target"
end

set -l missing_sources
for full_path in $src_dir/*
    if test -f "$full_path"
        set -l filename (path basename "$full_path")
        if not contains "$filename" $targets
            set -a missing_sources "$filename"
        end
    end
end

if test (count $missing_sources) -gt 0
    echo -e "\n🔍 \e[33mUnmanaged root files in dotfiles repo:\e[0m"
    for missing in $missing_sources
        echo " - $missing"
    end
end

echo -e "\n🎉 \e[1;32mDone!\e[0m"
