if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx fish_key_bindings fish_vi_key_bindings

    function fish_user_key_bindings
        # bind jk to return to normal mode
        bind -M insert -m default jk backward-char force-repaint

        bind -M visual -m default q end-selection force-repaint
    end

    function fish_mode_prompt
    end

    bind -M insert ctrl-y accept-autosuggestion
    bind -M insert ctrl-alt-y forward-word
end

function conda_activate
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if test -f /opt/miniforge/bin/conda
        eval /opt/miniforge/bin/conda "shell.fish" hook $argv | source
    else
        if test -f "/opt/miniforge/etc/fish/conf.d/conda.fish"
            "/opt/miniforge/etc/fish/conf.d/conda.fish"
        else
            set -x PATH /opt/miniforge/bin $PATH
        end
    end
    # <<< conda initialize <<<
end

function conda_deactivate
    if type -q conda
        set -e CONDA_EXE
        set -e CONDA_PREFIX
        set -e CONDA_PYTHON_EXE
        echo "Conda Deactivate. "
    else
        echo "Conda is not activated. "
    end
end
