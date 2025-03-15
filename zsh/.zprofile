# .zprofile is sourced only for login shells
# Use this file to set environment variables and run commands that should run once at login

# Set PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Set language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Create directories if they don't exist
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_CACHE_HOME

# Rancher Desktop configuration
if [ -d "$HOME/.rd/bin" ]; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

# Source local profile (not tracked in Git)
if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi
