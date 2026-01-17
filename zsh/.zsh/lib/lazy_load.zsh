#-----------------------------------------
# CARGA DIRECTA DE HERRAMIENTAS
#-----------------------------------------
# Este archivo carga los módulos directamente sin lazy loading.

# Carga directa para herramientas de desarrollo
load_module "$ZSH_TOOLS_DIR/dev.zsh"

# Carga directa para PHP/Laravel
load_module "$ZSH_TOOLS_DIR/php.zsh"

# Carga directa para Node.js
load_module "$ZSH_TOOLS_DIR/node.zsh"

# Carga directa para Go
load_module "$ZSH_TOOLS_DIR/golang.zsh"

# Carga directa para Docker
load_module "$ZSH_TOOLS_DIR/docker.zsh"

# Agrega tus cargas personalizadas aquí si es necesario