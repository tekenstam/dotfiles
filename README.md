# Dotfiles

This repository contains my personal dotfiles and configuration settings for various tools and applications.

## Usage

To set up a new machine with these dotfiles:

```bash
git clone https://github.com/tekenstam/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup-plugins.sh  # Install Oh My Zsh, Powerlevel10k, and plugins
./install.sh        # Set up symlinks for configuration files
```

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
- `git/` - Git configuration
- `vim/` - Vim/Neovim configuration
- `macos/` - macOS specific settings
- `bin/` - Useful scripts

## License

This repository is licensed under the MIT License.
