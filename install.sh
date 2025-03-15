#!/bin/bash

# Exit on error
set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

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

# Install ZSH files
echo "Setting up ZSH configuration..."
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

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
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Would you like to install it? (y/n)"
        read -r install_homebrew
        if [[ "$install_homebrew" =~ ^[Yy]$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
    
    # Apply macOS settings
    if [ -f "$DOTFILES_DIR/macos/defaults.sh" ]; then
        echo "Applying macOS settings..."
        bash "$DOTFILES_DIR/macos/defaults.sh"
    fi
fi

echo "Installation complete! You may need to restart your terminal for all changes to take effect."
