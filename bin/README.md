# Utility Scripts

This directory contains utility scripts for managing your dotfiles and system.

## Overview

- `backup-dotfiles` - Creates a backup of your dotfiles
- `update-dotfiles` - Updates your dotfiles from the repository
- `manage-local` - Manages local customization files

## Scripts

### backup-dotfiles

Creates a timestamped backup of your current dotfiles:

```bash
# Run the backup script
~/bin/backup-dotfiles

# Backups are stored in ~/.dotfiles_backup/YYYYMMDDHHMMSS/
```

This script backs up your home directory dotfiles before making changes, useful as a safeguard before updates.

### update-dotfiles

Updates your dotfiles from the Git repository:

```bash
# Update your dotfiles
~/bin/update-dotfiles
```

This script:
1. Navigates to your dotfiles directory
2. Pulls the latest changes from Git
3. Runs the installation script to apply updates

### manage-local

Manages your local customization files:

```bash
# Initialize local customization directory
./bin/manage-local init

# Edit a specific configuration file
./bin/manage-local edit zsh
./bin/manage-local edit git
./bin/manage-local edit vim

# List all local customization files
./bin/manage-local list

# Sync local customizations
./bin/manage-local sync
```

This script helps organize machine-specific settings in the `~/.dotfiles-local` directory.
