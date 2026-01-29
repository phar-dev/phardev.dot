#-----------------------------------------
# CONFIGURACIÓN DE FZF Y HERRAMIENTAS RELACIONADAS
#-----------------------------------------

# Verificar si FZF está instalado
if command -v fzf >/dev/null 2>&1
    # Cargar funciones y completados de FZF
    # Nota: En fish, fzf puede necesitar configuración específica

    # Configuración de FZF
    set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline"

    # Usar ripgrep como buscador predeterminado si está disponible
    if command -v rg >/dev/null 2>&1
        set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end

    # Atajos de teclado útiles para FZF
    # CTRL-T - Pegar archivos y directorios seleccionados en la línea de comandos
    # CTRL-R - Búsqueda en historial de comandos
    # ALT-C  - Cambiar a subdirectorio seleccionado
end