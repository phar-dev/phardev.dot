#-----------------------------------------
# CONFIGURACIÓN DE PROMPT FISH (REEMPLAZO DE OH-MY-POSH)
#-----------------------------------------

# Función personalizada para el prompt
function fish_prompt
    # Guardar el último código de salida
    set -l last_status $status

    # Colors
    set -l color_cyan (set_color cyan)
    set -l color_yellow (set_color yellow)
    set -l color_green (set_color green)
    set -l color_red (set_color red)
    set -l color_blue (set_color blue)
    set -l color_normal (set_color normal)

    # Prompt de línea 1: usuario@host y directorio
    echo -n $color_cyan
    echo -n (whoami)
    echo -n $color_normal
    echo -n '@'
    echo -n $color_yellow
    echo -n (hostname -s)
    echo -n $color_normal
    echo -n ' in '
    echo -n $color_blue
    echo -n (prompt_pwd)
    echo -n $color_normal

    # Git status si estamos en un repo
    if test -n (git rev-parse --git-dir 2>/dev/null)
        set -l git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set -l git_status (git status --porcelain 2>/dev/null)

        echo -n ' '
        if test -n "$git_status"
            echo -n $color_red
            echo -n '⚡'$git_branch
        else
            echo -n $color_green
            echo -n '✓'$git_branch
        end
        echo -n $color_normal
    end

    # Nueva línea para el prompt de comandos
    echo

    # Prompt de línea 2: símbolo del sistema
    if test $last_status -eq 0
        echo -n $color_green'❯'$color_normal
    else
        echo -n $color_red'❯'$color_normal
    end

    echo -n ' '
end

# Función para el prompt derecho (opcional)
function fish_right_prompt
    set -l color_normal (set_color normal)
    set -l color_gray (set_color 666)

    # Mostrar tiempo actual
    echo -n $color_gray(date +%H:%M:%S)$color_normal
end