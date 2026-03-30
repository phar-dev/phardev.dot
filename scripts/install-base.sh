#!/bin/bash

# =====================================================
# 🔧 FUNCIONES COMUNES - Base Installer
# Shared functions for all distros
# =====================================================

# Fix para tput en entornos no-interactivos
export TERM="${TERM:-xterm}"

# Colores (mismos que install.sh)
PINK=$(tput setaf 204)
PURPLE=$(tput setaf 141)
GREEN=$(tput setaf 114)
ORANGE=$(tput setaf 208)
BLUE=$(tput setaf 75)
YELLOW=$(tput setaf 221)
RED=$(tput setaf 196)
NC=$(tput sgr0)
BOLD="\e[1m"
RESET="\e[0m"

# URLs de herramientas
REPO_URL="https://github.com/phar-dev/phardev.dot.git"
REPO_BRANCH="master"
REPO_DIR="phardev.dot"
ZOXIDE_URL="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh"
ATUIN_URL="https://setup.atuin.sh"

# Directorios
CONFIG_DIR="$HOME/.config"
DOTFILES_PATH=""

# Variables globales
INSTALL_RUST="No"
INSTALL_GO="No"
INSTALL_NODE="No"
BACKUP_DIR=""

# =====================================================
# 🛠️ FUNCIONES AUXILIARES
# =====================================================

print_header() {
  local text="$1"
  local len=${#text}
  local width=$((len + 4))
  local top_bottom=$(printf '═%.0s' $(seq 1 $width))
  echo -e "${BLUE}╔${top_bottom}╗${RESET}"
  echo -e "${BLUE}║  ${BOLD}${GREEN}${text}${RESET}  ${BLUE}║${RESET}"
  echo -e "${BLUE}╚${top_bottom}╝${RESET}"
  echo
}

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid >/dev/null 2>&1; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b\b"
}

success_msg() {
  echo -e "${GREEN}✅ $1${RESET}"
}

info_msg() {
  echo -e "${YELLOW}ℹ️ $1${RESET}"
}

error_msg() {
  echo -e "${RED}❌ $1${RESET}"
}

warn_msg() {
  echo -e "${ORANGE}⚠️ $1${RESET}"
}

# Verificar si un comando está instalado
is_installed() {
  local cmd="$1"
  command -v "$cmd" &>/dev/null
}

# Ejecutar comando con manejo de errores
run_cmd() {
  local cmd="$1"
  local hide_output="${2:-false}"
  local error_msg_text="${3:-Error al ejecutar: $cmd}"
  local optional="${4:-false}"

  info_msg "Ejecutando: $cmd"

  if [ "$hide_output" = "true" ]; then
    eval "$cmd" &>/dev/null &
    local cmd_pid=$!
    spinner $cmd_pid
    wait $cmd_pid
    local exit_code=$?
  else
    eval "$cmd"
    local exit_code=$?
  fi

  if [ $exit_code -eq 0 ]; then
    return 0
  else
    if [ "$optional" = "true" ]; then
      warn_msg "$error_msg_text (opcional, continuando...)"
      return 0
    else
      error_msg "$error_msg_text"
      return 1
    fi
  fi
}

# =====================================================
# 📁 GESTIÓN DE DIRECTORIOS
# =====================================================

setup_directories() {
  print_header "📁 Configurando directorios"

  mkdir -p "$HOME/.local/share/atuin"
  mkdir -p "$HOME/.local/bin"

  success_msg "Directorios creados correctamente"
}

# =====================================================
# 📦 CLONAR REPOSITORIO
# =====================================================

clone_dotfiles_repo() {
  print_header "📦 Clonando repositorio de dotfiles"

  local current_dir=$(pwd)

  if [ -d "$REPO_DIR" ]; then
    info_msg "Repositorio ya clonado. Actualizando..."
    cd "$REPO_DIR"
    git pull origin "$REPO_BRANCH" 2>/dev/null || true
  else
    run_cmd "git clone -b $REPO_BRANCH --single-branch $REPO_URL $REPO_DIR" false "Error al clonar repositorio"
  fi

  cd "$REPO_DIR" || exit 1
  DOTFILES_PATH=$(pwd)

  success_msg "Repositorio clonado/actualizado en: $DOTFILES_PATH"
  echo "$DOTFILES_PATH" > /tmp/dotfiles_path.txt
}

# =====================================================
# 🐚 INSTALAR FISH SHELL
# =====================================================

install_fish() {
  print_header "🐚 Instalando Fish Shell"

  if is_installed fish; then
    info_msg "Fish ya está instalado: $(fish --version)"
    return 0
  fi

  # La instalación real se hace en cada distro específica
  # Esta función es para verificación post-instalación
  if is_installed fish; then
    success_msg "Fish instalado correctamente"
  else
    error_msg "Fish no se instaló correctamente"
    return 1
  fi
}

# =====================================================
# 🔧 HERRAMIENTAS ADICIONALES
# =====================================================

install_zoxide() {
  if is_installed zoxide; then
    info_msg "zoxide ya está instalado"
    return 0
  fi

  info_msg "Instalando zoxide..."
  if run_cmd "curl -sSfL $ZOXIDE_URL | sh" false "Error al instalar zoxide"; then
    # Añadir al PATH si es necesario
    if [ -f "$HOME/.local/bin/zoxide" ]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
    success_msg "zoxide instalado correctamente"
  else
    warn_msg "Error al instalar zoxide (opcional)"
  fi
}

install_atuin() {
  if is_installed atuin; then
    info_msg "atuin ya está instalado"
    return 0
  fi

  info_msg "Instalando atuin..."
  if run_cmd "curl --proto '=https' --tlsv1.2 -LsSf $ATUIN_URL | sh" false "Error al instalar atuin"; then
    if [ -f "$HOME/.local/bin/atuin" ]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi
    success_msg "atuin instalado correctamente"
  else
    warn_msg "Error al instalar atuin (opcional)"
  fi
}

install_additional_tools() {
  print_header "🔧 Instalando herramientas adicionales"

  install_zoxide
  install_atuin

  success_msg "Herramientas adicionales configuradas"
}

# =====================================================
# 🔗 CONFIGURAR DOTFILES CON STOW
# =====================================================

stow_dotfiles() {
  print_header "🔗 Configurando dotfiles con stow"

  if [ -z "$DOTFILES_PATH" ]; then
    if [ -f /tmp/dotfiles_path.txt ]; then
      DOTFILES_PATH=$(cat /tmp/dotfiles_path.txt)
    fi
  fi

  if [ -z "$DOTFILES_PATH" ] || [ ! -d "$DOTFILES_PATH" ]; then
    error_msg "No se encontró el directorio de dotfiles"
    return 1
  fi

  cd "$DOTFILES_PATH" || exit 1

  local stow_dirs=("nvim" "fish" "opencode" "tmux")

  # Crear backup si no existe
  if [ -z "$BACKUP_DIR" ]; then
    BACKUP_DIR="$HOME/backup-$(date +%Y%m%d_%H%M%S)"
  fi

  # Backup de archivos existentes
  local nvim_dir="$HOME/.config/nvim"
  local fish_dir="$HOME/.config/fish"
  local opencode_dir="$HOME/.config/opencode"
  local tmux_conf="$HOME/.tmux.conf"

  for dir in "$nvim_dir" "$fish_dir" "$opencode_dir"; do
    if [ -e "$dir" ] && [ ! -L "$dir" ]; then
      mkdir -p "$BACKUP_DIR"
      mv "$dir" "$BACKUP_DIR/" 2>/dev/null || true
      info_msg "Backup de $dir"
    fi
  done

  if [ -e "$tmux_conf" ] && [ ! -L "$tmux_conf" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$tmux_conf" "$BACKUP_DIR/" 2>/dev/null || true
    info_msg "Backup de $tmux_conf"
  fi

  # Ejecutar stow
  for dir in "${stow_dirs[@]}"; do
    if [ -d "$dir" ]; then
      info_msg "Configurando $dir..."
      stow --verbose --target="$HOME" "$dir" 2>/dev/null || true
    fi
  done

  if [ -d "$BACKUP_DIR" ]; then
    info_msg "Backups guardados en: $BACKUP_DIR"
  fi

  success_msg "Dotfiles configurados correctamente"
}

# =====================================================
# 🐚 CONFIGURAR SHELL POR DEFECTO
# =====================================================

set_default_shell() {
  print_header "🐚 Configurando Fish como shell por defecto"

  local shell_path
  shell_path=$(command -v fish)

  if [ -z "$shell_path" ]; then
    error_msg "Fish no encontrado en PATH"
    return 1
  fi

  # Verificar si ya es el shell por defecto
  if [ "$SHELL" = "$shell_path" ]; then
    info_msg "Fish ya es el shell por defecto"
    return 0
  fi

  # Añadir a /etc/shells si no existe
  if ! grep -Fxq "$shell_path" /etc/shells 2>/dev/null; then
    info_msg "Añadiendo Fish a /etc/shells..."
    echo "$shell_path" | sudo tee -a /etc/shells > /dev/null 2>&1 || true
  fi

  # Cambiar shell automáticamente
  if command -v chsh &>/dev/null; then
    if chsh -s "$shell_path" 2>/dev/null; then
      success_msg "Fish establecido como shell por defecto"
    else
      info_msg "Para cambiar manualmente: chsh -s $shell_path"
    fi
  else
    info_msg "chsh no disponible"
    info_msg "Para cambiar manualmente: chsh -s $shell_path"
  fi
}

# =====================================================
# 🦀 INSTALAR RUST
# =====================================================

install_rust() {
  if [ "$INSTALL_RUST" != "Sí" ]; then
    return 0
  fi

  print_header "🦀 Instalando Rust"

  if is_installed rustc; then
    info_msg "Rust ya está instalado"
    return 0
  fi

  run_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" false "Error al instalar Rust"

  # Source cargo env
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi

  success_msg "Rust instalado correctamente"
}

# =====================================================
# 🧹 LIMPIEZA FINAL
# =====================================================

cleanup() {
  print_header "🧹 Limpiando"

  # Limpiar archivos temporales
  rm -f /tmp/dotfiles_path.txt

  success_msg "Limpieza completada"
}

# =====================================================
# 📋 SELECCIÓN DE HERRAMIENTAS
# =====================================================

select_language_tools() {
  print_header "💻 Selección de Lenguajes de Programación"
  echo -e "${YELLOW}Herramientas de desarrollo opcionales:${RESET}"
  echo

  # Preguntar solo si las herramientas no están ya instaladas
  if ! is_installed rustc; then
    echo -e "${BLUE}¿Instalar Rust?${RESET}"
    read -p "  [s/N]: " -r
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      INSTALL_RUST="Sí"
    fi
  fi

  if ! is_installed go; then
    echo -e "${BLUE}¿Instalar Go?${RESET}"
    read -p "  [s/N]: " -r
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      INSTALL_GO="Sí"
    fi
  fi

  if ! is_installed fnm; then
    echo -e "${BLUE}¿Instalar Node.js (fnm + pnpm)?${RESET}"
    read -p "  [s/N]: " -r
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      INSTALL_NODE="Sí"
    fi
  fi
}

# Exportar funciones para que estén disponibles en otros scripts
export -f print_header success_msg info_msg error_msg warn_msg
export -f is_installed run_cmd setup_directories clone_dotfiles_repo
export -f install_zoxide install_atuin install_additional_tools
export -f stow_dotfiles set_default_shell install_rust
