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

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Node version to install (if not already installed)
DEFAULT_NODE_VERSION="18"

# Parse command line arguments
INSTALL_NODE=false
INSTALL_TOOLS=false
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
    --node-version=*)
      NODE_VERSION="${arg#*=}"
      shift
      ;;
    --all)
      INSTALL_NODE=true
      INSTALL_TOOLS=true
      shift
      ;;
    --no-prompt)
      # Handled by common.sh
      shift
      ;;
    *)
      # Skip unknown arguments
      shift
      ;;
  esac
done

# Parse common arguments (e.g., --no-prompt)
parse_common_args "$@"

# Check if Node.js is installed
check_node() {
  if command_exists node; then
    print_success "Node.js is already installed: $(node --version)"
    return 0
  else
    print_warning "Node.js is not installed."
    return 1
  fi
}

# Install Node.js using NVM
install_node() {
  print_section "Installing Node.js"
  
  # Check if NVM is installed
  if [ ! -d "$HOME/.nvm" ]; then
    print_warning "NVM is not installed. Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    
    # Set up NVM environment variables for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  else
    print_success "NVM is already installed."
    # Set up NVM for the current session if not already set
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi
  
  # Install and use the specified Node.js version
  print_warning "Installing Node.js version $NODE_VERSION..."
  nvm install "$NODE_VERSION"
  nvm use "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
  
  print_success "Node.js v$NODE_VERSION installed successfully!"
}

# Setup Node.js environment
setup_node_env() {
  print_section "Setting up Node.js environment"
  
  # Add NVM to zshrc.local
  add_to_zshrc_local "# NVM configuration" "export NVM_DIR=\"\$HOME/.nvm\""
  add_to_zshrc_local "# NVM configuration" "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"  # This loads nvm"
  add_to_zshrc_local "# NVM configuration" "[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion"
  
  # Create a default .npmrc file if it doesn't exist
  if [ ! -f ~/.npmrc ]; then
    cat > ~/.npmrc << EOF
# NPM configuration
progress=false
save-exact=true
EOF
    print_success "Created .npmrc with default settings"
  fi
}

# Install common Node.js tools
install_node_tools() {
  print_section "Installing Node.js tools"
  
  # List of useful Node.js global packages
  local packages=(
    "typescript"             # TypeScript compiler
    "ts-node"                # Run TypeScript directly
    "eslint"                 # Linter
    "prettier"               # Code formatter
    "nodemon"                # Auto-restart for development
    "npm-check-updates"      # Check for dependency updates
    "yarn"                   # Alternative package manager
  )
  
  for package in "${packages[@]}"; do
    echo -e "${BLUE}Installing ${package}...${NC}"
    npm install -g "${package}"
  done
  
  print_success "Node.js tools installed successfully!"
}

# Main script logic
print_section "Node.js Development Environment Setup"

# Check if Node.js is installed
if ! check_node; then
  if [ "$INSTALL_NODE" = true ] || confirm "Do you want to install Node.js v$NODE_VERSION using NVM?"; then
    install_node
    setup_node_env
  else
    print_warning "Skipping Node.js installation."
    exit 0
  fi
else
  setup_node_env
fi

# Install Node.js tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install common Node.js tools?"; then
  install_node_tools
else
  print_warning "Skipping Node.js tools installation."
fi

print_completion "Node.js" "You may need to restart your terminal or run 'source ~/.zshrc' for NVM to be fully activated."
