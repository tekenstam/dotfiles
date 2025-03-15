#!/bin/bash

# Exit on error
set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# Parse command line arguments
NO_PROMPT=false
APPLY_MACOS_DEFAULTS=false
SETUP_ZSH=true
SETUP_POWERLEVEL10K=true

for arg in "$@"; do
  case $arg in
    --no-prompt)
      NO_PROMPT=true
      shift
      ;;
    --apply-macos-defaults)
      APPLY_MACOS_DEFAULTS=true
      shift
      ;;
    --no-zsh)
      SETUP_ZSH=false
      shift
      ;;
    --no-p10k)
      SETUP_POWERLEVEL10K=false
      shift
      ;;
  esac
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

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to link a file
link_file() {
    local src="$1"
    local dest="$2"
    
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

# Display warning and confirmation
echo "This script will create symlinks from your home directory to the dotfiles in this repository."
echo "It will back up any existing files with the same names to $BACKUP_DIR."
if ! confirm "Do you want to continue?"; then
    echo "Installation canceled."
    exit 0
fi

# Install ZSH files
echo "Setting up ZSH configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Setup ZSH plugins and Powerlevel10k
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

if [ "$SETUP_POWERLEVEL10K" = true ]; then
    if [ -f "$DOTFILES_DIR/zsh/setup/powerlevel10k.sh" ]; then
        if [ "$NO_PROMPT" = true ] || confirm "Do you want to set up Powerlevel10k theme?"; then
            echo "Setting up Powerlevel10k theme..."
            if [ "$NO_PROMPT" = true ]; then
                "$DOTFILES_DIR/zsh/setup/powerlevel10k.sh" --no-prompt
            else
                "$DOTFILES_DIR/zsh/setup/powerlevel10k.sh"
            fi
        else
            echo "Skipping Powerlevel10k setup."
        fi
    fi
fi

# Install Git configuration
echo "Setting up Git configuration..."
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Set up personal Git configuration if not already present
if [ ! -f "$HOME/.gitconfig.local" ]; then
    echo "Creating Git local config template at $HOME/.gitconfig.local"
    cp "$DOTFILES_DIR/git/.gitconfig.local.example" "$HOME/.gitconfig.local"
    echo "Please edit ~/.gitconfig.local to set your personal Git identity."
fi

# Install Vim configuration
echo "Setting up Vim configuration..."
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.vim"

# Install bin scripts
echo "Setting up bin scripts..."
mkdir -p "$HOME/bin"
for script in "$DOTFILES_DIR/bin"/*; do
    if [ -f "$script" ]; then
        link_file "$script" "$HOME/bin/$(basename "$script")"
    fi
done

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

echo "Installation complete! You may need to restart your terminal for all changes to take effect."
