# Vim Configuration

This directory contains Vim editor configuration.

## Overview

- `.vimrc` - Core Vim configuration file

## Features

### Core Settings

- Syntax highlighting enabled
- Line numbers displayed
- Smart indentation
- Search highlighting
- Tab settings (4 spaces by default)
- Backup and swap file management

### Keyboard Shortcuts

The `.vimrc` file includes several useful mappings:

- Enhanced navigation between splits
- Improved search behavior
- Easy window management

## Customization

For machine-specific Vim settings, create a `~/.vimrc.local` file:

```vim
" Example ~/.vimrc.local
colorscheme solarized
set background=dark
set relativenumber
```

This file is sourced at the end of `.vimrc` but is not tracked in Git.

## Plugins

While the base configuration is minimal, you can add plugins by:

1. Adding them to your `~/.vimrc.local` file
2. Installing a plugin manager like Vim-Plug:

```vim
" In ~/.vimrc.local
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()
```

This keeps plugin management separate from the shared configuration.
