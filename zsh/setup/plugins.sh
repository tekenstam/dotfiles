#!/bin/bash

# ZSH Plugins Setup Script
# -----------------------
# This script installs and configures Oh My Zsh and essential ZSH plugins
# including syntax highlighting, autosuggestions, and kubectl integration
#
# Usage:
#   ./zsh/setup/plugins.sh           # Interactive installation
#   ./zsh/setup/plugins.sh --no-prompt  # Non-interactive installation
#
# Author: tekenstam
# Last Updated: 2025-03-15

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

echo -e "${BLUE}Setting up ZSH plugins...${NC}"

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}ZSH is not installed. Please install ZSH first.${NC}"
    exit 1
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh My Zsh is already installed.${NC}"
fi

# Install required plugins
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# Install zsh-autosuggestions
if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    echo -e "${BLUE}Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
else
    echo -e "${GREEN}zsh-autosuggestions is already installed. Updating...${NC}"
    ( cd "$PLUGIN_DIR/zsh-autosuggestions" && git pull )
fi

# Install zsh-syntax-highlighting
if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    echo -e "${BLUE}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
else
    echo -e "${GREEN}zsh-syntax-highlighting is already installed. Updating...${NC}"
    ( cd "$PLUGIN_DIR/zsh-syntax-highlighting" && git pull )
fi

# Install kubectl plugin for Oh My Zsh if not already available
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}/plugins/kubectl" ]; then
    echo -e "${YELLOW}The kubectl plugin is included with Oh My Zsh by default.${NC}"
    echo -e "${YELLOW}If it's missing, your Oh My Zsh installation might be outdated.${NC}"
    echo -e "${YELLOW}Consider running: 'omz update'${NC}"
fi

# Install kubectx and kubens commands if not already available
if ! command -v kubectx &> /dev/null; then
    echo -e "${BLUE}Installing kubectx and kubens...${NC}"
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
            echo -e "${YELLOW}Added kubectx and kubens to ~/bin. Make sure it's in your PATH.${NC}"
        fi
    fi
else
    echo -e "${GREEN}kubectx is already installed.${NC}"
fi

# Install AWS CLI if not already available
if ! command -v aws &> /dev/null; then
    echo -e "${YELLOW}AWS CLI not found. We recommend installing it:${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "  For macOS: brew install awscli"
    else
        echo -e "  Visit: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    fi
fi

echo -e "${GREEN}ZSH plugins setup complete!${NC}"
