# ZSH Configuration

This directory contains ZSH shell configuration files and setup scripts.

## Overview

- `.zshrc` - Main ZSH configuration with Powerlevel10k, AWS, and Kubernetes plugins
- `.zprofile` - Login shell configuration
- `.zsh_aliases` - Useful aliases and functions
- `.p10k.zsh` - Powerlevel10k configuration with AWS, Kubernetes, and Git info
- `functions/` - Utility functions for various tasks
- `setup/` - ZSH and Powerlevel10k setup scripts

## Features

### Powerlevel10k Theme

Powerlevel10k is a highly customizable ZSH theme optimized for speed and functionality:

- Instant prompt for faster shell startup
- AWS profile and Kubernetes context information
- Git status with branch, commits, and state
- Color-coded indicators for different environments

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

The setup scripts in the `setup/` directory handle the installation of ZSH plugins and Powerlevel10k:

- `plugins.sh` - Installs Oh My Zsh and plugins
- `powerlevel10k.sh` - Installs Powerlevel10k theme and required fonts

These scripts are automatically called by the main installation script with options:

```bash
# Install ZSH plugins
./zsh/setup/plugins.sh

# Install Powerlevel10k theme
./zsh/setup/powerlevel10k.sh

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
