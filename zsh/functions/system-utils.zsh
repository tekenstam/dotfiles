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
setup_arch_env() {
  local arch_name="$(uname -m)"
  
  if [[ "${arch_name}" == "x86_64" ]]; then
    echo "Setting up environment for x86_64 architecture"
    # Intel Mac or Linux
    export ARCH_BREW_PREFIX="/usr/local"
  elif [[ "${arch_name}" == "arm64" ]]; then
    echo "Setting up environment for ARM64 architecture"
    # M1/M2 Mac
    export ARCH_BREW_PREFIX="/opt/homebrew"
  else
    echo "Unknown architecture: ${arch_name}"
    return 1
  fi
  
  # Add architecture-specific paths
  export PATH="${ARCH_BREW_PREFIX}/bin:${ARCH_BREW_PREFIX}/sbin:$PATH"
  export MANPATH="${ARCH_BREW_PREFIX}/share/man:$MANPATH"
  
  # Source architecture-specific configurations if they exist
  if [[ -f "${ZDOTDIR:-$HOME}/.zshrc.${arch_name}" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshrc.${arch_name}"
  fi
}
