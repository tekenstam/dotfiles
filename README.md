# Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This repository contains my personal dotfiles and configuration settings for various tools and applications.

## Quick Start

```bash
git clone https://github.com/tekenstam/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh        # Sets up everything in one go
```

## Directory Structure

Each directory contains its own README with detailed documentation:

- [`zsh/`](zsh/README.md) - ZSH configuration files and setup scripts
- [`git/`](git/README.md) - Git configuration and global ignore patterns
- [`vim/`](vim/README.md) - Vim editor configuration
- [`macos/`](macos/README.md) - macOS specific settings and Homebrew setup
- [`bin/`](bin/README.md) - Utility scripts for managing dotfiles
- [`setup/`](setup/README.md) - Development environment setup scripts
- [`local/`](local/README.md) - Templates for local customizations

## Installation Options

The installation scripts support various flags to control behavior:

- `./install.sh --no-prompt`: Skip all confirmation prompts (useful for automated setup)
- `./install.sh --apply-macos-defaults`: Automatically apply macOS settings
- `./install.sh --no-zsh`: Skip ZSH plugins installation
- `./install.sh --dry-run`: Preview what would be linked or backed up; no changes made
- `./install.sh --links-only`: Only create symlinks and .local templates; skip ZSH/Homebrew/macOS/dev setup

When run without flags, the scripts will prompt for confirmation before making any potentially destructive changes.

### Safe install (existing environment)

To install over an existing setup without losing config: run `./bin/backup-dotfiles` first, or rely on `install.sh`, which backs up any existing files it replaces into `~/.dotfiles_backup/<YYYYMMDDHHMMSS>/`. Existing `~/.gitconfig.local`, `~/.zshrc.local`, and `~/.vimrc.local` are never overwritten. To restore a file: `cp ~/.dotfiles_backup/<timestamp>/<filename> ~/<filename>`.

## Key Features

- **ZSH Environment**: Starship prompt with AWS, Kubernetes, and Git integration
- **Development Setups**: Automated setup for Go, Node.js, and Python environments
- **macOS Optimization**: System preferences and Homebrew package installation
- **Utility Functions**: Docker, Git, SSH, and system management helpers
- **Cross-Platform Support**: Works across different machines and architectures

## Personal Configuration

This repository keeps personal configuration separate from shared configuration using `.local` files:

- `~/.gitconfig.local` - Git identity (name, email)
- `~/.zshrc.local` - Machine-specific shell settings
- `~/.vimrc.local` - Personal Vim preferences

These files are not tracked in Git, so your personal information remains private.

## Updating

To update your dotfiles installation:

```bash
~/bin/update-dotfiles
```

This runs `git pull` then `./install.sh --links-only`, so only symlinks and local templates are updated without re-prompting for optional setup. To run a full install instead:

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## License

This repository is licensed under the [MIT License](LICENSE).
