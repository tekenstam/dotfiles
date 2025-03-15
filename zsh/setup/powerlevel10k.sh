#!/bin/bash

# Powerlevel10k Setup Script
# This script installs and configures Powerlevel10k theme for ZSH

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse command line arguments
NO_PROMPT=false

for arg in "$@"; do
  case $arg in
    --no-prompt)
      NO_PROMPT=true
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

echo -e "${BLUE}Setting up Powerlevel10k theme...${NC}"

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo -e "${BLUE}Installing Powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo -e "${GREEN}Powerlevel10k theme is already installed. Updating...${NC}"
    ( cd "$P10K_DIR" && git pull )
fi

# Install Nerd Fonts (Meslo LG) for proper Powerlevel10k rendering
install_fonts() {
    echo -e "${BLUE}Installing Meslo Nerd Font for Powerlevel10k...${NC}"
    
    FONT_DIR="$HOME/Library/Fonts"
    mkdir -p "$FONT_DIR"
    
    for variant in "Regular" "Bold" "Italic" "Bold Italic"; do
        URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${variant// /%20}.ttf"
        FILENAME="${FONT_DIR}/MesloLGS NF ${variant}.ttf"
        
        if [ ! -f "$FILENAME" ]; then
            echo -e "${BLUE}Downloading ${variant}...${NC}"
            curl -fsSL -o "$FILENAME" "$URL"
        else
            echo -e "${GREEN}Font ${variant} already installed.${NC}"
        fi
    done
    
    echo -e "${GREEN}Fonts installed. Please configure your terminal to use 'MesloLGS NF' font.${NC}"
}

# Check for macOS before installing fonts
if [[ "$OSTYPE" == "darwin"* ]]; then
    install_fonts
else
    echo -e "${YELLOW}Not on macOS. Please manually install MesloLGS NF fonts from: https://github.com/romkatv/powerlevel10k#fonts${NC}"
fi

echo -e "${GREEN}Powerlevel10k setup complete!${NC}"
echo -e "${YELLOW}After restarting your terminal, Powerlevel10k configuration wizard should start automatically.${NC}"
echo -e "${YELLOW}If not, run 'p10k configure' to set up your prompt.${NC}"
