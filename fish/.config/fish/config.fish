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

# Variables de entorno del sistema
set -gx XDG_RUNTIME_DIR "$PREFIX/tmp/" # Definir directorio de tiempo de ejecución XDG

# Configuración de PATH básico
append_path "$HOME/.local/bin"

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
# CONFIGURACIÓN PERSONALIZADA
#-----------------------------------------
set -g DOTS_CONFIG_DIR "$HOME/dots.config"
if test -f "$DOTS_CONFIG_DIR/shell/fish_custom.fish"
    source "$DOTS_CONFIG_DIR/shell/fish_custom.fish"
end

#-----------------------------------------
# HERRAMIENTAS EXTERNAS
#-----------------------------------------
# Atuin
atuin init fish | source

# OpenCode
set -gx PATH /home/tiadmin/.opencode/bin $PATH
set -gx EDITOR "code --wait"

#Nodejs
fnm env --use-on-cd --shell fish | source

