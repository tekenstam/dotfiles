# macOS Configuration

This directory contains macOS-specific settings and scripts.

## Overview

- `defaults.sh` - Script to configure macOS system preferences
- `brew.sh` - Homebrew package installation script

## macOS Defaults

The `defaults.sh` script customizes various macOS system preferences:

### Features

- **User Interface**: Sidebar icon size, scrollbar behavior, save panel settings
- **Finder**: Show path bar, file extensions, search behavior
- **Dock**: Icon size, auto-hide, minimize effects
- **Safari**: Developer menu, web inspector settings
- **Mail**: Email display and attachment settings
- **Photos**: Prevent automatic opening when devices are connected
- **Calendar**: Week numbers, day settings
- **Terminal**: UTF-8 encoding, Pro theme
- **App Store**: Update settings

### Usage

```bash
# Run with prompts for each section
./macos/defaults.sh

# Run without prompts
./macos/defaults.sh --no-prompt
```

The script will ask for confirmation before applying each category of settings, unless `--no-prompt` is specified.

## Homebrew Setup

The `brew.sh` script installs Homebrew and common packages:

### Package Categories

- **Core**: Essential tools like git, curl, wget, vim
- **Development**: Languages and dev tools (Go, Python, Kubernetes, etc.)
- **Utilities**: Productivity tools like fzf, ripgrep, tmux
- **Extras**: Nice-to-have tools like bat, eza, neofetch
- **Casks**: GUI applications (VS Code, Firefox, iTerm2, etc.)

### Usage

```bash
# Run with interactive prompts
./macos/brew.sh

# Install specific categories
./macos/brew.sh --core --dev

# Install everything without prompts
./macos/brew.sh --all --no-prompt

# Just install Homebrew itself
./macos/brew.sh --install-brew
```

## Architecture Support

Both scripts include automatic detection for Apple Silicon (M1/M2) vs Intel Macs, ensuring the correct paths and commands are used for each architecture.
