function gf --description "Git add, commit and optionally push"

    # Default values
    set paths
    set message ""
    set force false

    function show_help
        echo "Usage: gf -m \"commit message\" [-p path1 path2 ...] [-f]"
        echo
        echo "Options:"
        echo "  -m MESSAGE    Commit message (required)"
        echo "  -p PATHS      Paths to add (can specify multiple, default: current directory)"
        echo "  -f            Force push without confirmation"
        echo "  -h            Show this help"
        echo
        echo "Examples:"
        echo "  gf -m \"Add new feature\""
        echo "  gf -p src/ docs/ -m \"Fix bug\""
        echo "  gf -f -m \"Update docs\" -p README.md src/main.js"
    end

    # Argument parsing
    set argv_copy $argv
    while test (count $argv_copy) -gt 0
        set arg $argv_copy[1]

        switch $arg
            case -m --message
                if test (count $argv_copy) -ge 2
                    set message $argv_copy[2]
                    set argv_copy $argv_copy[3..-1]
                else
                    echo "Error: Option $arg requires an argument." >&2
                    return 1
                end

            case -p --path
                set argv_copy $argv_copy[2..-1]
                while test (count $argv_copy) -gt 0
                    if string match -qr '^-' -- $argv_copy[1]
                        break
                    end
                    set paths $paths $argv_copy[1]
                    set argv_copy $argv_copy[2..-1]
                end

            case -f --force
                set force true
                set argv_copy $argv_copy[2..-1]

            case -h --help
                show_help
                return 0

            case '*'
                echo "Invalid option: $arg" >&2
                show_help
                return 1
        end
    end

    # Default path
    if test (count $paths) -eq 0
        set paths "."
    end

    # Validation
    if test -z "$message"
        echo "Error: commit message is required (-m)" >&2
        show_help
        return 1
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository" >&2
        return 1
    end

    for path in $paths
        if not test -e $path
            echo "Error: Path '$path' does not exist" >&2
            return 1
        end
    end

    # Status
    set remote (git remote get-url origin 2>/dev/null; or echo "No remote")
    echo "Repository: $remote"
    echo "Branch: "(git branch --show-current)
    echo "Paths: $paths"
    echo "Message: $message"
    echo

    # Git add
    echo "Adding files..."
    for path in $paths
        echo "  Adding: $path"
        git add $path; or begin
            echo "Error: Failed to add '$path'" >&2
            return 1
        end
    end

    # Commit
    echo "Committing..."
    git commit -m "$message"; or begin
        echo "Error: Failed to commit" >&2
        return 1
    end

    # Push confirmation
    if test "$force" = false
        read -P "Push to remote? (y/N): " reply
        if not string match -iq 'y' -- $reply
            echo "Commit created but not pushed"
            return 0
        end
    end

    # Push
    echo "Pushing..."
    git push; or begin
        echo "Error: Failed to push" >&2
        return 1
    end

    echo "✅ Successfully committed and pushed!"
end

# Git flow
alias gfm "gf -m"
