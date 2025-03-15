#!/bin/bash

# Python Development Environment Setup
# ----------------------------------
# This script installs Python via pyenv and sets up a complete
# development environment with virtual environments and essential tools
#
# Usage:
#   ./setup/python.sh                          # Interactive installation
#   ./setup/python.sh --all                    # Install everything
#   ./setup/python.sh --install-pyenv          # Only install pyenv and Python
#   ./setup/python.sh --install-tools          # Only install Python tools
#   ./setup/python.sh --python-version=3.11.5  # Specify Python version
#   ./setup/python.sh --no-prompt              # Non-interactive installation
#
# Author: tekenstam
# Last Updated: 2025-03-15

set -e

# Source common utilities
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Python version to install (if using pyenv)
DEFAULT_PYTHON_VERSION="3.11.5"

# Parse command line arguments
INSTALL_PYENV=false
INSTALL_TOOLS=false
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
    --python-version=*)
      PYTHON_VERSION="${arg#*=}"
      shift
      ;;
    --all)
      INSTALL_PYENV=true
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

# Check if Python is installed
check_python() {
  if command_exists python3; then
    print_success "Python is already installed: $(python3 --version)"
    return 0
  else
    print_warning "Python is not installed."
    return 1
  fi
}

# Install pyenv for managing Python versions
install_pyenv() {
  print_section "Installing pyenv"
  
  # Check if pyenv is installed
  if command_exists pyenv; then
    print_success "pyenv is already installed: $(pyenv --version)"
  else
    # Install dependencies
    if is_macos; then
      ensure_homebrew || return 1
      brew install openssl readline sqlite3 xz zlib tcl-tk
    fi
    
    # Install pyenv
    print_warning "Installing pyenv..."
    curl https://pyenv.run | bash
    
    # Set up pyenv for the current session
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    
    print_success "pyenv installed successfully: $(pyenv --version)"
  fi
  
  # Install the specified Python version
  print_warning "Installing Python $PYTHON_VERSION using pyenv..."
  pyenv install -s "$PYTHON_VERSION"
  pyenv global "$PYTHON_VERSION"
  
  print_success "Python $PYTHON_VERSION installed successfully: $(python --version)"
}

# Setup Python environment
setup_python_env() {
  print_section "Setting up Python environment"
  
  # Add pyenv to zshrc.local
  add_to_zshrc_local "# pyenv configuration" "export PYENV_ROOT=\"\$HOME/.pyenv\""
  add_to_zshrc_local "# pyenv configuration" "export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
  add_to_zshrc_local "# pyenv configuration" "if command -v pyenv >/dev/null 2>&1; then"
  add_to_zshrc_local "# pyenv configuration" "  eval \"\$(pyenv init --path)\""
  add_to_zshrc_local "# pyenv configuration" "  eval \"\$(pyenv init -)\""
  add_to_zshrc_local "# pyenv configuration" "fi"
  
  # Add Python aliases
  add_to_zshrc_local "# Python aliases" "alias py=\"python3\""
  add_to_zshrc_local "# Python aliases" "alias python=\"python3\""
  add_to_zshrc_local "# Python aliases" "alias pip=\"pip3\""
  add_to_zshrc_local "# Python aliases" "alias venv=\"python3 -m venv\""
  add_to_zshrc_local "# Python aliases" "alias activate=\"source ./venv/bin/activate\""
  add_to_zshrc_local "# Python aliases" "alias mkvenv=\"python3 -m venv venv && source ./venv/bin/activate\""
  
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
    print_success "Created pip.conf with sensible defaults"
  fi
}

# Install common Python tools
install_python_tools() {
  print_section "Installing Python tools"
  
  # Install pipx for isolated application installation
  if ! command_exists pipx; then
    print_warning "Installing pipx..."
    brew install pipx
    pipx ensurepath
  else
    print_success "pipx is already installed."
  fi
  
  # Create a tools virtual environment for library usage
  TOOLS_VENV="$HOME/.python-tools-venv"
  print_warning "Creating tools virtual environment at $TOOLS_VENV..."
  python3 -m venv "$TOOLS_VENV"
  source "$TOOLS_VENV/bin/activate"
  
  # Update pip in the virtual environment
  print_warning "Updating pip in virtual environment..."
  python3 -m pip install --upgrade pip
  
  # Install library packages in virtual environment
  print_warning "Installing library packages in virtual environment..."
  local venv_packages=(
    "ipython"           # Enhanced interactive Python shell
    "black"             # Code formatter
    "flake8"            # Linter
    "isort"             # Import sorter
    "mypy"              # Static type checker
    "pytest"            # Testing framework
    "requests"          # HTTP for humans
    "wheel"             # Built-package format
    "setuptools"        # Package installer
  )
  
  for package in "${venv_packages[@]}"; do
    echo -e "${BLUE}Installing ${package} in virtual environment...${NC}"
    python3 -m pip install "${package}"
  done
  
  # Deactivate the virtual environment
  deactivate
  
  # Add the virtual environment to .zshrc.local
  add_to_zshrc_local "# Python tools virtual environment" "export PYTHON_TOOLS_VENV=\"$TOOLS_VENV\""
  add_to_zshrc_local "# Python tools virtual environment" "alias activate-tools=\"source \$PYTHON_TOOLS_VENV/bin/activate\""
  
  # Install application packages with pipx for isolation
  print_warning "Installing application packages with pipx..."
  local pipx_packages=(
    "poetry"            # Dependency management
    "pipenv"            # Virtual environment management
    "jupyterlab"        # Jupyter notebooks
    "httpie"            # Command-line HTTP client
  )
  
  for package in "${pipx_packages[@]}"; do
    echo -e "${BLUE}Installing ${package} with pipx...${NC}"
    pipx install "${package}"
  done
  
  print_success "Python tools installed successfully!"
  print_warning "Use 'activate-tools' to use the virtual environment with dev tools"
  print_warning "Installed applications are available directly via PATH"
}

# Main script logic
print_section "Python Development Environment Setup"

# Check if Python is installed
if check_python; then
  if [ "$INSTALL_PYENV" = true ] || confirm "Do you want to install pyenv and Python $PYTHON_VERSION?"; then
    install_pyenv
  else
    print_warning "Skipping pyenv installation."
  fi
fi

# Set up Python environment
setup_python_env

# Install Python tools
if [ "$INSTALL_TOOLS" = true ] || confirm "Do you want to install Python tools?"; then
  install_python_tools
else
  print_warning "Skipping Python tools installation."
fi

print_completion "Python" "You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect."
