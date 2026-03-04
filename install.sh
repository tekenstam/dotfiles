#!/bin/bash

# Dotfiles Installation Script
# This script sets up the dotfiles by creating symlinks and configuring the environment
# It handles ZSH plugins, Starship prompt, and development environment setup

# Exit on error
set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# Parse command line arguments
NO_PROMPT=false             # Skip all confirmation prompts
APPLY_MACOS_DEFAULTS=false  # Apply macOS settings automatically
SETUP_ZSH=true              # Set up ZSH plugins
DRY_RUN=false               # Preview only; no changes
LINKS_ONLY=false            # Only symlinks and .local templates; no optional setup

while [ $# -gt 0 ]; do
  case "$1" in
    --no-prompt)
      NO_PROMPT=true
      ;;
    --apply-macos-defaults)
      APPLY_MACOS_DEFAULTS=true
      ;;
    --no-zsh)
      SETUP_ZSH=false
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    --links-only)
      LINKS_ONLY=true
      NO_PROMPT=true
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

# Function to prompt for confirmation
confirm() {
  if [ "$NO_PROMPT" = true ]; then
    return 0
  fi
  
  local message=$1
  read -p "$message [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
  return 0
}

# Create backup directory (skip when dry-run)
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$BACKUP_DIR"
fi

# Function to link a file
link_file() {
    local src="$1"
    local dest="$2"
    
    if [ "$DRY_RUN" = true ]; then
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            echo "Would back up $dest to $BACKUP_DIR/$(basename "$dest")"
        fi
        echo "Would link $src to $dest"
        return
    fi
    
    # If the destination exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest to $BACKUP_DIR/$(basename "$dest")"
        mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    elif [ -L "$dest" ]; then
        # If it's already a symlink, remove it
        rm "$dest"
    fi
    
    # Create the symlink
    echo "Linking $src to $dest"
    ln -sf "$src" "$dest"
}

# Display warning and confirmation (skip when dry-run)
if [ "$DRY_RUN" = true ]; then
  echo "Dry run – no changes will be made."
else
  echo "This script will create symlinks from your home directory to the dotfiles in this repository."
  echo "It will back up any existing files with the same names to $BACKUP_DIR."
  if ! confirm "Do you want to continue?"; then
      echo "Installation canceled."
      exit 0
  fi
fi

# Install ZSH files
echo "Setting up ZSH configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"

# Starship prompt config (Git, Kubernetes, AWS)
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$HOME/.config"
fi
link_file "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"

# Setup ZSH plugins
if [ "$SETUP_ZSH" = true ]; then
    if [ -f "$DOTFILES_DIR/zsh/setup/plugins.sh" ]; then
        if [ "$NO_PROMPT" = true ] || confirm "Do you want to set up ZSH plugins? (autosuggestions, syntax-highlighting, etc.)"; then
            echo "Setting up ZSH plugins..."
            if [ "$NO_PROMPT" = true ]; then
                "$DOTFILES_DIR/zsh/setup/plugins.sh" --no-prompt
            else
                "$DOTFILES_DIR/zsh/setup/plugins.sh"
            fi
        else
            echo "Skipping ZSH plugins setup."
        fi
    fi
fi

# Install Git configuration
echo "Setting up Git configuration..."
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Set up personal config from local/ templates (not tracked in repo)
if [ ! -f "$HOME/.gitconfig.local" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "Would create ~/.gitconfig.local from template"
    else
        echo "Creating Git local config template at $HOME/.gitconfig.local"
        cp "$DOTFILES_DIR/local/git/gitconfig.local.example" "$HOME/.gitconfig.local"
        echo "Please edit ~/.gitconfig.local to set your personal Git identity."
    fi
fi
if [ ! -f "$HOME/.zshrc.local" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "Would create ~/.zshrc.local from template"
    else
        echo "Creating ZSH local config template at $HOME/.zshrc.local"
        cp "$DOTFILES_DIR/local/zsh/zshrc.local.example" "$HOME/.zshrc.local"
        echo "Edit ~/.zshrc.local for machine-specific shell settings."
    fi
fi
if [ ! -f "$HOME/.vimrc.local" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "Would create ~/.vimrc.local from template"
    else
        echo "Creating Vim local config template at $HOME/.vimrc.local"
        cp "$DOTFILES_DIR/local/vim/vimrc.local.example" "$HOME/.vimrc.local"
        echo "Edit ~/.vimrc.local for personal Vim preferences."
    fi
fi

# Install Vim configuration
echo "Setting up Vim configuration..."
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$HOME/.vim"
fi

# Install bin scripts
echo "Setting up bin scripts..."
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$HOME/bin"
fi
for script in "$DOTFILES_DIR/bin"/*; do
    if [ -f "$script" ]; then
        link_file "$script" "$HOME/bin/$(basename "$script")"
    fi
done

# Dry run stops here
if [ "$DRY_RUN" = true ]; then
  echo "Dry run complete. No changes were made."
  exit 0
fi

# Optional setup (skipped when --links-only)
if [ "$LINKS_ONLY" = false ]; then

# macOS specific setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up macOS specific configurations..."
    
    # Install Homebrew and packages
    if [ -f "$DOTFILES_DIR/macos/brew.sh" ]; then
        if [ "$NO_PROMPT" = true ] || confirm "Do you want to install Homebrew and common packages?"; then
            echo "Installing Homebrew and packages..."
            if [ "$NO_PROMPT" = true ]; then
                "$DOTFILES_DIR/macos/brew.sh" --install-brew --core --dev --no-prompt
            else
                "$DOTFILES_DIR/macos/brew.sh"
            fi
        else
            echo "Skipping Homebrew installation."
        fi
    fi
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        if confirm "Homebrew not found. Would you like to install it?"; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
    
    # Apply macOS settings
    if [ -f "$DOTFILES_DIR/macos/defaults.sh" ]; then
        if [ "$APPLY_MACOS_DEFAULTS" = true ] || confirm "Do you want to apply macOS settings? This will modify your system preferences."; then
            echo "Applying macOS settings..."
            if [ "$NO_PROMPT" = true ]; then
                bash "$DOTFILES_DIR/macos/defaults.sh" --no-prompt
            else
                bash "$DOTFILES_DIR/macos/defaults.sh"
            fi
        else
            echo "Skipping macOS settings."
        fi
    fi
fi

# Setup architecture-specific environment
if [ -f "$DOTFILES_DIR/zsh/functions/system-utils.zsh" ]; then
    source "$DOTFILES_DIR/zsh/functions/system-utils.zsh"
    echo "Setting up architecture-specific environment..."
    setup_arch_env
fi

# Development environment setup
if [ -d "$DOTFILES_DIR/setup" ]; then
    echo -e "\n======================================="
    echo "Development Environment Setup"
    echo "======================================="
    
    # Go setup
    if [ "$NO_PROMPT" = true ] || confirm "Do you want to set up Go development environment?"; then
        echo "Setting up Go development environment..."
        "$DOTFILES_DIR/setup/go.sh" --install-go --install-tools
    else
        echo "Skipping Go setup."
    fi
    
    # Python setup
    if [ "$NO_PROMPT" = true ] || confirm "Do you want to set up Python development environment?"; then
        echo "Setting up Python development environment..."
        "$DOTFILES_DIR/setup/python.sh" --install-pyenv --install-tools
    else
        echo "Skipping Python setup."
    fi
    
    # Node.js setup (not included in --no-prompt default)
    if [ "$NO_PROMPT" = false ] && confirm "Do you want to set up Node.js development environment?"; then
        echo "Setting up Node.js development environment..."
        "$DOTFILES_DIR/setup/node.sh" --install-node --install-tools
    else
        echo "Skipping Node.js setup."
    fi
fi

fi
# end optional setup (LINKS_ONLY)

echo "Installation complete! You may need to restart your terminal for all changes to take effect."
