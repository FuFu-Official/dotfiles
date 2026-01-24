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

function rm_compile_commands
    rm compile_commands.json

    ln -s build/compile_commands.json .

    sed -i 's|/home/radar/workspace/rm.cv.radar2026|/home/fufu/workspace/rm.cv.radar2026|g' compile_commands.json
end
