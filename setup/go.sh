#!/bin/bash

# Go Development Environment Setup
# -------------------------------
# This script installs Go and sets up a complete development environment
# including GOPATH configuration and essential Go tools
#
# Usage:
#   ./setup/go.sh                    # Interactive installation
#   ./setup/go.sh --all              # Install everything
#   ./setup/go.sh --install-go       # Only install Go
#   ./setup/go.sh --install-tools    # Only install Go tools
#   ./setup/go.sh --no-prompt        # Non-interactive installation
#
# Author: tekenstam
# Last Updated: 2025-03-15

set -e

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Parse command line arguments
INSTALL_GO=false
INSTALL_TOOLS=false

for arg in "$@"; do
  case $arg in
    --install-go)
      INSTALL_GO=true
      shift
      ;;
    --install-tools)
      INSTALL_TOOLS=true
      shift
      ;;
    --all)
      INSTALL_GO=true
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

# Check if Go is installed
check_go() {
  if command_exists go; then
    print_success "Go is already installed: $(go version)"
    return 0
  else
    print_warning "Go is not installed."
    return 1
  fi
}

# Install Go using Homebrew
install_go() {
  print_section "Installing Go"
  
  ensure_homebrew || return 1
  
  brew install go
  
  print_success "Go installed successfully: $(go version)"
}

# Setup Go environment
setup_go_env() {
  print_section "Setting up Go environment"
  
  # Create Go workspace directories
  mkdir -p "$HOME/go/"{bin,src,pkg}
  
  # Add Go environment to zshrc.local
  add_to_zshrc_local "# Go configuration" "export GOPATH=\$HOME/go"
  add_to_zshrc_local "# Go configuration" "export GOBIN=\$GOPATH/bin"
  add_to_zshrc_local "# Go configuration" "export PATH=\$PATH:\$GOBIN"
}

# Install common Go tools
install_go_tools() {
  print_section "Installing Go tools"
  
  # List of useful Go tools
  local tools=(
    "golang.org/x/tools/gopls@latest"                   # Go language server
    "github.com/go-delve/delve/cmd/dlv@latest"          # Debugger
    "github.com/fatih/gomodifytags@latest"              # Modify struct tags
    "github.com/josharian/impl@latest"                  # Generate interface stubs
    "github.com/cweill/gotests/gotests@latest"          # Generate tests
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" # Linter
    "github.com/air-verse/air@latest"                   # Live reload (formerly cosmtrek/air)
    "github.com/mikefarah/yq/v4@latest"                 # YAML processor
  )
  
  for tool in "${tools[@]}"; do
    echo -e "${BLUE}Installing ${tool}...${NC}"
    go install "${tool}"
  done
  
  print_success "Go tools installed successfully!"
}

# Main script logic
print_section "Go Development Environment Setup"

# Check if Go is installed
if ! check_go; then
  if [ "$INSTALL_GO" = true ] || confirm "Do you want to install Go?"; then
    install_go
    setup_go_env
  else
    print_warning "Skipping Go installation."
    exit 0
  fi
else
  setup_go_env
fi

# Install Go tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install common Go tools?"; then
  install_go_tools
else
  print_warning "Skipping Go tools installation."
fi

print_completion "Go" "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
