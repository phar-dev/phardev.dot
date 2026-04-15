#=========================================================
# CONFIGURACIÓN DE FISH PERSONALIZADA
#=========================================================

#-----------------------------------------
# CONFIGURACIÓN BÁSICA DE FISH
#-----------------------------------------
set -g fish_greeting ""

#-----------------------------------------
# GESTIÓN DEL ENTORNO Y PATH
#-----------------------------------------
# Función helper para añadir directorios al PATH si existen
function append_path
    if test -d $argv[1]
        if not contains $argv[1] $PATH
            set -gx PATH $argv[1] $PATH
        end
    end
end

# Arreglar XDG_RUNTIME_DIR si apunta a /tmp o está mal
if test "$XDG_RUNTIME_DIR" = /tmp/ -o "$XDG_RUNTIME_DIR" = "/run/user/(id -u)"
    set -gx XDG_RUNTIME_DIR /run/user/(id -u)
end

# Configuración de PATH básico
append_path "$HOME/.local/bin"

# Laravel Herd (PHP, Composer, Laravel)
append_path "$HOME/.config/herd-lite/bin"

#-----------------------------------------
# CARGA DE MÓDULOS Y PLUGINS
#-----------------------------------------
set -g FISH_CONFIG_DIR "$HOME/.config/fish"
set -g FISH_FUNCTIONS_DIR "$FISH_CONFIG_DIR/functions"
set -g FISH_COMPLETIONS_DIR "$FISH_CONFIG_DIR/completions"

function load_module
    if test -f $argv[1]
        source $argv[1]
    end
end

# Cargar funciones y configuraciones
load_module "$FISH_FUNCTIONS_DIR/aliases.fish"
load_module "$FISH_FUNCTIONS_DIR/functions.fish"
load_module "$FISH_FUNCTIONS_DIR/completions.fish"

#-----------------------------------------
# HOMEBREW
#-----------------------------------------
set -g BREW_BIN "/home/linuxbrew/.linuxbrew/bin"
if test -f "$BREW_BIN/brew"
    eval ($BREW_BIN/brew shellenv)
end

# Cargar configuraciones de herramientas
load_module "$FISH_FUNCTIONS_DIR/fzf.fish"
load_module "$FISH_FUNCTIONS_DIR/navigation.fish"
load_module "$FISH_FUNCTIONS_DIR/bindings.fish"

#-----------------------------------------
# FISHER Y PLUGINS
#-----------------------------------------
# Plugins se instalarán automáticamente con fisher

#-----------------------------------------
# HERRAMIENTAS EXTERNAS
#-----------------------------------------
# Atuin
set -Ux fish_user_paths $HOME/.atuin/bin $fish_user_paths

atuin init fish | source

# OpenCode
set -gx PATH /home/$USER/.opencode/bin $PATH
set -gx EDITOR "nvim"

#Nodejs - fnm (Fast Node Manager)
# Agregar fnm al PATH primero
set -gx FNM_DIR "$HOME/.local/share/fnm"
if test -d "$FNM_DIR"
    set -gx PATH "$FNM_DIR" $PATH
    if command -v fnm >/dev/null
        fnm env | source
    end
end

# Cargar variables de entorno locales
if test -f ~/.env
    source ~/.env
end

#-----------------------------------------
# TMUX DEFAULT SESSION
#-----------------------------------------
# Launch tmux if interactive and not already in tmux
# if status is-interactive; and not set -q TMUX
#     tmux attach-session 2>/dev/null || tmux new-session -s default
# end

# opencode
fish_add_path /home/phardev/.opencode/bin
# caelestia scheme set -n dynamic

# pnpm
set -gx PNPM_HOME "/home/$USER/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# opencode
fish_add_path /home/test/.opencode/bin
# set -gx PATH (go env GOPATH)/bin $PATH

# Auto-Warpify
status --is-interactive; and printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish", "uname": "Linux" }}�' 
