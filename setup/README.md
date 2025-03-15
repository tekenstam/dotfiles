# Development Environment Setup

This directory contains scripts for setting up different development environments.

## Overview

- `go.sh` - Sets up Go development environment
- `node.sh` - Sets up Node.js development environment
- `python.sh` - Sets up Python development environment

## Go Setup

The `go.sh` script installs and configures Go:

### Features

- Installs Go via Homebrew
- Configures GOPATH and environment variables
- Installs common Go tools:
  - gopls (Language Server)
  - delve (Debugger)
  - golangci-lint (Linter)
  - air (Live reload)
  - gotests (Test generator)

### Usage

```bash
# Full installation with all tools
./setup/go.sh --all

# Just install Go
./setup/go.sh --install-go

# Just install tools (assumes Go is installed)
./setup/go.sh --install-tools

# Non-interactive installation
./setup/go.sh --no-prompt
```

## Node.js Setup

The `node.sh` script installs and configures Node.js:

### Features

- Installs Node Version Manager (nvm)
- Installs specified Node.js version
- Configures NVM in .zshrc.local
- Installs common Node.js tools:
  - TypeScript
  - ESLint and Prettier
  - Nodemon
  - Yarn
  - npm-check-updates

### Usage

```bash
# Full installation with all tools
./setup/node.sh --all

# Just install Node.js
./setup/node.sh --install-node

# Just install tools (assumes Node.js is installed)
./setup/node.sh --install-tools

# Specify Node.js version
./setup/node.sh --node-version=18

# Non-interactive installation
./setup/node.sh --no-prompt
```

## Python Setup

The `python.sh` script installs and configures Python:

### Features

- Installs pyenv for Python version management
- Installs specified Python version
- Sets up virtual environment helpers
- Installs common Python tools:
  - ipython
  - black and flake8
  - mypy
  - pytest
  - poetry and pipenv
  - jupyterlab
  - requests

### Usage

```bash
# Full installation with all tools
./setup/python.sh --all

# Just install pyenv and Python
./setup/python.sh --install-pyenv

# Just install tools (assumes Python is installed)
./setup/python.sh --install-tools

# Specify Python version
./setup/python.sh --python-version=3.11.5

# Non-interactive installation
./setup/python.sh --no-prompt
```
