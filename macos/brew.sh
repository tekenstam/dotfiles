#!/bin/bash

# macOS Homebrew Package Installation
# ---------------------------------
# This script installs Homebrew and common packages organized into categories
# It detects the CPU architecture (Intel/Apple Silicon) and installs appropriate packages
#
# Usage:
#   ./macos/brew.sh                 # Interactive installation with prompts
#   ./macos/brew.sh --install-brew  # Only install Homebrew itself
#   ./macos/brew.sh --core          # Install core packages
#   ./macos/brew.sh --dev           # Install development packages
#   ./macos/brew.sh --utils         # Install utility packages
#   ./macos/brew.sh --extras        # Install extra nice-to-have packages
#   ./macos/brew.sh --casks         # Install GUI applications
#   ./macos/brew.sh --all           # Install everything
#   ./macos/brew.sh --no-prompt     # Non-interactive installation
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

# Homebrew directory based on architecture
if [[ "$(uname -m)" == "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Parse command line arguments
INSTALL_BREW=false
INSTALL_CORE=false
INSTALL_DEV=false
INSTALL_UTILS=false
INSTALL_EXTRAS=false
INSTALL_CASKS=false
INSTALL_ALL=false
NO_PROMPT=false

for arg in "$@"; do
  case $arg in
    --install-brew)
      INSTALL_BREW=true
      shift
      ;;
    --core)
      INSTALL_CORE=true
      shift
      ;;
    --dev)
      INSTALL_DEV=true
      shift
      ;;
    --utils)
      INSTALL_UTILS=true
      shift
      ;;
    --extras)
      INSTALL_EXTRAS=true
      shift
      ;;
    --casks)
      INSTALL_CASKS=true
      shift
      ;;
    --all)
      INSTALL_ALL=true
      INSTALL_CORE=true
      INSTALL_DEV=true
      INSTALL_UTILS=true
      INSTALL_EXTRAS=true
      INSTALL_CASKS=true
      shift
      ;;
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

# Check if Homebrew is installed
check_brew() {
  if command -v brew >/dev/null 2>&1; then
    echo -e "${GREEN}Homebrew is already installed:${NC} $(brew --version | head -n 1)"
    return 0
  else
    echo -e "${YELLOW}Homebrew is not installed.${NC}"
    return 1
  fi
}

# Install Homebrew
install_brew() {
  echo -e "${BLUE}Installing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH based on architecture
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo -e "${BLUE}Adding Homebrew to PATH for Apple Silicon...${NC}"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc.local
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  
  echo -e "${GREEN}Homebrew installed successfully!${NC}"
}

# Update Homebrew
update_brew() {
  echo -e "${BLUE}Updating Homebrew...${NC}"
  brew update
  echo -e "${GREEN}Homebrew updated successfully!${NC}"
}

# Install Homebrew packages
install_packages() {
  local category=$1
  shift
  local packages=("$@")
  
  echo -e "${BLUE}Installing ${category} packages...${NC}"
  
  # Create a list of packages to install
  local to_install=()
  for package in "${packages[@]}"; do
    if ! brew list "$package" &>/dev/null; then
      to_install+=("$package")
    else
      echo -e "${GREEN}Package ${package} is already installed.${NC}"
    fi
  done
  
  # Install packages if any
  if [ ${#to_install[@]} -gt 0 ]; then
    echo -e "${BLUE}Installing ${#to_install[@]} packages...${NC}"
    brew install "${to_install[@]}"
    echo -e "${GREEN}Packages installed successfully!${NC}"
  else
    echo -e "${GREEN}All packages already installed!${NC}"
  fi
}

# Install Homebrew casks
install_casks() {
  local category=$1
  shift
  local casks=("$@")
  
  echo -e "${BLUE}Installing ${category} casks...${NC}"
  
  # Create a list of casks to install
  local to_install=()
  for cask in "${casks[@]}"; do
    if ! brew list --cask "$cask" &>/dev/null 2>&1; then
      to_install+=("$cask")
    else
      echo -e "${GREEN}Cask ${cask} is already installed.${NC}"
    fi
  done
  
  # Install casks if any
  if [ ${#to_install[@]} -gt 0 ]; then
    echo -e "${BLUE}Installing ${#to_install[@]} casks...${NC}"
    brew install --cask "${to_install[@]}"
    echo -e "${GREEN}Casks installed successfully!${NC}"
  else
    echo -e "${GREEN}All casks already installed!${NC}"
  fi
}

# Define package groups
CORE_PACKAGES=(
  "curl"
  "git"
  "gnu-sed"
  "grep"
  "jq"
  "tree"
  "macvim"
  "wget"
  "zsh"
)

DEV_PACKAGES=(
  "ansible"
  "cmake"
  "docker"
  "docker-compose"
  "ffmpeg"
  "go"
  "gradle"
  "helm"
  "kubernetes-cli"
  "kubectx"
  "maven"
  "nmap"
  "node"
  "openssl"
  "postgresql"
  "python"
  "ruby"
  "rust"
  "sqlite"
  "tesseract"
)

UTILITY_PACKAGES=(
  "ack"
  "ag" # the_silver_searcher
  "bash"
  "coreutils"
  "fd"
  "fzf"
  "gh" # GitHub CLI
  "gnu-tar"
  "gnupg"
  "htop"
  "lsd" # Modern ls replacement
  "ncdu" # Disk usage analyzer
  "pass" # Password manager
  "ripgrep" # Fast grep
  "shellcheck" # Shell script linter
  "tlrc" # Simplified man pages (replacement for deprecated tldr)
  "tmux"
  "watch"
  "xz"
  "zoxide" # Better cd
)

EXTRA_PACKAGES=(
  "neofetch" # System info script
  "bat" # Better cat
  "eza" # Modern ls replacement (successor to exa)
  "ipcalc" # Network calculator
  "imagemagick"
  "mosh" # Mobile shell
  "speedtest-cli"
  "terminal-notifier"
  "youtube-dl"
)

APP_CASKS=(
  "alfred"
  "brave-browser"
  "docker"
  "firefox"
  "iterm2"
  "rectangle"
  "visual-studio-code"
  "vlc"
)

# Main script logic
echo -e "${BLUE}Homebrew Package Installation${NC}"
echo -e "===========================\n"

# Check and install Homebrew if needed
if ! check_brew; then
  if [ "$INSTALL_BREW" = true ] || confirm "Do you want to install Homebrew?"; then
    install_brew
  else
    echo -e "${RED}Homebrew is required but not installed. Exiting.${NC}"
    exit 1
  fi
else
  if confirm "Do you want to update Homebrew?"; then
    update_brew
  fi
fi

# Install core packages
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_CORE" = true ] || confirm "Do you want to install core packages? (git, curl, etc.)"; then
  install_packages "core" "${CORE_PACKAGES[@]}"
else
  echo -e "${YELLOW}Skipping core packages.${NC}"
fi

# Install development packages
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_DEV" = true ] || confirm "Do you want to install development packages? (languages, kubernetes, etc.)"; then
  install_packages "development" "${DEV_PACKAGES[@]}"
else
  echo -e "${YELLOW}Skipping development packages.${NC}"
fi

# Install utility packages
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_UTILS" = true ] || confirm "Do you want to install utility packages? (tmux, fzf, etc.)"; then
  # Unlink deprecated tldr so tlrc (replacement) can install; both provide `tldr` binary
  if brew list tldr &>/dev/null; then
    echo -e "${YELLOW}Unlinking deprecated tldr so tlrc can be installed...${NC}"
    brew unlink tldr 2>/dev/null || true
  fi
  install_packages "utility" "${UTILITY_PACKAGES[@]}"
else
  echo -e "${YELLOW}Skipping utility packages.${NC}"
fi

# Install extra packages
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_EXTRAS" = true ] || confirm "Do you want to install extra packages? (bat, eza, etc.)"; then
  install_packages "extra" "${EXTRA_PACKAGES[@]}"
else
  echo -e "${YELLOW}Skipping extra packages.${NC}"
fi

# Install casks (GUI applications)
if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_CASKS" = true ] || confirm "Do you want to install GUI applications? (VS Code, Firefox, etc.)"; then
  install_casks "application" "${APP_CASKS[@]}"
else
  echo -e "${YELLOW}Skipping GUI applications.${NC}"
fi

echo -e "\n${GREEN}Homebrew setup complete!${NC}"
echo -e "You may need to restart your terminal for changes to take effect."
