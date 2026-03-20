#-----------------------------------------
# ALIAS Y FUNCIONES BÁSICAS
#-----------------------------------------
# Aliases para navegación y listado de directorios
# Utiliza 'lsd' como reemplazo mejorado del comando 'ls' estándar
# Aliases para desarrollo y editores
alias n='nvim .' # Abrir Neovim en el directorio actual
alias pj='cd ~/Projects && ls' # Navegar al directorio de proyectos y listar su contenido
alias vc='code --reuse-window .' # Abrir VSCode en la ventana actual para el directorio actual

alias oc='opencode'

alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

alias lg='lazygit'
