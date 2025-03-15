# System utility functions

# Production safeguards
# This function adds a confirmation prompt for commands containing sensitive terms
# like 'prod', 'production', 'delete', 'remove', etc.

# Enable production confirmation prompts
enable_prod_safeguard() {
  # Define the prod_command_trap function
  function prod_command_trap() {
    local sensitive_terms=("prod" "production" "delete" "remove" "drop" "truncate" "destroy" "terraform apply" "kubectl delete" "rm -rf")
    
    for term in "${sensitive_terms[@]}"; do
      if [[ "$BUFFER" == *"$term"* ]]; then
        echo -e "\n\033[1;33mWarning: You're about to run a command with '$term'\033[0m"
        echo -n "Are you sure you want to run this command [y/N]? "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
          echo -e "\nCommand was not executed."
          zle kill-whole-line
          return 1
        fi
        echo -e "\nExecuting command..."
        break
      fi
    done
    return 0
  }
  
  # Add the preexec hook
  autoload -U add-zsh-hook
  add-zsh-hook preexec prod_command_trap
  
  echo "Production safeguards enabled. Commands with sensitive terms will require confirmation."
}

# Disable production confirmation prompts
disable_prod_safeguard() {
  # Remove the preexec hook if it exists
  if typeset -f prod_command_trap > /dev/null; then
    add-zsh-hook -d preexec prod_command_trap
    unfunction prod_command_trap
    echo "Production safeguards disabled."
  else
    echo "Production safeguards were not enabled."
  fi
}

# Display system information
sysinfo() {
  echo "System Information:"
  echo "-------------------"
  echo "OS: $(uname -s)"
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS Version: $(sw_vers -productVersion)"
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
    echo "Memory: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
  elif [[ "$(uname)" == "Linux" ]]; then
    echo "Distribution: $(grep PRETTY_NAME /etc/os-release | cut -d '=' -f 2 | tr -d '"')"
    echo "CPU: $(grep "model name" /proc/cpuinfo | head -1 | cut -d ':' -f 2 | xargs)"
    echo "Memory: $(grep MemTotal /proc/meminfo | awk '{print $2/1024/1024" GB"}')"
  fi
  
  echo "Shell: $SHELL"
  echo "Terminal: $TERM"
}

# CPU architecture-specific environment setup
# Automatically detects Apple Silicon vs Intel and sets up appropriate paths
setup_arch_env() {
  if [[ $(uname -m) == "arm64" ]]; then
    # This is silent by default to avoid Powerlevel10k warnings
    if [[ "$1" == "--verbose" ]]; then
      echo "Setting up environment for ARM64 architecture"
    fi
    # Apple Silicon specific settings
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
  else
    # This is silent by default to avoid Powerlevel10k warnings
    if [[ "$1" == "--verbose" ]]; then
      echo "Setting up environment for x86_64 architecture"
    fi
    # Intel Mac specific settings
    export HOMEBREW_PREFIX="/usr/local"
    export HOMEBREW_CELLAR="/usr/local/Cellar"
    export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
    export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}"
    export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/usr/local/share/info:${INFOPATH:-}"
  fi
}
