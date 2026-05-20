#!/usr/bin/env fish

set script_dir (path dirname (status filename))
set src_dir (path resolve "$script_dir/..")
set dest_dir (path resolve "$HOME/Dev/nvim")
set override_dir "$src_dir/.stable/overrides"

argparse h/help f/force b/backup n/dry-run d/dest= -- $argv
or return

if set -q _flag_help
    echo "Usage: update_stable.fish [--dry-run] [--force | --backup] [--dest PATH]"
    echo
    echo "Sync the current config into a portable stable config."
    return 0
end

if set -q _flag_dest
    set dest_dir (path resolve "$_flag_dest")
end

set -g stable_force 0
set -g stable_backup 0
set -g stable_dry_run 0

if set -q _flag_force
    set stable_force 1
end

if set -q _flag_backup
    set stable_backup 1
end

if set -q _flag_dry_run
    set stable_dry_run 1
end

set root_targets LICENSE lazy-lock.json lazyvim.json stylua.toml .gitignore .neoconf.json
set override_targets init.lua lua/plugins/ui.lua
set managed_targets $root_targets dots
set cleanup_targets AGENTS.md .scripts lua/matugen lua/utils lua/plugins/mason.lua
set missing_sources

function log_cmd -a message
    echo -e "$message"
end

function ensure_parent_dir -a target_path
    set -l target_dir (path dirname "$target_path")

    if test -d "$target_dir"
        return 0
    end

    if test $stable_dry_run -eq 1
        log_cmd "📁 \e[90m[DRY RUN]\e[0m mkdir -p $target_dir"
        return 0
    end

    mkdir -p "$target_dir"
end

function paths_identical -a source_path target_path
    if test -f "$source_path"; and test -f "$target_path"
        cmp -s "$source_path" "$target_path"
        return $status
    end

    if test -d "$source_path"; and test -d "$target_path"
        diff -qr "$source_path" "$target_path" >/dev/null 2>&1
        return $status
    end

    return 1
end

function copy_path -a source_path target_path
    if test $stable_dry_run -eq 1
        log_cmd "📄 \e[90m[DRY RUN]\e[0m cp -a $source_path $target_path"
        return 0
    end

    if cp -a "$source_path" "$target_path"
        log_cmd "📄 \e[32mCopied\e[0m: $source_path -> $target_path"
        return 0
    end

    log_cmd "❌ \e[31mFailed to copy\e[0m: $source_path -> $target_path"
    return 1
end

function remove_path -a target_path
    if not test -e "$target_path"
        return 0
    end

    if test $stable_dry_run -eq 1
        log_cmd "🧹 \e[90m[DRY RUN]\e[0m rm -rf $target_path"
        return 0
    end

    rm -rf "$target_path"
    log_cmd "🧹 \e[33mRemoved\e[0m: $target_path"
end

function sync_path -a source_path target_path display_path
    ensure_parent_dir "$target_path"; or return 1

    if not test -e "$source_path"
        set -a missing_sources "$display_path"
        log_cmd "⚠️  \e[33mMissing source\e[0m: $display_path"
        return 0
    end

    if test -e "$target_path"
        if paths_identical "$source_path" "$target_path"
            log_cmd "✅ \e[90mSkipping (Already identical)\e[0m: $display_path"
            return 0
        end

        log_cmd "🛑 \e[31mConflict\e[0m: $display_path exists and differs."

        set -l action ""

        if test $stable_force -eq 1
            set action o
        else if test $stable_backup -eq 1
            set action b
        else
            set -l prompt_text (echo -e "   Choose: [\e[1mb\e[0m]ackup, [\e[1mo\e[0m]verwrite, [\e[1ms\e[0m]kip? (b/o/s) ")
            read -l -P "$prompt_text" input
            set action (string lower "$input")[1]
        end

        switch "$action"
            case b backup
                set -l backup_name "$target_path.bak."(date +%Y%m%d_%H%M%S)
                if test $stable_dry_run -eq 0
                    mv "$target_path" "$backup_name"
                end
                log_cmd "📦 \e[34mBacked up\e[0m to $backup_name"
            case o overwrite
                remove_path "$target_path"; or return 1
            case '*'
                log_cmd "⏭️  \e[90mSkipped\e[0m: $display_path"
                return 0
        end
    end

    copy_path "$source_path" "$target_path"
end

function sync_relative_path -a rel_path
    sync_path "$src_dir/$rel_path" "$dest_dir/$rel_path" "$rel_path"
end

function sync_override_path -a rel_path
    sync_path "$override_dir/$rel_path" "$dest_dir/$rel_path" "$rel_path"
end

function collect_direct_children -a rel_dir
    if not test -d "$src_dir/$rel_dir"
        return 0
    end

    for entry in $src_dir/$rel_dir/*
        if test -e "$entry"
            set -l rel_path (string replace "$src_dir/" "" "$entry")
            if contains "$rel_path" $override_targets
                continue
            end
            if contains "$rel_path" $cleanup_targets
                continue
            end
            set -a managed_targets "$rel_path"
        end
    end
end

collect_direct_children lua/config
collect_direct_children lua/plugins
collect_direct_children lsp

echo -e "\n🚀 \e[1;36mUpdating stable Neovim config...\e[0m"
echo "   source: $src_dir"
echo "   target: $dest_dir"

if test $stable_dry_run -eq 1
    echo -e "🚧 \e[1;33mDRY RUN MODE ENABLED\e[0m - No files will be modified\n"
end

for rel_path in $managed_targets
    sync_relative_path "$rel_path"; or return 1
end

for cleanup_path in $cleanup_targets
    remove_path "$dest_dir/$cleanup_path"; or return 1
end

for override_path in $override_targets
    sync_override_path "$override_path"; or return 1
end

if test (count $missing_sources) -gt 0
    echo -e "\n🔍 \e[33mMissing managed sources:\e[0m"
    for missing in $missing_sources
        echo " - $missing"
    end
end

echo -e "\n🎉 \e[1;32mDone!\e[0m"
