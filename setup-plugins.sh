#!/bin/bash

# Exit on error
set -e

echo "Setting up ZSH plugins and Powerlevel10k theme..."

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "ZSH is not installed. Please install ZSH first."
    exit 1
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k theme is already installed. Updating..."
    ( cd "$P10K_DIR" && git pull )
fi

# Install required plugins
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# Install zsh-autosuggestions
if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
else
    echo "zsh-autosuggestions is already installed. Updating..."
    ( cd "$PLUGIN_DIR/zsh-autosuggestions" && git pull )
fi

# Install zsh-syntax-highlighting
if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting is already installed. Updating..."
    ( cd "$PLUGIN_DIR/zsh-syntax-highlighting" && git pull )
fi

# Install Nerd Fonts (Meslo LG) for proper Powerlevel10k rendering
install_fonts() {
    echo "Installing Meslo Nerd Font for Powerlevel10k..."
    
    FONT_DIR="$HOME/Library/Fonts"
    mkdir -p "$FONT_DIR"
    
    for variant in "Regular" "Bold" "Italic" "Bold Italic"; do
        URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${variant// /%20}.ttf"
        FILENAME="${FONT_DIR}/MesloLGS NF ${variant}.ttf"
        
        if [ ! -f "$FILENAME" ]; then
            echo "Downloading ${variant}..."
            curl -fsSL -o "$FILENAME" "$URL"
        else
            echo "Font ${variant} already installed."
        fi
    done
    
    echo "Fonts installed. Please configure your terminal to use 'MesloLGS NF' font."
}

# Check for macOS before installing fonts
if [[ "$OSTYPE" == "darwin"* ]]; then
    install_fonts
else
    echo "Not on macOS. Please manually install MesloLGS NF fonts from: https://github.com/romkatv/powerlevel10k#fonts"
fi

# Install kubectl plugin for Oh My Zsh if not already available
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}/plugins/kubectl" ]; then
    echo "The kubectl plugin is included with Oh My Zsh by default."
    echo "If it's missing, your Oh My Zsh installation might be outdated."
    echo "Consider running: 'omz update'"
fi

# Install kubectx and kubens commands if not already available
if ! command -v kubectx &> /dev/null; then
    echo "Installing kubectx and kubens..."
    if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
        brew install kubectx
    else
        KUBECTX_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/kubectx"
        if [ ! -d "$KUBECTX_DIR" ]; then
            git clone https://github.com/ahmetb/kubectx.git "$KUBECTX_DIR"
            # Create symlinks to make kubectx/kubens available
            mkdir -p "$HOME/bin"
            ln -sf "$KUBECTX_DIR/kubectx" "$HOME/bin/kubectx"
            ln -sf "$KUBECTX_DIR/kubens" "$HOME/bin/kubens"
            echo "Added kubectx and kubens to ~/bin. Make sure it's in your PATH."
        fi
    fi
else
    echo "kubectx is already installed."
fi

# Install AWS CLI if not already available
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. We recommend installing it:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  For macOS: brew install awscli"
    else
        echo "  Visit: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    fi
fi

echo "Setup complete! You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
echo "After restarting, Powerlevel10k configuration wizard should start automatically."
echo "If not, run 'p10k configure' to set up your prompt."
