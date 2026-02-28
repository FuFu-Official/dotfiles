if status is-interactive

    function on_matugen_signal --on-variable MATUGEN_RELOAD_SIGNAL
        fish_config theme choose fufu-matugen
        commandline -f repaint
    end

end
