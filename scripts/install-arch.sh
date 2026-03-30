#!/bin/bash

# =====================================================
# � ARCH LINUX INSTALLER
# Arch Linux, EndeavourOS, Manjaro, ArcoLinux, etc.
# =====================================================

# Cargar funciones base
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install-base.sh"

# Paquetes esenciales para Arch
ARCH_BASE_PACKAGES=(
  "base-devel"
  "git"
  "fish"
  "stow"
  "tmux"
  "unzip"
  "zip"
  "p7zip"
  "tar"
  "ripgrep"
  "fzf"
  "jq"
  "htop"
  "ncdu"
  "tree"
  "pkgconf"
  "openssl"
  "libssh2"
  "xclip"
  "wget"
  "curl"
)

# Paquetes opcionales (AUR)
AUR_PACKAGES=(
  "lsd"
  "bat"
  "exa"
  "lazygit"
  "gh"
  "go"
  "fnm"
  "atuin"
  "zoxide"
)

# =====================================================
# 📦 DETECCIÓN DE DISTRO
# =====================================================

detect_arch_variant() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      arch)
        echo "arch"
        ;;
      endeavour)
        echo "endeavouros"
        ;;
      manjaro)
        echo "manjaro"
        ;;
      arcolinux)
        echo "arcolinux"
        ;;
      archcraft)
        echo "archcraft"
        ;;
      cachyos)
        echo "cachyos"
        ;;
      *)
        if [ -f /etc/arch-release ]; then
          echo "arch"
        else
          echo "unknown"
        fi
        ;;
    esac
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  else
    echo "unknown"
  fi
}

# Verificar si tenemos yay/paru
check_aur_helper() {
  if command -v yay &>/dev/null; then
    echo "yay"
  elif command -v paru &>/dev/null; then
    echo "paru"
  elif command -v pikaur &>/dev/null; then
    echo "pikaur"
  elif command -v trizen &>/dev/null; then
    echo "trizen"
  else
    echo "none"
  fi
}

# Instalar yay si no hay otro helper
install_yay() {
  if [ "$(check_aur_helper)" != "none" ]; then
    return 0
  fi

  info_msg "Instalando yay (AUR helper)..."
  
  # Clonar yay
  if [ ! -d "/tmp/yay" ]; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
  fi
  
  cd /tmp/yay
  run_cmd "makepkg -si --noconfirm" false "Error al instalar yay"
  cd - > /dev/null
  
  success_msg "yay instalado"
}

# =====================================================
# 🛠️ INSTALACIÓN DE DEPENDENCIAS
# =====================================================

install_pacman_packages() {
  print_header "📦 Instalando paquetes con pacman"

  # Sincronizar repositorios
  run_cmd "sudo pacman -Sy --noconfirm" true "Error al sincronizar repositorios"

  # Instalar paquetes base
  for pkg in "${ARCH_BASE_PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      info_msg "$pkg ya instalado"
    else
      info_msg "Instalando $pkg..."
      run_cmd "sudo pacman -S --noconfirm $pkg" false "Error al instalar $pkg" true
    fi
  done

  success_msg "Paquetes base instalados"
}

install_aur_packages() {
  print_header "📦 Instalando paquetes AUR"

  local aur_helper=$(check_aur_helper)
  
  if [ "$aur_helper" = "none" ]; then
    info_msg "No se encontró AUR helper, instalando yay..."
    install_yay
    aur_helper="yay"
  fi

  info_msg "Usando: $aur_helper"

  for pkg in "${AUR_PACKAGES[@]}"; do
    if $aur_helper -Qi "$pkg" &>/dev/null; then
      info_msg "$pkg ya instalado"
    else
      info_msg "Instalando $pkg..."
      $aur_helper -S --noconfirm "$pkg" &>/dev/null || info_msg "Error al instalar $pkg (continuando...)"
    fi
  done

  success_msg "Paquetes AUR instalados"
}

# =====================================================
# 🐟 INSTALAR FISH SHELL
# =====================================================

install_fish_arch() {
  print_header "🐟 Instalando Fish Shell"

  if is_installed fish; then
    info_msg "Fish ya instalado: $(fish --version)"
    return 0
  fi

  run_cmd "sudo pacman -S --noconfirm fish" false "Error al instalar fish"

  if is_installed fish; then
    success_msg "Fish instalado: $(fish --version)"
  else
    error_msg "No se pudo instalar fish"
    return 1
  fi
}

# =====================================================
# 🖥️ INSTALAR NEOVIM
# =====================================================

install_neovim() {
  print_header "🖥️ Instalando Neovim"

  if is_installed nvim; then
    info_msg "Neovim ya instalado: $(nvim --version | head -1)"
    return 0
  fi

  # Instalar desde pacman (versión más actualizada en repositorios de Arch)
  run_cmd "sudo pacman -S --noconfirm neovim" false "Error al instalar neovim"

  if ! is_installed nvim; then
    # Si falla, intentar con AppImage
    warn_msg "Intentando instalar Neovim via AppImage..."
    local nvim_version="0.10.0"
    
    run_cmd "wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim-linux64.appimage" \
      false "Error al descargar Neovim"
    
    chmod +x /tmp/nvim.appimage
    mkdir -p "$HOME/.local/bin"
    mv /tmp/nvim.appimage "$HOME/.local/bin/nvim"
    chmod +x "$HOME/.local/bin/nvim"
    export PATH="$HOME/.local/bin:$PATH"
  fi

  if is_installed nvim; then
    success_msg "Neovim instalado: $(nvim --version | head -1)"
  else
    error_msg "Error al instalar Neovim"
    return 1
  fi
}

# =====================================================
# 📦 INSTALAR HERRAMIENTAS DE DESARROLLO
# =====================================================

install_dev_tools() {
  print_header "💻 Instalando herramientas de desarrollo"

  # Go (si está en los paquetes seleccionados)
  if [ "$INSTALL_GO" = "Sí" ]; then
    if is_installed go; then
      info_msg "Go ya instalado: $(go version)"
    else
      info_msg "Instalando Go..."
      run_cmd "sudo pacman -S --noconfirm go" false "Error al instalar Go"
      success_msg "Go instalado: $(go version)"
    fi
  fi

  # Node.js con fnm (si está en los paquetes seleccionados)
  if [ "$INSTALL_NODE" = "Sí" ]; then
    # fnm se instala desde AUR o binary
    if is_installed fnm; then
      info_msg "fnm ya instalado"
    else
      info_msg "Instalando fnm..."
      curl -fsSL https://fnm.vercel.app/install | bash
      export PATH="$HOME/.local/share/fnm:$PATH"
    fi
    
    # Instalar pnpm
    if is_installed pnpm; then
      info_msg "pnpm ya instalado"
    else
      info_msg "Instalando pnpm..."
      if is_installed npm; then
        npm install -g pnpm 2>/dev/null || true
      fi
    fi
  fi

  # GitHub CLI
  if is_installed gh; then
    info_msg "GitHub CLI ya instalado"
  else
    info_msg "Instalando GitHub CLI..."
    run_cmd "sudo pacman -S --noconfirm github-cli" false "Error al instalar gh"
  fi

  success_msg "Herramientas de desarrollo configuradas"
}

# =====================================================
# 🦀 RUST (si se seleccionó)
# =====================================================

install_rust_arch() {
  if [ "$INSTALL_RUST" != "Sí" ]; then
    return 0
  fi

  print_header "🦀 Instalando Rust"

  if is_installed rustc; then
    info_msg "Rust ya instalado"
    return 0
  fi

  run_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" false "Error al instalar Rust"

  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi

  success_msg "Rust instalado"
}

# =====================================================
# 🚀 INSTALACIÓN PRINCIPAL
# =====================================================

main() {
  local distro=$(detect_arch_variant)
  local aur_helper=$(check_aur_helper)
  
  info_msg "Distro detectada: $distro"
  [ "$aur_helper" != "none" ] && info_msg "AUR helper: $aur_helper"
  
  echo
  print_header "�️ Instalador para Arch Linux"
  echo

  # Verificar si es root
  if [ "$(id -u)" -eq 0 ]; then
    error_msg "Este script no debe ejecutarse como root"
    echo -e "${YELLOW}Ejecutá el script como usuario normal, te pedirá sudo cuando sea necesario${RESET}"
    exit 1
  fi

  # Instalación
  setup_directories
  install_pacman_packages
  install_aur_packages
  install_fish_arch
  install_neovim
  install_dev_tools
  clone_dotfiles_repo
  install_additional_tools
  install_rust_arch
  stow_dotfiles
  set_default_shell
  cleanup

  print_header "🎉 ¡Instalación completada!"
  echo -e "${BOLD}${GREEN}Para aplicar los cambios, ejecutá:${RESET}"
  echo -e "  ${YELLOW}exec fish${RESET}"
  echo
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
