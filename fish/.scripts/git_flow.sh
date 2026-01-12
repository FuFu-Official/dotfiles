#!/usr/bin/env bash

set -euo pipefail

# Default values
paths=()
message=""
force=false

show_help() {
    cat << EOF
Usage: $0 -m "commit message" [-p path1 path2 ...] [-f]

Options:
    -m MESSAGE    Commit message (required)
    -p PATHS      Paths to add (can specify multiple, default: current directory)
    -f            Force push without confirmation
    -h            Show this help

Examples:
    $0 -m "Add new feature"
    $0 -p src/ docs/ -m "Fix bug"
    $0 -f -m "Update docs" -p README.md src/main.js
EOF
}

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--message)
            if [[ -n "${2:-}" ]]; then
                message="$2"
                shift 2
            else
                echo "Error: Option $1 requires an argument." >&2
                exit 1
            fi
            ;;
        -p|--path)
            shift
            # Collect all paths until next option or end
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                paths+=("$1")
                shift
            done
            ;;
        -f|--force)
            force=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Invalid option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

# Set default path if none specified
if [[ ${#paths[@]} -eq 0 ]]; then
    paths=(".")
fi

# Validation
if [[ -z "$message" ]]; then
    echo "Error: commit message is required (-m)" >&2
    show_help
    exit 1
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository" >&2
    exit 1
fi

# Check if all paths exist
for path in "${paths[@]}"; do
    if [[ ! -e "$path" ]]; then
        echo "Error: Path '$path' does not exist" >&2
        exit 1
    fi
done

# Show status
echo "Repository: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
echo "Branch: $(git branch --show-current)"
echo "Paths: ${paths[*]}"
echo "Message: $message"
echo

# Git operations with error handling
echo "Adding files..."
for path in "${paths[@]}"; do
    echo "  Adding: $path"
    if ! git add "$path"; then
        echo "Error: Failed to add '$path'" >&2
        exit 1
    fi
done

echo "Committing..."
if ! git commit -m "$message"; then
    echo "Error: Failed to commit" >&2
    exit 1
fi

# Confirmation for push (unless forced)
if [[ "$force" = false ]]; then
    read -p "Push to remote? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Commit created but not pushed"
        exit 0
    fi
fi

echo "Pushing..."
if ! git push; then
    echo "Error: Failed to push" >&2
    exit 1
fi

echo "✅ Successfully committed and pushed!"
