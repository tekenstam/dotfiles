# ZSH Configuration

This directory contains ZSH shell configuration files and setup scripts.

## Overview

- `.zshrc` - Main ZSH configuration with Starship prompt, AWS, and Kubernetes plugins
- `.zprofile` - Login shell configuration
- `.zsh_aliases` - Useful aliases and functions
- `starship.toml` - Starship prompt config (Git, Kubernetes, AWS; symlinked to ~/.config/starship.toml)
- `functions/` - Utility functions for various tasks
- `setup/` - ZSH plugin setup scripts

## Features

### Starship Prompt

Starship is a fast, cross-shell prompt with minimal config:

- Git branch and status on the left
- AWS profile and Kubernetes context on the right (prod=red, staging=orange)
- Command duration and exit status
- Directory shortening (truncate middle)

### Essential Plugins

The following ZSH plugins are automatically installed:

- `zsh-autosuggestions` - Shows suggestions based on command history
- `zsh-syntax-highlighting` - Highlights commands as you type
- `kubectl` - Kubernetes command completion and aliases
- `kubectx` - Utility to switch between Kubernetes contexts
- `git` - Git aliases and completion
- `docker` - Docker command completion

### Utility Functions

The `functions/` directory contains helpful utility functions:

- `docker-utils.zsh` - Docker container management utilities
- `git-utils.zsh` - Git workflow helpers
- `ssh-utils.zsh` - SSH key and connection management
- `system-utils.zsh` - System utilities and safeguards
- `cli-utils.zsh` - Command-line utility functions

## Setup

The setup scripts in the `setup/` directory handle the installation of ZSH plugins. Starship is installed via Homebrew (see `macos/brew.sh`) and its config is symlinked from `zsh/starship.toml` to `~/.config/starship.toml` by `install.sh`.

- `plugins.sh` - Installs Oh My Zsh and plugins

```bash
# Install ZSH plugins
./zsh/setup/plugins.sh

# Use with no-prompt option
./zsh/setup/plugins.sh --no-prompt
```

## Customization

Create a `~/.zshrc.local` file for machine-specific customizations:

```bash
# Example ~/.zshrc.local
export EDITOR="vim"
alias projects="cd ~/Projects"

# Load additional tools
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

This file is sourced at the end of `.zshrc` but is not tracked in Git.
