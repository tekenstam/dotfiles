#!/bin/bash

# Common Utilities for Setup Scripts
# --------------------------------
# This script contains shared functions and utilities for setup scripts
# It should be sourced by other setup scripts, not executed directly
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
#
# Author: tekenstam
# Last Updated: 2025-03-15

# Ensure this script is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script should be sourced, not executed directly."
  echo "Usage: source \"$(dirname "${BASH_SOURCE[0]}")/common.sh\""
  exit 1
fi

# Colors for terminal output
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export YELLOW='\033[0;33m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color

# Function to prompt for confirmation
# Usage: if confirm "Do you want to continue?"; then ... fi
confirm() {
  if [ "${NO_PROMPT:-false}" = true ]; then
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

# Check if a command exists
# Usage: if command_exists "brew"; then ... fi
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if running on macOS
# Usage: if is_macos; then ... fi
is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

# Check if Homebrew is installed
# Usage: if homebrew_exists; then ... fi
homebrew_exists() {
  command_exists "brew"
}

# Install Homebrew if not already installed
# Usage: ensure_homebrew
ensure_homebrew() {
  if ! homebrew_exists; then
    echo -e "${YELLOW}Homebrew is required but not installed.${NC}"
    if confirm "Do you want to install Homebrew?"; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo -e "${RED}Cannot proceed without Homebrew. Exiting.${NC}"
      return 1
    fi
  else
    echo -e "${GREEN}Homebrew is already installed.${NC}"
  fi
  return 0
}

# Add a setting to zshrc.local if not already present
# Usage: add_to_zshrc_local "# Go configuration" "export GOPATH=\$HOME/go"
add_to_zshrc_local() {
  local header=$1
  local content=$2
  
  # Create the file if it doesn't exist
  touch ~/.zshrc.local
  
  # Check if the content already exists
  if ! grep -q "$content" ~/.zshrc.local; then
    # Check if the header already exists
    if ! grep -q "$header" ~/.zshrc.local; then
      echo -e "\n$header" >> ~/.zshrc.local
    fi
    echo "$content" >> ~/.zshrc.local
    echo -e "${GREEN}Added to ~/.zshrc.local: ${NC}$content"
  else
    echo -e "${GREEN}Already in ~/.zshrc.local: ${NC}$content"
  fi
}

# Print a section header
# Usage: print_section "Python Setup"
print_section() {
  echo -e "\n${BLUE}$1${NC}"
  echo -e "${BLUE}$(printf '=%.0s' $(seq 1 ${#1}))${NC}\n"
}

# Print a success message
# Usage: print_success "Installation complete!"
print_success() {
  echo -e "${GREEN}$1${NC}"
}

# Print a warning message
# Usage: print_warning "This might take a while..."
print_warning() {
  echo -e "${YELLOW}$1${NC}"
}

# Print an error message
# Usage: print_error "Something went wrong!"
print_error() {
  echo -e "${RED}$1${NC}"
}

# Parse common command line arguments
# Usage: parse_common_args "$@"
parse_common_args() {
  for arg in "$@"; do
    case $arg in
      --no-prompt)
        export NO_PROMPT=true
        ;;
      *)
        # Skip unknown arguments
        ;;
    esac
  done
}

# Print command-line usage for a setup script
# Usage: print_usage "go.sh" "--install-go" "Only install Go" "--install-tools" "Only install Go tools"
print_usage() {
  local script_name=$1
  shift
  
  echo "Usage:"
  echo "  ./setup/$script_name                  # Interactive installation"
  echo "  ./setup/$script_name --all            # Install everything"
  echo "  ./setup/$script_name --no-prompt      # Non-interactive installation"
  
  while [ "$#" -gt 0 ]; do
    local option=$1
    local description=$2
    echo "  ./setup/$script_name $option    # $description"
    shift 2
  done
}

# Print completion message
# Usage: print_completion "Go" "You may need to restart your terminal"
print_completion() {
  local tool=$1
  local extra_info=$2
  
  echo -e "\n${GREEN}$tool setup complete!${NC}"
  if [ -n "$extra_info" ]; then
    echo -e "$extra_info"
  fi
}
