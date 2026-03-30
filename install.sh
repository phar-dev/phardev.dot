#!/bin/bash

# =====================================================
# 🚀 INSTALADOR UNIVERSAL DE DOTFILES
# Detecta automáticamente la distro y usa el instalador apropiado
# =====================================================

set -e

# Fix para tput en entornos no-interactivos
export TERM="${TERM:-xterm}"

# Colores
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

# =====================================================
# 🖥️ DETECCIÓN DE DISTRO
# =====================================================

detect_distro() {
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    
    # Linux Mint, Ubuntu, Pop!_OS, etc.
    case "$ID" in
      debian|ubuntu|linuxmint|pop|elementary|zorin|deepin|nerd|ultra)
        echo "debian"
        return
        ;;
      arch|endeavour|manjaro|arcolinux|archcraft|cachyos|garuda)
        echo "arch"
        return
        ;;
      fedora|rhel|centos|rocky|alma)
        echo "fedora"
        return
        ;;
      opensuse|sles)
        echo "opensuse"
        return
        ;;
      void)
        echo "void"
        return
        ;;
      nixos)
        echo "nixos"
        return
        ;;
    esac
    
    # Verificar variantes
    if [ -f /etc/debian_version ]; then
      echo "debian"
      return
    fi
    
    if [ -f /etc/arch-release ]; then
      echo "arch"
      return
    fi
  fi
  
  # Fallback: verificar archivos específicos
  if [ -f /etc/debian_version ]; then
    echo "debian"
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  elif [ -f /etc/fedora-release ]; then
    echo "fedora"
  else
    echo "unknown"
  fi
}

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

# =====================================================
# 📋 AYUDA
# =====================================================

show_help() {
  cat << EOF
🚀 Instalador Universal de Dotfiles phardev.dot

Uso: 
  ./install.sh              # Detectar distro automáticamente e instalar
  ./install.sh --arch      # Forzar instalación para Arch Linux
  ./install.sh --debian    # Forzar instalación para Debian/Ubuntu
  ./install.sh --help      # Mostrar esta ayuda
  ./install.sh --dry-run  # Simular instalación sin hacer cambios

Ejemplos:
  ./install.sh             # Instalación automática
  ./install.sh --arch      # Instalar en Arch Linux
  ./install.sh --debian    # Instalar en Debian/Ubuntu
EOF
}

# =====================================================
# 🚀 MAIN
# =====================================================

main() {
  local distro=""
  local script_dir
  
  # Obtener directorio del script
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  # Verificar que scripts/ existe
  if [ ! -d "$script_dir/scripts" ]; then
    error_msg "No se encontró el directorio scripts/"
    exit 1
  fi
  
  # Parsear argumentos
  case "${1:-}" in
    --arch|-a)
      distro="arch"
      info_msg "Forzando instalación para Arch Linux"
      ;;
    --debian|-d)
      distro="debian"
      info_msg "Forzando instalación para Debian/Ubuntu"
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    --dry-run|--dryrun)
      info_msg "Modo dry-run (simulación)"
      DRY_RUN=true
      ;;
    --)
      # Fin de opciones
      ;;
    "")
      # Sin argumentos, detectar automáticamente
      distro=$(detect_distro)
      ;;
    *)
      error_msg "Opción desconocida: $1"
      show_help
      exit 1
      ;;
  esac
  
  echo
  print_header "🎨 phardev.dot - Instalador Universal"
  echo -e "${PURPLE}Bienvenido a la instalación de tus dotfiles${RESET}"
  echo
  
  # Verificar que no se ejecute como root
  if [ "$(id -u)" -eq 0 ]; then
    error_msg "Este script no debe ejecutarse como root"
    echo -e "${YELLOW}Ejecutalo como usuario normal, te pedirá sudo cuando sea necesario${RESET}"
    exit 1
  fi
  
  # Si no se forzó la distro, mostrar lo detectado
  if [ -z "$distro" ] || [ "$distro" = "unknown" ]; then
    distro=$(detect_distro)
  fi
  
  # Mostrar distro detectada
  info_msg "Distribución detectada: $distro"
  
  # Seleccionar script según distro
  case "$distro" in
    arch)
      info_msg "Ejecutando instalador para Arch Linux..."
      echo
      bash "$script_dir/scripts/install-arch.sh"
      ;;
    debian)
      info_msg "Ejecutando instalador para Debian/Ubuntu..."
      echo
      bash "$script_dir/scripts/install-debian.sh"
      ;;
    fedora)
      warn_msg "Fedora aún no tiene instalador específico"
      warn_msg "Podés crear scripts/install-fedora.sh contribuyendo al proyecto"
      echo
      info_msg "Podés probar con ./install.sh --debian como alternativa"
      exit 1
      ;;
    *)
      error_msg "Distro no soportada: $distro"
      echo
      echo "Distros soportadas:"
      echo "  • Arch Linux y derivados (EndeavourOS, Manjaro, etc.)"
      echo "  • Debian, Ubuntu, Linux Mint, Pop!_OS, etc."
      echo
      echo "Podés crear un instalador específico contribuyendo al proyecto"
      exit 1
      ;;
  esac
}

# Ejecutar main
main "$@"
