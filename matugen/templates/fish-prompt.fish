# Load matugen generated theme
fish_config theme choose fufu-matugen

# --- Custom Prompt Colors ---
set -U my_p_icon_logo {{colors.primary.default.hex_stripped}}
set -U my_p_icon_logo_error {{colors.error.default.hex_stripped}}
set -U my_p_cwd {{colors.secondary.default.hex_stripped}}
set -U my_p_git {{colors.tertiary.default.hex_stripped}}
set -U my_p_mode_default {{colors.inverse_primary.default.hex_stripped}}
set -U my_p_mode_insert {{colors.primary.default.hex_stripped}}
set -U my_p_mode_visual {{colors.tertiary.default.hex_stripped}}
set -U my_p_mode_replace {{colors.error.default.hex_stripped}}

function fish_prompt -d "Write out the prompt"
    set -l last_status $status

    echo

    if test $last_status -eq 0
        set_color -o $my_p_icon_logo
        if test "$OS" = linux
            if test "$OS_ID" = arch
                echo -n ' '
            else
                echo -n ' '
            end
        else
            echo -n '✔ '
        end
    else
        set_color $my_p_icon_logo_error
        if test $last_status -eq 127
            echo -n ' ' # command not found
        else if test $last_status -eq 130
            echo -n '󱈸 ' # Ctrl+C
        else
            echo -n '󰚌 '
        end
    end

    echo -n ' '

    set_color -i $my_p_cwd
    echo -n (prompt_pwd)

    set_color -o $my_p_git
    echo -n (fish_git_prompt)

    echo -n ' '

    switch $fish_bind_mode
        case default
            set_color $my_p_mode_default
            echo -n "[N]"
        case insert
            set_color $my_p_mode_insert
            echo -n "[I]"
        case visual
            set_color $my_p_mode_visual
            echo -n "[V]"
        case replace_one
            set_color $my_p_mode_replace
            echo -n "[R]"
    end

    echo

    set_color normal
    echo -n '> '
end
