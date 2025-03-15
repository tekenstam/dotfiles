# Local Customizations

This directory contains templates for local customizations that are not tracked in Git.

## Overview

- `git/gitconfig.local.example` - Template for personal Git identity
- `vim/vimrc.local.example` - Template for personal Vim settings
- `zsh/zshrc.local.example` - Template for personal ZSH settings

## Usage

These template files are meant to be copied to your home directory with the `.example` suffix removed:

```bash
cp local/git/gitconfig.local.example ~/.gitconfig.local
cp local/vim/vimrc.local.example ~/.vimrc.local
cp local/zsh/zshrc.local.example ~/.zshrc.local
```

You can then customize these files with your personal settings.

## Managing Local Files

The repository includes a utility script to manage local customizations:

```bash
# Initialize local customization directory
./bin/manage-local init

# Edit local configuration files
./bin/manage-local edit zsh
./bin/manage-local edit git
./bin/manage-local edit vim

# List all local customization files
./bin/manage-local list

# Sync your dotfiles-local directory
./bin/manage-local sync
```

## Purpose

The `.local` files are designed to:

1. Keep personal information (like your Git name and email) separate from shared configurations
2. Allow machine-specific customizations that don't need to be shared
3. Prevent accidental commits of sensitive information

These files are included in `.gitignore` to ensure they stay private.
