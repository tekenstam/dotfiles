# Git Configuration

This directory contains Git configuration files and templates.

## Overview

- `.gitconfig` - Main Git configuration with aliases and settings
- `.gitignore_global` - Global Git ignore patterns
- `.gitconfig.local.example` - Template for personal Git identity

## Features

### Git Configuration

The `.gitconfig` file includes:

- Useful aliases for common Git operations
- Default branch set to `main`
- Color settings for better UI
- Merge and diff tool configurations
- Push and pull settings

### Git Aliases

Some helpful Git aliases included:

- `git st` - Short for `git status`
- `git co` - Short for `git checkout`
- `git ci` - Short for `git commit`
- `git br` - Short for `git branch`
- `git unstage` - Unstage files with `git reset HEAD --`
- `git last` - Show the last commit with `git log -1 HEAD`
- `git lg` - Enhanced log display with colors and graph
- `git amend` - Amend the previous commit
- `git wip` - Quick "work in progress" commit

### Local Git Configuration

For personal or machine-specific Git settings:

1. Copy the example file to your home directory:
   ```bash
   cp git/.gitconfig.local.example ~/.gitconfig.local
   ```

2. Edit your personal information:
   ```bash
   vim ~/.gitconfig.local
   ```

This keeps your personal details (name, email, signing keys) separate from the shared configuration.

## Work vs Personal Configuration

The main `.gitconfig` includes conditional configuration for work repositories:

```
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig.work
```

This allows you to have different Git identities for work and personal projects.
