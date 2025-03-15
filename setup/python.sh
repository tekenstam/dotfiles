#!/bin/bash

# Python setup script
# Sets up Python development environment with virtual environments and tools

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Python version to install (if using pyenv)
DEFAULT_PYTHON_VERSION="3.11.5"

# Parse command line arguments
INSTALL_PYENV=false
INSTALL_TOOLS=false
NO_PROMPT=false
PYTHON_VERSION="$DEFAULT_PYTHON_VERSION"

for arg in "$@"; do
  case $arg in
    --install-pyenv)
      INSTALL_PYENV=true
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
      INSTALL_PYENV=true
      INSTALL_TOOLS=true
      shift
      ;;
    --python-version=*)
      PYTHON_VERSION="${arg#*=}"
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

# Check if Python is installed
check_python() {
  if command -v python3 >/dev/null 2>&1; then
    echo -e "${GREEN}Python is already installed:${NC} $(python3 --version)"
    return 0
  else
    echo -e "${YELLOW}Python 3 is not installed.${NC}"
    return 1
  fi
}

# Install pyenv for managing Python versions
install_pyenv() {
  echo -e "${BLUE}Installing pyenv...${NC}"
  
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${RED}Homebrew is required but not installed.${NC}"
    echo -e "Please install Homebrew first: https://brew.sh/"
    exit 1
  fi
  
  # Install pyenv via Homebrew
  brew install pyenv
  
  # Install Python build dependencies
  brew install openssl readline sqlite3 xz zlib tcl-tk
  
  # Install Python using pyenv
  echo -e "${BLUE}Installing Python $PYTHON_VERSION using pyenv...${NC}"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  
  pyenv install "$PYTHON_VERSION"
  pyenv global "$PYTHON_VERSION"
  
  echo -e "${GREEN}Python $PYTHON_VERSION installed successfully:${NC} $(python --version)"
}

# Setup Python environment
setup_python_env() {
  echo -e "${BLUE}Setting up Python environment...${NC}"
  
  # Create projects directory for virtual environments
  mkdir -p "$HOME/Projects/python_envs"
  
  # Add pyenv initialization to zshrc if not already present
  if ! grep -q "pyenv init" ~/.zshrc.local 2>/dev/null; then
    cat > ~/.zshrc.local.tmp << EOF
# pyenv configuration
export PYENV_ROOT="\$HOME/.pyenv"
export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"

# Python aliases
alias py="python3"
alias python="python3"
alias pip="pip3"
alias venv="python3 -m venv"
alias activate="source ./venv/bin/activate"
alias mkvenv="python3 -m venv venv && source ./venv/bin/activate"
EOF
    
    if [ -f ~/.zshrc.local ]; then
      cat ~/.zshrc.local >> ~/.zshrc.local.tmp
    fi
    
    mv ~/.zshrc.local.tmp ~/.zshrc.local
    echo -e "${GREEN}Added Python environment to ~/.zshrc.local${NC}"
  else
    echo -e "${GREEN}Python environment already configured in ~/.zshrc.local${NC}"
  fi
  
  # Create pip.conf with useful defaults if it doesn't exist
  mkdir -p ~/.config/pip
  if [ ! -f ~/.config/pip/pip.conf ]; then
    cat > ~/.config/pip/pip.conf << EOF
[global]
require-virtualenv = false
timeout = 60
index-url = https://pypi.org/simple
trusted-host = pypi.org
               pypi.python.org
               files.pythonhosted.org

[install]
upgrade-strategy = only-if-needed
EOF
    echo -e "${GREEN}Created pip.conf with sensible defaults${NC}"
  fi
}

# Install common Python tools
install_python_tools() {
  echo -e "${BLUE}Installing Python tools...${NC}"
  
  # Update pip
  python3 -m pip install --upgrade pip
  
  # List of useful Python packages
  local packages=(
    "ipython"           # Enhanced interactive Python shell
    "black"             # Code formatter
    "flake8"            # Linter
    "isort"             # Import sorter
    "mypy"              # Static type checker
    "pytest"            # Testing framework
    "poetry"            # Dependency management
    "pipenv"            # Virtual environment management
    "jupyterlab"        # Jupyter notebooks
    "requests"          # HTTP for humans
    "httpie"            # Command-line HTTP client
    "virtualenv"        # Virtual environment
    "wheel"             # Built-package format
    "setuptools"        # Package installer
  )
  
  for package in "${packages[@]}"; do
    echo -e "${BLUE}Installing ${package}...${NC}"
    python3 -m pip install --user "${package}"
  done
  
  echo -e "${GREEN}Python tools installed successfully!${NC}"
}

# Main script logic
echo -e "${BLUE}Python Development Environment Setup${NC}"
echo -e "===================================\n"

# Check if Python is installed
if ! check_python; then
  if [ "$INSTALL_PYENV" = true ] || confirm "Do you want to install Python $PYTHON_VERSION using pyenv?"; then
    install_pyenv
  else
    echo -e "${YELLOW}Skipping Python installation.${NC}"
    exit 0
  fi
fi

# Setup Python environment
setup_python_env

# Install Python tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install common Python tools?"; then
  install_python_tools
else
  echo -e "${YELLOW}Skipping Python tools installation.${NC}"
fi

echo -e "\n${GREEN}Python setup complete!${NC}"
echo -e "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
