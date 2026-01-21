if status is-interactive
    # Commands to run in interactive sessions can go here

    set -gx fish_key_bindings fish_vi_key_bindings

    function fish_user_key_bindings
        # bind jk to return to normal mode
        bind -M insert -m default jk backward-char force-repaint
    end

    function fish_mode_prompt; end

end

