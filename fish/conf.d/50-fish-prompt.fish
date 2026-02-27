# Load matugen generated theme
fish_config theme choose fufu-matugen

# --- Custom Prompt Colors ---
set -U my_p_icon_arch b9cf83
set -U my_p_icon_linux e3e3d7
set -U my_p_cwd c2caaa
set -U my_p_git a1d0c7
set -U my_p_mode_default b9cf83
set -U my_p_mode_insert c2caaa
set -U my_p_mode_visual a1d0c7
set -U my_p_mode_replace ffb4ab

function fish_prompt -d "Write out the prompt"
    echo

    set -l last_status $status

    # 1. 图标部分
    if test $last_status -eq 0
        if test "$OS" = linux
            if test "$OS_ID" = arch
                # 使用 Matugen 的命令颜色或自定义 Arch 蓝
                set_color -o $my_p_icon_arch
                echo -n ' '
            else
                set_color -o $my_p_icon_linux
                echo -n ' '
            end
        else
            set_color $fish_color_user # 通常是绿色系
            echo -n '✔ '
        end
    else
        set_color $fish_color_error
        echo -n '✖ '
    end

    echo -n ' '

    # 2. 路径部分 (prompt_pwd)
    # 使用主题中专门定义的路径颜色
    set_color -i $my_p_cwd
    echo -n (prompt_pwd)

    # 3. Git 信息部分
    # 使用 quote (通常比较柔和) 或 param
    set_color -o $my_p_git
    echo -n (fish_git_prompt)

    echo -n ' '

    # 4. Vi 模式指示器
    # 根据 Matugen 生成的色调进行逻辑匹配
    switch $fish_bind_mode
        case default
            set_color $my_p_mode_default # 默认/普通模式：使用命令色 (紫色/蓝色)
            echo -n "[N]"
        case insert
            set_color $my_p_mode_insert # 插入模式：使用引用色 (通常是绿色)
            echo -n "[I]"
        case visual
            set_color $my_p_mode_visual # 可视模式：使用关键字色 (通常是紫色/粉色)
            echo -n "[V]"
        case replace_one
            set_color $my_p_mode_replace # 替换模式：使用错误色 (通常是红色/橙色)
            echo -n "[R]"
    end

    echo

    set_color normal
    echo -n '> '
end
