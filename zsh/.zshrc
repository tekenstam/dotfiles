# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# No OMZ theme; prompt is handled by Starship
ZSH_THEME=""

# Add plugins
plugins=(
  git
  docker
  aws
  kubectl
  kubectx
  macos
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
if [ -d "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Source aliases
if [ -f ~/.zsh_aliases ]; then
  source ~/.zsh_aliases
fi

# Aliases for backward compatibility with renamed functions
alias localip='get_local_ip'
alias gclean='git_clean_branches'

# Load all ZSH function files
DOTFILES_DIR="$HOME/.dotfiles"
if [ -d "$DOTFILES_DIR/zsh/functions" ]; then
  for file in "$DOTFILES_DIR"/zsh/functions/*.zsh; do
    source "$file"
  done
fi

# Enable production safeguards (uncomment to activate)
# enable_prod_safeguard

# Setup architecture-specific environment
setup_arch_env

# Source local configuration (not tracked in Git)
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# Initialize nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Initialize Homebrew if it exists
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Set editor
export EDITOR='vim'
export VISUAL='vim'

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Created by `pipx` on 2026-03-04 17:46:11
export PATH="$PATH:/Users/tekenstam/.local/bin"

# Starship prompt (Git, Kubernetes, AWS, directory, status, time)
eval "$(starship init zsh)"
