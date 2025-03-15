# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme
ZSH_THEME="powerlevel10k/powerlevel10k"

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

# Source Powerlevel10k configuration
if [ -f ~/.p10k.zsh ]; then
  source ~/.p10k.zsh
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
