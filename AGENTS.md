# AGENTS.md - Guidelines for AI Agents Working on phardev.dot

This file contains guidelines for AI coding agents (such as opencode agents) working on this dotfiles repository. It ensures consistency across Fish shell configurations, Neovim setup, installation scripts, and related tools.

## Repository Overview

This is a personal dotfiles repository containing:

- Fish shell configuration with plugins and tools
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
find . -name "*.sh" | xargs shellcheck

# Check all Fish scripts
find . -name "*.fish" | xargs fish --print-debug-level 0 -c "source {}" 2>&1 | grep -E "(error|Error)"

# Check all Lua files
find . -name "*.lua" | xargs stylua --check

# Validate JSON files
find . -name "*.json" | xargs python3 -m json.tool > /dev/null
```

### Single File Testing

#### Shell Scripts

```bash
# Lint a specific script
shellcheck install.sh

# Syntax check only
bash -n install.sh
```

#### Fish Scripts

```bash
# Syntax check a fish function
fish -n fish/.config/fish/functions/aliases.fish

# Test fish config loading
fish -c "source fish/.config/fish/config.fish && echo 'Config loaded successfully'"
```

#### Lua Files (Neovim configs)

```bash
# Lint specific Lua file
stylua --check nvim/.config/nvim/lua/config/options.lua

# Format and write
stylua nvim/.config/nvim/lua/plugins/ui.lua
```

#### Configuration Files

```bash
# Validate JSON
python3 -m json.tool opencode/.config/opencode/opencode.json > /dev/null

# Check fish plugins file
fish -c "fisher list" 2>/dev/null || echo "Fisher plugins need validation"
```

### Testing Installation

```bash
# Test Fish config loading
fish -c "source ~/.config/fish/config.fish && echo 'Config loaded successfully'"

# Test Neovim startup (headless)
nvim --headless -c "lua require('config.lazy')" -c "qa"

# Validate stow targets
stow --no --verbose fish  # Shows what would be linked

# Test fisher plugins
fish -c "fisher list"
```

## Code Style Guidelines

### General Principles

- **Language**: English for code comments and documentation, Spanish for user-facing messages (following install.sh pattern)
- **Encoding**: UTF-8, Unix line endings (LF)
- **Indentation**: 2 spaces for shell/Lua, 4 spaces for JSON
- **Line Length**: 100 characters maximum
- **No Trailing Whitespace**: Enforce with editorconfig or linting
- **Meaningful Names**: Use descriptive names, avoid abbreviations unless widely understood

### Fish Shell Scripts

#### Structure

```fish
# Description of script purpose

# Constants in UPPERCASE
set -g SCRIPT_VERSION "1.0.0"
set -g CONFIG_DIR "$HOME/.config"

# Functions before main logic
function setup_directories
    mkdir -p $CONFIG_DIR
end

function main
    setup_directories
    # Main logic here
end

# Execute main function
main $argv
```

#### Error Handling

```fish
# Use status for exit codes
function setup_directories
    if not mkdir -p $dir
        echo "Error: Failed to create directory: $dir" >&2
        return 1
    end
end

# Check commands exist
if not command -v git >/dev/null
    echo "Error: git is required" >&2
    exit 1
end
```

#### Variables and Scoping

```fish
# Global variables with -g
set -g CONFIG_DIR "$HOME/.config"

# Local variables in functions (default)
function my_function
    set temp_file (mktemp)
    # Use temp_file
    rm -f $temp_file
end
```

#### Functions

```fish
# Use snake_case for function names
function install_package --description "Install package using system package manager"
    set package_name $argv[1]
    # Function body
end

# Document parameters with --description
function setup_config --description "Setup configuration with backup"
    # Implementation
end
```

#### String Handling

```fish
# Always quote variables
echo "Home directory: $HOME"
mkdir -p "$CONFIG_DIR/plugins"

# Use arrays for lists
set tools zsh git nvim
for tool in $tools
    echo "Installing $tool"
end
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
  "plugins": ["plugin1", "plugin2"]
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

#### Fish Sourcing

```fish
# Source function files first
source "$FISH_FUNCTIONS_DIR/aliases.fish"
source "$FISH_FUNCTIONS_DIR/navigation.fish"

# Then tool-specific configs
source "$FISH_CONFIG_DIR/conf.d/fzf.fish"
```

## File Organization

### Directory Structure

```
.
├── install.sh              # Main installation script
├── README.md               # Documentation
├── fish/                   # Fish configuration
│   └── .config/
│       └── fish/
│           ├── config.fish
│           ├── fish_plugins
│           ├── functions/   # Core functions
│           ├── completions/ # Completions
│           └── conf.d/      # Configuration snippets
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
- **Files**: lowercase, underscores for multi-word (e.g., `fish_prompt.fish`)
- **Functions**: snake_case for Fish functions, camelCase for Lua
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

#### Fish Configuration

- [ ] Source config without errors: `fish -c "source ~/.config/fish/config.fish"`
- [ ] All functions load correctly
- [ ] Plugins work (fisher list)
- [ ] PATH is correctly set
- [ ] Aliases are available

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
find . -name "*.sh" | while read -r file; do
  shellcheck "$file" || echo "Failed: $file"
done

echo "Validating Fish scripts..."
find . -name "*.fish" | while read -r file; do
  if fish -n "$file"; then
    echo "OK: $file"
  else
    echo "Failed: $file"
  fi
done

echo "Validating Lua files..."
find . -name "*.lua" | while read -r file; do
  stylua --check "$file" || echo "Failed: $file"
done

echo "Validation complete"
```

## Available Skills

| Skill | Description | Documentation |
|-------|-------------|---------------|
| `safe-refactor` | Performs safe code refactoring with comprehensive safety measures | [SKILL.md](opencode/.config/opencode/skills/safe-refactor/SKILL.md) |
| `command-creator` | Creates new opencode command files with proper structure | [SKILL.md](opencode/.config/opencode/skills/command-creator/SKILL.md) |
| `git-master` | Advanced git operations and version control management | [SKILL.md](opencode/.config/opencode/skills/git-master/SKILL.md) |
| `react-19` | React 19 patterns with React Compiler | [SKILL.md](opencode/.config/opencode/skills/react-19/SKILL.md) |
| `shadcn` | Manages shadcn/ui components installation and usage | [SKILL.md](opencode/.config/opencode/skills/shadcn/SKILL.md) |
| `skill-creator` | Creates new AI agent skills following the Agent Skills spec | [SKILL.md](opencode/.config/opencode/skills/skill-creator/SKILL.md) |
| `tailwind` | Tailwind CSS patterns and best practices | [SKILL.md](opencode/.config/opencode/skills/tailwind/SKILL.md) |
| `typescript` | TypeScript strict patterns and best practices | [SKILL.md](opencode/.config/opencode/skills/typescript/SKILL.md) |

## Editor/IDE Configuration

No Cursor rules (.cursor/rules/ or .cursorrules) or Copilot instructions (.github/copilot-instructions.md) found. If you add them in the future, include their contents here.

### Recommended Editor Setup

- **Shell files**: Enable shellcheck integration
- **Fish files**: Enable fish syntax highlighting
- **Lua files**: Enable stylua formatting on save
- **JSON files**: Enable JSON validation and formatting
- **Line endings**: Ensure LF (Unix) for all files

## Commit Guidelines

Follow the detected repository style:

- **Language**: English
- **Style**: Plain descriptive messages (e.g., "Update nvim lazy lock and config")
- **Atomic commits**: Separate changes by concern (fish, nvim, tools)
- **Reference issues**: Include issue numbers when applicable

This ensures AI agents can maintain your dotfiles consistently and safely.</content>
<parameter name="filePath">/home/test/phardev.dot/AGENTS.md