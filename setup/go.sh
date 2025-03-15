#!/bin/bash

# Go setup script
# Sets up Go development environment with tools and configuration

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse command line arguments
INSTALL_GO=false
INSTALL_TOOLS=false
NO_PROMPT=false

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
    --no-prompt)
      NO_PROMPT=true
      shift
      ;;
    --all)
      INSTALL_GO=true
      INSTALL_TOOLS=true
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

# Check if Go is installed
check_go() {
  if command -v go >/dev/null 2>&1; then
    echo -e "${GREEN}Go is already installed:${NC} $(go version)"
    return 0
  else
    echo -e "${YELLOW}Go is not installed.${NC}"
    return 1
  fi
}

# Install Go using Homebrew
install_go() {
  echo -e "${BLUE}Installing Go...${NC}"
  
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${RED}Homebrew is required but not installed.${NC}"
    echo -e "Please install Homebrew first: https://brew.sh/"
    exit 1
  fi
  
  brew install go
  
  echo -e "${GREEN}Go installed successfully:${NC} $(go version)"
}

# Setup Go environment
setup_go_env() {
  echo -e "${BLUE}Setting up Go environment...${NC}"
  
  # Create Go workspace directories
  mkdir -p "$HOME/go/"{bin,src,pkg}
  
  # Add Go environment to zshrc if not already present
  if ! grep -q "GOPATH" ~/.zshrc.local 2>/dev/null; then
    cat > ~/.zshrc.local.tmp << EOF
# Go configuration
export GOPATH=\$HOME/go
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:\$GOBIN
EOF
    
    if [ -f ~/.zshrc.local ]; then
      cat ~/.zshrc.local >> ~/.zshrc.local.tmp
    fi
    
    mv ~/.zshrc.local.tmp ~/.zshrc.local
    echo -e "${GREEN}Added Go environment to ~/.zshrc.local${NC}"
  else
    echo -e "${GREEN}Go environment already configured in ~/.zshrc.local${NC}"
  fi
}

# Install common Go tools
install_go_tools() {
  echo -e "${BLUE}Installing Go tools...${NC}"
  
  # List of useful Go tools
  local tools=(
    "golang.org/x/tools/gopls@latest"                   # Go language server
    "github.com/go-delve/delve/cmd/dlv@latest"          # Debugger
    "github.com/fatih/gomodifytags@latest"              # Modify struct tags
    "github.com/josharian/impl@latest"                  # Generate interface stubs
    "github.com/cweill/gotests/gotests@latest"          # Generate tests
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" # Linter
    "github.com/cosmtrek/air@latest"                    # Live reload
    "github.com/mikefarah/yq/v4@latest"                 # YAML processor
  )
  
  for tool in "${tools[@]}"; do
    echo -e "${BLUE}Installing ${tool}...${NC}"
    go install "${tool}"
  done
  
  echo -e "${GREEN}Go tools installed successfully!${NC}"
}

# Main script logic
echo -e "${BLUE}Go Development Environment Setup${NC}"
echo -e "===============================\n"

# Check if Go is installed
if ! check_go; then
  if [ "$INSTALL_GO" = true ] || confirm "Do you want to install Go?"; then
    install_go
    setup_go_env
  else
    echo -e "${YELLOW}Skipping Go installation.${NC}"
    exit 0
  fi
else
  setup_go_env
fi

# Install Go tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install common Go tools?"; then
  install_go_tools
else
  echo -e "${YELLOW}Skipping Go tools installation.${NC}"
fi

echo -e "\n${GREEN}Go setup complete!${NC}"
echo -e "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
