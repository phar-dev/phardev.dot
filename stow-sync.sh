#!/bin/bash
# stow-sync.sh - Sync dotfiles using GNU Stow

set -e

# Constants
readonly SCRIPT_NAME="stow-sync"
readonly SCRIPT_VERSION="1.0.0"
readonly STOW_DIRS=("zsh" "nvim" "opencode" "promt" "tmux")

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Functions
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}$1${NC}"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

usage() {
    cat << EOF
${SCRIPT_NAME} v${SCRIPT_VERSION} - Sync dotfiles using GNU Stow

USAGE:
    ${SCRIPT_NAME} [OPTIONS]

OPTIONS:
    -d, --dry-run    Show what would be done without making changes
    -h, --help       Show this help message
    -v, --verbose    Enable verbose output
    --version        Show version information

DESCRIPTION:
    This script applies GNU Stow to sync dotfile configurations.
    It processes the following directories: ${STOW_DIRS[*]}

EXAMPLES:
    ${SCRIPT_NAME}                    # Apply all stow configurations
    ${SCRIPT_NAME} --dry-run          # Preview changes without applying
    ${SCRIPT_NAME} --verbose          # Show detailed output

EOF
}

check_dependencies() {
    if ! command -v stow >/dev/null 2>&1; then
        error_exit "GNU Stow is required but not installed. Please install it first."
    fi
}

sync_stow() {
    local dry_run="$1"
    local verbose="$2"

    for dir in "${STOW_DIRS[@]}"; do
        if [[ ! -d "$dir" ]]; then
            warning "Directory '$dir' not found, skipping..."
            continue
        fi

        info "Processing $dir..."

        local stow_cmd=("stow")
        if [[ "$dry_run" == "true" ]]; then
            stow_cmd+=("--no")
        fi
        if [[ "$verbose" == "true" ]]; then
            stow_cmd+=("--verbose")
        fi
        stow_cmd+=("$dir")

        if ! "${stow_cmd[@]}"; then
            error_exit "Failed to process $dir"
        fi

        if [[ "$dry_run" != "true" ]]; then
            info "✓ $dir synced successfully"
        fi
    done
}

main() {
    local dry_run="false"
    local verbose="false"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                dry_run="true"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                verbose="true"
                shift
                ;;
            --version)
                echo "${SCRIPT_NAME} v${SCRIPT_VERSION}"
                exit 0
                ;;
            *)
                error_exit "Unknown option: $1. Use --help for usage information."
                ;;
        esac
    done

    check_dependencies

    if [[ "$dry_run" == "true" ]]; then
        info "DRY RUN MODE - No changes will be made"
    fi

    sync_stow "$dry_run" "$verbose"

    if [[ "$dry_run" != "true" ]]; then
        info "All dotfiles synced successfully!"
    else
        info "Dry run completed. Use without --dry-run to apply changes."
    fi
}

# Execute main function
main "$@"