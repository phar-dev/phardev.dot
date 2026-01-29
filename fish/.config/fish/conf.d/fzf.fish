#-----------------------------------------
# CONFIGURACIÓN DE FZF Y HERRAMIENTAS RELACIONADAS (FISH)
#-----------------------------------------

# Verificar si FZF está instalado
if command -v fzf >/dev/null 2>&1
    # Configuración de FZF
    set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline"
    
    # Usar ripgrep como buscador predeterminado si está disponible
    if command -v rg >/dev/null 2>&1
        set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end
    
    # Integraciones de Fish con FZF
    # Estas funciones se cargan automáticamente si fzf está instalado
    if type -q fzf_key_bindings
        fzf_key_bindings
    end
end