# Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This repository contains my personal dotfiles and configuration settings for various tools and applications.

## Usage

To set up a new machine with these dotfiles:

```bash
git clone https://github.com/tekenstam/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh        # Sets up everything in one go
```

### Installation Options

The installation scripts support safety flags to control behavior:

- `./install.sh --no-prompt`: Skip all confirmation prompts (useful for automated setup)
- `./install.sh --apply-macos-defaults`: Automatically apply macOS settings without a main prompt
- `./install.sh --no-zsh`: Skip ZSH plugins installation 
- `./install.sh --no-p10k`: Skip Powerlevel10k setup
- `./macos/defaults.sh --no-prompt`: Apply all macOS defaults without confirmation prompts

When run without flags, the scripts will prompt for confirmation before making any potentially destructive changes.

### Personal Configuration

This repository keeps personal configuration separate from shared configuration:

1. **Git Identity**: Copy the example file and add your personal information:
   ```bash
   cp git/.gitconfig.local.example ~/.gitconfig.local
   vim ~/.gitconfig.local  # Add your name and email
   ```

2. **Machine-specific ZSH settings**: You can create:
   - `~/.zshrc.local` - For local shell settings
   - `~/.zprofile.local` - For local environment variables

These `.local` files are not tracked in Git, so your personal information remains private.

## Contents

- `zsh/` - ZSH configuration files
  - `.zshrc` - Main ZSH configuration with Powerlevel10k, AWS, and Kubernetes plugins
  - `.zprofile` - Login shell configuration
  - `.zsh_aliases` - Useful aliases and functions
  - `.p10k.zsh` - Powerlevel10k configuration with AWS, Kubernetes, and Git info
  - `functions/` - Useful utility functions for various tasks
    - `docker-utils.zsh` - Docker container management utilities
    - `git-utils.zsh` - Git workflow helpers
    - `ssh-utils.zsh` - SSH key and connection management
    - `system-utils.zsh` - System utilities and safeguards
    - `cli-utils.zsh` - Command-line utility functions
  - `setup/` - ZSH and Powerlevel10k setup scripts
    - `plugins.sh` - Installs Oh My Zsh and useful plugins
    - `powerlevel10k.sh` - Sets up the Powerlevel10k theme and fonts
- `git/` - Git configuration
- `vim/` - Vim/Neovim configuration
- `macos/` - macOS specific settings
  - `defaults.sh` - macOS system preferences defaults
  - `brew.sh` - Homebrew package installation
- `bin/` - Useful scripts
- `local/` - Templates for local customizations
- `setup/` - Language-specific development environment setup

## Features

### Utility Functions
This dotfiles repository includes a variety of utility functions to boost productivity:

- **Docker Utilities**:
  - `dockrun [image]` - Run a disposable container with bash shell
  - `denter container_id` - Enter a running container with bash
  - `dockips` - List all containers with their IPs and ports
  - `dockclean` - Clean up Docker resources (with confirmation)

- **Git Helpers**:
  - `gsync branch_name` - Sync a branch with upstream and origin
  - `gnewbranch branch_name` - Create and push a new branch
  - `grebase n` - Interactively rebase the last n commits
  - `gclean` - Clean up merged/deleted branches
  - `gall [directory]` - Show git status for all repositories

- **SSH Management**:
  - `knownrm line_number` - Remove a line from known_hosts
  - `knownfind hostname` - Find a host in known_hosts
  - `sshtunnel local_port remote_host remote_port [ssh_host]` - Create SSH tunnel
  - `sshcopyid user@host` - Upload SSH key to a server

- **System Utilities**:
  - `enable_prod_safeguard` - Enable confirmation for potentially dangerous commands
  - `disable_prod_safeguard` - Disable the confirmation safeguard
  - `sysinfo` - Display system information
  - `setup_arch_env` - Configure environment based on CPU architecture

### Development Environment Setup

This dotfiles repository includes specialized setup scripts for different programming languages:

- **Go**: `./setup/go.sh`
  - Installs Go and configures GOPATH
  - Installs common Go tools (gopls, delve, golangci-lint, etc.)
  - Sets up environment variables in .zshrc.local

- **Node.js**: `./setup/node.sh`
  - Installs Node.js via NVM (Node Version Manager)
  - Installs common Node.js tools (typescript, eslint, prettier, etc.)
  - Configures NVM in .zshrc.local

- **Python**: `./setup/python.sh`
  - Installs Python via pyenv
  - Sets up virtual environment helpers
  - Installs common Python tools (ipython, black, pytest, etc.)

- **Homebrew**: `./macos/brew.sh`
  - Installs Homebrew package manager
  - Installs categorized packages:
    - **Core**: Essential tools like git, curl, wget, vim
    - **Development**: Languages and dev tools (Go, Python, Kubernetes, etc.)
    - **Utilities**: Productivity tools like fzf, ripgrep, tmux
    - **Extras**: Nice-to-have tools like bat, exa, neofetch
    - **Casks**: GUI applications (VS Code, Firefox, iTerm2, etc.)

Options:
```bash
# Install everything with default settings
./setup/node.sh --all

# Install specific components
./setup/python.sh --install-pyenv
./setup/go.sh --install-tools

# Specify versions
./setup/node.sh --node-version=18
./setup/python.sh --python-version=3.11.5

# Install brew packages by category
./macos/brew.sh --core --dev
./macos/brew.sh --all --no-prompt
```

### Local Customizations

Your personal settings can be managed using the `manage-local` script:

```bash
# Initialize local customization directory
./bin/manage-local init

# Edit local configuration files
./bin/manage-local edit zsh
./bin/manage-local edit git
./bin/manage-local edit vim

# List all local customization files
./bin/manage-local list

# Sync your local customizations
./bin/manage-local sync
```

This creates a separate structure for your machine-specific settings without modifying the main dotfiles:

```
~/.dotfiles-local/
├── git/
├── vim/
├── zsh/
└── bin/
```

### Command-Line Utilities

This dotfiles repository includes many useful command-line utilities:

- **File Management**:
  - `mkd dir` - Create a directory and enter it
  - `extract file` - Extract any archive format
  - `dataurl file` - Create a data URL from a file
  - `findlarge [size]` - Find large files (default: +100M)

- **System Information**:
  - `myip` - Get your external IP address
  - `localip` - Get your local IP addresses
  - `topmem` - Show top memory-consuming processes
  - `topcpu` - Show top CPU-consuming processes
  - `dirsize dir` - Show directory size
  - `ducks` - Show disk usage, sorted by size

- **Development**:
  - `server [port]` - Start an HTTP server in current directory
  - `jsonpp file` - Pretty print JSON
  - `timestamp2date timestamp` - Convert Unix timestamp to date
  - `shellbench [runs]` - Benchmark shell startup time
  - `genpasswd [length]` - Generate a random password
  - `cheat command` - Get a cheat sheet for a command

- **Network**:
  - `listening` - List all listening ports
  - `killport port` - Kill process using a specific port

### Production Safeguards
The production safeguards feature prevents accidental execution of dangerous commands:

- Commands containing sensitive terms like "prod", "delete", "remove", etc. will prompt for confirmation
- Enable by uncommenting `enable_prod_safeguard` in your .zshrc or running the command manually
- Helps prevent costly mistakes when working with multiple environments

### Cross-Platform Support

This dotfiles repository is designed to work across different operating systems and architectures with minimal friction:

#### Different Operating Systems

1. **OS-Specific Configuration**:
   - OS-specific settings are organized in separate directories (e.g., `macos/`)
   - The `install.sh` script detects the OS and applies the appropriate configurations:
     ```bash
     if [[ "$OSTYPE" == "darwin"* ]]; then
         # macOS-specific setup
     elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
         # Linux-specific setup
     fi
     ```

2. **Adding support for a new OS**:
   ```bash
   # 1. Create a directory for the OS-specific settings
   mkdir -p ~/src/github.com/tekenstam/dotfiles/linux

   # 2. Add configuration files for the new OS
   touch ~/src/github.com/tekenstam/dotfiles/linux/setup.sh

   # 3. Update the install.sh script to handle the new OS
   vim ~/src/github.com/tekenstam/dotfiles/install.sh
   ```

#### Different CPU Architectures

1. **Architecture-Specific Settings**:
   - Use the `uname -m` command to detect the CPU architecture
   - Create architecture-specific configurations when needed:
     ```bash
     ARCH=$(uname -m)
     if [[ "$ARCH" == "arm64" ]]; then
         # ARM-specific settings (e.g., M1/M2 Macs)
     elif [[ "$ARCH" == "x86_64" ]]; then
         # Intel/AMD specific settings
     fi
     ```

2. **Example: Managing Homebrew paths on different Mac architectures**:
   ```bash
   # In .zprofile.local
   if [[ "$(uname -m)" == "arm64" ]]; then
       # M1/M2 Mac
       eval "$(/opt/homebrew/bin/brew shellenv)"
   else
       # Intel Mac
       eval "$(/usr/local/bin/brew shellenv)"
   fi
   ```

## Customizing and Extending

### Adding or Modifying Dotfiles

1. **Adding a new configuration file**:
   ```bash
   # 1. Create the file in the appropriate directory
   vim ~/src/github.com/tekenstam/dotfiles/zsh/.zsh_functions

   # 2. Update the install.sh script to create the symlink
   vim ~/src/github.com/tekenstam/dotfiles/install.sh
   # Add: link_file "$DOTFILES_DIR/zsh/.zsh_functions" "$HOME/.zsh_functions"

   # 3. Commit and push your changes
   git add zsh/.zsh_functions install.sh
   git commit -m "Add .zsh_functions file"
   git push
   ```

2. **Modifying existing files**:
   ```bash
   # 1. Edit the file in the repository
   vim ~/src/github.com/tekenstam/dotfiles/zsh/.zshrc

   # 2. Commit and push your changes
   git add zsh/.zshrc
   git commit -m "Update .zshrc with new settings"
   git push
   ```

3. **Using machine-specific customizations**:
   Instead of modifying the shared files directly, use the `.local` files for settings specific to a particular machine:
   ```bash
   # For machine-specific ZSH settings
   vim ~/.zshrc.local

   # For machine-specific Git settings
   vim ~/.gitconfig.local
   ```

## Keeping Dotfiles in Sync

To keep your dotfiles in sync across multiple machines:

1. **Pulling updates**:
   ```bash
   cd ~/.dotfiles
   git pull
   ./install.sh  # Re-create symlinks as needed
   ```

2. **Using the update script**:
   ```bash
   ~/bin/update-dotfiles
   ```

3. **Pushing your changes**:
   ```bash
   cd ~/.dotfiles
   git add .
   git commit -m "Update dotfiles with new settings"
   git push
   ```

## License

This repository is licensed under the [MIT License](LICENSE).
