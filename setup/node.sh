#!/bin/bash

# Node.js Development Environment Setup
# -----------------------------------
# This script installs Node.js via NVM and sets up a complete
# development environment with common tools and packages
#
# Usage:
#   ./setup/node.sh                        # Interactive installation
#   ./setup/node.sh --all                  # Install everything
#   ./setup/node.sh --install-node         # Only install Node.js
#   ./setup/node.sh --install-tools        # Only install Node.js tools
#   ./setup/node.sh --node-version=18      # Specify Node.js version
#   ./setup/node.sh --no-prompt            # Non-interactive installation
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

# Node version to install (if not already installed)
DEFAULT_NODE_VERSION="18"

# Parse command line arguments
INSTALL_NODE=false
INSTALL_TOOLS=false
NO_PROMPT=false
NODE_VERSION="$DEFAULT_NODE_VERSION"

for arg in "$@"; do
  case $arg in
    --install-node)
      INSTALL_NODE=true
      shift
      ;;
    --install-tools)
      INSTALL_TOOLS=true
      shift
      ;;
    --no-prompt)
      NO_PROMPT=true
      shift
      ;;
    --all)
      INSTALL_NODE=true
      INSTALL_TOOLS=true
      shift
      ;;
    --node-version=*)
      NODE_VERSION="${arg#*=}"
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

# Check if Node.js is installed
check_node() {
  if command -v node >/dev/null 2>&1; then
    echo -e "${GREEN}Node.js is already installed:${NC} $(node --version)"
    return 0
  else
    echo -e "${YELLOW}Node.js is not installed.${NC}"
    return 1
  fi
}

# Install Node.js using NVM
install_node() {
  echo -e "${BLUE}Installing Node.js v$NODE_VERSION using NVM...${NC}"
  
  # Check if NVM is installed
  if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${BLUE}Installing NVM...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  else
    echo -e "${GREEN}NVM is already installed.${NC}"
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi
  
  # Install Node.js
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
  nvm use default
  
  echo -e "${GREEN}Node.js v$NODE_VERSION installed successfully:${NC} $(node --version)"
}

# Setup Node.js environment
setup_node_env() {
  echo -e "${BLUE}Setting up Node.js environment...${NC}"
  
  # Add NVM initialization to zshrc if not already present
  if ! grep -q "NVM_DIR" ~/.zshrc.local 2>/dev/null; then
    cat > ~/.zshrc.local.tmp << EOF
# NVM configuration
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    
    if [ -f ~/.zshrc.local ]; then
      cat ~/.zshrc.local >> ~/.zshrc.local.tmp
    fi
    
    mv ~/.zshrc.local.tmp ~/.zshrc.local
    echo -e "${GREEN}Added NVM environment to ~/.zshrc.local${NC}"
  else
    echo -e "${GREEN}NVM environment already configured in ~/.zshrc.local${NC}"
  fi
  
  # Create .npmrc file with useful defaults if it doesn't exist
  if [ ! -f ~/.npmrc ]; then
    cat > ~/.npmrc << EOF
save-exact=true
fund=false
audit=false
EOF
    echo -e "${GREEN}Created ~/.npmrc with sensible defaults${NC}"
  fi
}

# Install common Node.js tools
install_node_tools() {
  echo -e "${BLUE}Installing Node.js tools...${NC}"
  
  # List of useful global Node.js packages
  local packages=(
    "npm@latest"              # npm itself
    "yarn"                    # Yarn package manager
    "typescript"              # TypeScript
    "ts-node"                 # TypeScript execution environment
    "eslint"                  # Linting
    "prettier"                # Code formatting
    "nodemon"                 # Auto-restart for development
    "http-server"             # Simple HTTP server
    "npm-check-updates"       # Check for package updates
  )
  
  for package in "${packages[@]}"; do
    echo -e "${BLUE}Installing ${package}...${NC}"
    npm install -g "${package}"
  done
  
  echo -e "${GREEN}Node.js tools installed successfully!${NC}"
}

# Main script logic
echo -e "${BLUE}Node.js Development Environment Setup${NC}"
echo -e "====================================\n"

# Check if Node.js is installed
if ! check_node; then
  if [ "$INSTALL_NODE" = true ] || confirm "Do you want to install Node.js v$NODE_VERSION?"; then
    install_node
  else
    echo -e "${YELLOW}Skipping Node.js installation.${NC}"
    exit 0
  fi
fi

# Setup Node.js environment
setup_node_env

# Install Node.js tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install common Node.js tools?"; then
  install_node_tools
else
  echo -e "${YELLOW}Skipping Node.js tools installation.${NC}"
fi

echo -e "\n${GREEN}Node.js setup complete!${NC}"
echo -e "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
