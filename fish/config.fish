if status is-interactive

    function on_matugen_signal --on-variable MATUGEN_RELOAD_SIGNAL
        fish_config theme choose fufu-matugen
        commandline -f repaint
    end

    thefuck --alias fk | source
    zoxide init fish | source
    alias cd z

    alias x clear

    # starship init fish | source
end
