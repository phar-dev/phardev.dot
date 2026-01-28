# AGENTS.md - Guidelines for AI Agents Working on phardev.dot

This file contains guidelines for AI coding agents (such as opencode agents) working on this dotfiles repository. It ensures consistency across Zsh configurations, Neovim setup, installation scripts, and related tools.

## Repository Overview

This is a personal dotfiles repository containing:
- Zsh shell configuration with plugins and tools
- Neovim/LazyVim setup with custom plugins
- Installation and setup scripts
- AI tool configurations (opencode)

## Build/Lint/Test Commands

Since this is a dotfiles repository without traditional build systems, focus is on validation and linting:

### Global Validation
```bash
# Run all linting checks
./scripts/validate.sh  # If exists, or create one

# Check all shell scripts
find . -name "*.sh" -o -name "*.zsh" | xargs shellcheck

# Check all Lua files
find . -name "*.lua" | xargs stylua --check

# Dry run installation (if safe)
bash install.sh --dry-run  # May need to modify script
```

### Single File Testing

#### Shell Scripts
```bash
# Lint a specific script
shellcheck zsh/.zshrc

# Syntax check only
bash -n install.sh

# Format check with shfmt
shfmt -d zsh/.zshrc  # Shows diff if not formatted

# Format and write back
shfmt -w zsh/.zshrc
```

#### Lua Files (Neovim configs)
```bash
# Lint specific Lua file
luacheck nvim/.config/nvim/lua/config/options.lua  # If luacheck available

# Format check
stylua --check nvim/.config/nvim/lua/plugins/ui.lua

# Format and write
stylua nvim/.config/nvim/lua/plugins/ui.lua
```

#### Configuration Files
```bash
# Validate JSON
python3 -m json.tool nvim/.config/nvim/lazyvim.json > /dev/null

# Check opencode config
jq . opencode/.config/opencode/opencode.json > /dev/null
```

### Testing Installation
```bash
# Test Zsh config loading (in subshell)
zsh -c "source zsh/.zshrc && echo 'Config loaded successfully'"

# Test Neovim startup (headless)
nvim --headless -c "lua require('config.lazy')" -c "qa" 2>&1

# Validate stow targets
stow --no --verbose zsh  # Shows what would be linked
```

## Code Style Guidelines

### General Principles

- **Language**: English for code comments and documentation, Spanish for user-facing messages (following install.sh pattern)
- **Encoding**: UTF-8, Unix line endings (LF)
- **Indentation**: 2 spaces for shell/Lua, 4 spaces for JSON
- **Line Length**: 100 characters maximum
- **No Trailing Whitespace**: Enforce with editorconfig or linting
- **Meaningful Names**: Use descriptive names, avoid abbreviations unless widely understood

### Shell Scripts (Bash/Zsh)

#### Structure
```bash
#!/bin/bash
# Description of script purpose

# Constants in UPPERCASE
readonly SCRIPT_VERSION="1.0.0"
readonly CONFIG_DIR="${HOME}/.config"

# Functions before main logic
setup_directories() {
  mkdir -p "$CONFIG_DIR"
}

main() {
  setup_directories
  # Main logic here
}

# Execute main function
main "$@"
```

#### Error Handling
```bash
# Always use set -e for scripts
set -e

# Custom error handling
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Check commands exist
command -v git >/dev/null || error_exit "git is required"

# Handle failures gracefully
if ! mkdir -p "$dir"; then
  error_exit "Failed to create directory: $dir"
fi
```

#### Variables and Constants
```bash
# Use readonly for constants
readonly BREW_PACKAGES=("git" "zsh" "neovim")

# Local variables in functions
my_function() {
  local temp_file
  temp_file=$(mktemp)
  # Use temp_file
  rm -f "$temp_file"
}
```

#### Quotes and Expansion
```bash
# Always quote variables
echo "Home directory: $HOME"
mkdir -p "$CONFIG_DIR/plugins"

# Use arrays for lists
tools=("zsh" "git" "nvim")
for tool in "${tools[@]}"; do
  echo "Installing $tool"
done
```

#### Functions
```bash
# Use snake_case for function names
install_package() {
  local package_name="$1"
  # Function body
}

# Document parameters and return values
# install_package package_name
# Installs the specified package using the system package manager
install_package() {
  # Implementation
}
```

### Lua Files (Neovim Configuration)

#### Module Structure
```lua
-- plugin_name.lua
local M = {}

-- Local functions first
local function setup_highlights()
  -- Implementation
end

-- Public API
function M.setup(opts)
  opts = opts or {}
  setup_highlights()
end

return M
```

#### Variables and Scoping
```lua
-- Use local by default
local api = vim.api
local opt = vim.opt

-- Global only when necessary (rare)
vim.g.my_plugin_setting = true

-- Constants as locals
local DEFAULT_TIMEOUT = 1000
```

#### Error Handling
```lua
-- Use pcall for potentially failing operations
local ok, result = pcall(vim.fn.system, 'git status')
if not ok then
  vim.notify('Git command failed: ' .. result, vim.log.levels.ERROR)
  return
end

-- Assert for required conditions
assert(vim.fn.executable('git') == 1, 'git is required')
```

#### Plugin Configuration
```lua
-- Follow LazyVim patterns
return {
  {
    "plugin/name",
    opts = {
      setting = true,
    },
    config = function(_, opts)
      require("plugin").setup(opts)
    end,
  },
}
```

#### Keymaps and Commands
```lua
-- Consistent keymap format
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

-- Use descriptive descriptions
vim.api.nvim_create_user_command("MyCommand", function()
  -- Implementation
end, { desc = "Description of what command does" })
```

### JSON Configuration Files

#### Formatting
```json
{
  "name": "my-config",
  "version": "1.0.0",
  "settings": {
    "enabled": true,
    "timeout": 5000
  },
  "plugins": [
    "plugin1",
    "plugin2"
  ]
}
```

#### Ordering
- Alphabetical order for object keys
- Logical grouping (metadata first, then settings, then lists)
- Consistent indentation (2 spaces)

### Imports and Dependencies

#### Lua Requires
```lua
-- Group related requires
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap

-- Plugin requires
local telescope = require("telescope")
local actions = require("telescope.actions")
```

#### Shell Sourcing
```bash
# Source library files first
source "$ZSH_LIB_DIR/path.zsh"
source "$ZSH_LIB_DIR/aliases.zsh"

# Then tool-specific configs
source "$ZSH_TOOLS_DIR/prompt.zsh"
```

## File Organization

### Directory Structure
```
.
├── install.sh              # Main installation script
├── README.md               # Documentation
├── zsh/                    # Zsh configuration
│   ├── .zshrc             # Main config
│   ├── .zsh/              # Support files
│   │   ├── lib/           # Core libraries
│   │   └── tools/         # Tool-specific configs
│   └── .zshenv            # Environment variables
├── nvim/                   # Neovim configuration
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           ├── lua/
│           │   ├── config/    # Core config
│           │   └── plugins/   # Plugin configs
│           ├── lazyvim.json
│           └── stylua.toml
└── opencode/              # AI tool configs
    └── .config/opencode/
```

### Naming Conventions
- **Directories**: lowercase, hyphens for multi-word (e.g., `my-tool`)
- **Files**: lowercase, underscores for multi-word (e.g., `lazy_load.zsh`)
- **Functions**: snake_case
- **Variables**: snake_case, UPPERCASE for constants
- **Lua modules**: snake_case

### Adding New Configurations
1. Check existing patterns in similar files
2. Follow language-specific guidelines
3. Update installation scripts if needed
4. Test in isolation before committing
5. Document any new dependencies

## Testing Guidelines

### Manual Testing Checklist

#### Zsh Configuration
- [ ] Source config without errors: `zsh -c "source ~/.zshrc"`
- [ ] All plugins load correctly
- [ ] Custom functions work
- [ ] Aliases are available
- [ ] PATH is correctly set

#### Neovim Configuration
- [ ] Starts without errors: `nvim --headless -c "qa"`
- [ ] Plugins load correctly
- [ ] Custom keymaps work
- [ ] LSP and completion function

#### Installation Script
- [ ] Runs without errors in dry-run mode
- [ ] Creates correct symlinks with stow
- [ ] Backs up existing configs
- [ ] Installs dependencies correctly

### Automated Validation
```bash
# Create a simple validation script
#!/bin/bash
set -e

echo "Validating shell scripts..."
find . -name "*.sh" -o -name "*.zsh" | while read -r file; do
  shellcheck "$file" || echo "Failed: $file"
done

echo "Validating Lua files..."
find . -name "*.lua" | while read -r file; do
  stylua --check "$file" || echo "Failed: $file"
done

echo "Validation complete"
```

## Editor/IDE Configuration

No Cursor rules (.cursor/rules/ or .cursorrules) or Copilot instructions (.github/copilot-instructions.md) found. If you add them in the future, include their contents here.

### Recommended Editor Setup
- **Shell files**: Enable shellcheck integration
- **Lua files**: Enable stylua formatting on save
- **JSON files**: Enable JSON validation and formatting
- **Line endings**: Ensure LF (Unix) for all files

## Commit Guidelines

Follow the detected repository style:
- **Language**: English
- **Style**: Plain descriptive messages (e.g., "Update nvim lazy lock and config")
- **Atomic commits**: Separate changes by concern (shell, nvim, tools)
- **Reference issues**: Include issue numbers when applicable

This ensures AI agents can maintain your dotfiles consistently and safely.</content>
<parameter name="filePath">AGENTS.md