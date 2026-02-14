if status is-interactive

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
