#!/bin/bash

# =====================================================
# 🐧 INSTALADOR PARA DISTROS DEBIAN-BASED
# Debian, Ubuntu, Linux Mint, Pop!_OS, etc.
# =====================================================

# Cargar funciones base
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/install-base.sh"

# Paquetes esenciales para Debian/Ubuntu
DEBIAN_BASE_PACKAGES=(
  "build-essential"
  "curl"
  "wget"
  "git"
  "fish"
  "stow"
  "tmux"
  "unzip"
  "zip"
  "p7zip-full"
  "tar"
  "lsd"
  "bat"
  "ripgrep"
  "fzf"
  "exa"
  "jq"
  "htop"
  "ncdu"
  "tree"
  "silversearcher-ag"
  "xclip"
  "pkg-config"
  "libssl-dev"
)

# =====================================================
# 📦 DETECCIÓN DE DISTRO
# =====================================================

detect_debian_variant() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      debian)
        echo "debian"
        ;;
      ubuntu)
        echo "ubuntu"
        ;;
      linuxmint)
        echo "mint"
        ;;
      pop)
        echo "popos"
        ;;
      elementary)
        echo "elementary"
        ;;
      zorin)
        echo "zorin"
        ;;
      fedora|rhel|centos|rocky|alma)
        # No es debian-based
        echo "not-debian"
        ;;
      *)
        # Podría ser debian
        if [ -f /etc/debian_version ]; then
          echo "debian-unknown"
        else
          echo "unknown"
        fi
        ;;
    esac
  elif [ -f /etc/debian_version ]; then
    echo "debian"
  else
    echo "unknown"
  fi
}

# =====================================================
# 🛠️ INSTALACIÓN DE DEPENDENCIAS
# =====================================================

install_apt_packages() {
  print_header "📦 Instalando paquetes con apt"

  # Actualizar repositorios
  info_msg "Actualizando repositorios..."
  run_cmd "sudo apt-get update" true "Error al actualizar repositorios"

  # Instalar paquetes
  for pkg in "${DEBIAN_BASE_PACKAGES[@]}"; do
    if dpkg -l | grep -q "^ii  $pkg "; then
      info_msg "$pkg ya instalado"
    else
      info_msg "Instalando $pkg..."
      run_cmd "sudo apt-get install -y $pkg" false "Error al instalar $pkg" true
    fi
  done

  success_msg "Paquetes base instalados"
}

# =====================================================
# 🐟 INSTALAR FISH SHELL
# =====================================================

install_fish_debian() {
  print_header "🐟 Instalando Fish Shell"

  # Verificar si ya está instalado
  if is_installed fish; then
    info_msg "Fish ya instalado: $(fish --version)"
    return 0
  fi

  # Añadir repositorio fish-shell si es Ubuntu
  local distro=$(detect_debian_variant)
  
  if [ "$distro" = "ubuntu" ]; then
    info_msg "Añadiendo repositorio fish-shell..."
    
    # Añadir clave GPG
    run_cmd "sudo apt-add-repository ppa:fish-shell/release-3" true "Error al añadir repositorio" true
    
    # Actualizar e instalar
    run_cmd "sudo apt-get update" true "Error al actualizar"
    run_cmd "sudo apt-get install -y fish" false "Error al instalar fish"
  else
    # Instalar desde repositorios base
    run_cmd "sudo apt-get install -y fish" false "Error al instalar fish"
  fi

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

  local nvim_version="0.10.0"
  local nvim_appimage="nvim-linux64"

  info_msg "Descargando Neovim $nvim_version..."
  
  # Descargar AppImage
  run_cmd "wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v${nvim_version}/${nvim_appimage}.appimage" \
    false "Error al descargar Neovim"

  # Hacer ejecutable
  chmod +x /tmp/nvim.appimage

  # Instalar (como AppImage o extraer)
  if [ ! -w /opt ]; then
    # Si no tenemos permisos, instalar en ~/.local
    mkdir -p "$HOME/.local/bin"
    mv /tmp/nvim.appimage "$HOME/.local/bin/nvim"
    chmod +x "$HOME/.local/bin/nvim"
    export PATH="$HOME/.local/bin:$PATH"
  else
    # Instalar en /opt
    sudo mv /tmp/nvim.appimage /opt/nvim
    sudo ln -sf /opt/nvim /usr/local/bin/nvim
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

  # Git (ya debería estar instalado, pero verificamos)
  if is_installed gh; then
    info_msg "GitHub CLI ya instalado"
  else
    info_msg "Instalando GitHub CLI..."
    # Añadir repo de GitHub
    type -p wget > /dev/null || sudo apt-get install -y wget
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    run_cmd "sudo apt-get update && sudo apt-get install -y gh" false "Error al instalar gh"
  fi

  # Go
  if [ "$INSTALL_GO" = "Sí" ]; then
    if is_installed go; then
      info_msg "Go ya instalado: $(go version)"
    else
      info_msg "Instalando Go..."
      local go_version="1.21.5"
      local arch=$(dpkg --print-architecture)
      local go_file="go${go_version}.linux-${arch}.tar.gz"
      
      run_cmd "wget -O /tmp/go.tar.gz https://go.dev/dl/${go_file}" false "Error al descargar Go"
      run_cmd "sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz" false "Error al instalar Go"
      rm -f /tmp/go.tar.gz
      
      export PATH="/usr/local/go/bin:$PATH"
      success_msg "Go instalado: $(go version)"
    fi
  fi

  # Node.js con fnm
  if [ "$INSTALL_NODE" = "Sí" ]; then
    # Instalar fnm
    if is_installed fnm; then
      info_msg "fnm ya instalado"
    else
      info_msg "Instalando fnm..."
      run_cmd "curl -fsSL https://fnm.vercel.app/install | bash" false "Error al instalar fnm"
      export PATH="$HOME/.local/share/fnm:$PATH"
    fi
    
    # Instalar pnpm
    if is_installed pnpm; then
      info_msg "pnpm ya instalado"
    else
      info_msg "Instalando pnpm..."
      if is_installed npm; then
        run_cmd "npm install -g pnpm" false "Error al instalar pnpm"
      fi
    fi
  fi

  success_msg "Herramientas de desarrollo configuradas"
}

# =====================================================
# 🚀 INSTALACIÓN PRINCIPAL
# =====================================================

main() {
  local distro=$(detect_debian_variant)
  
  if [ "$distro" = "unknown" ]; then
    warn_msg "No se pudo detectar la distro. Intentando instalar de todos modos..."
  else
    info_msg "Distro detectada: $distro"
  fi

  echo
  print_header "🐧 Instalador para Debian/Ubuntu"
  echo

  # Verificar si es root
  if [ "$(id -u)" -eq 0 ]; then
    error_msg "Este script no debe ejecutarse como root"
    echo -e "${YELLOW}Ejecutá el script como usuario normal, te pedirá sudo cuando sea necesario${RESET}"
    exit 1
  fi

  # Instalación
  setup_directories
  install_apt_packages
  install_fish_debian
  install_neovim
  install_dev_tools
  clone_dotfiles_repo
  install_additional_tools
  install_rust
  stow_dotfiles
  set_default_shell
  cleanup

  print_header "🎉 ¡Instalación completada!"
  echo -e "${BOLD}${GREEN}Para aplicar los cambios, ejecutá:${RESET}"
  echo -e "  ${YELLOW}exec fish${RESET}"
  echo
}

# Ejecutar si se llama directamente (no al source)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
