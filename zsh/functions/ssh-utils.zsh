# SSH utility functions

# Remove a line from the known_hosts file
# Usage: knownrm line_number
knownrm() {
  if [[ ! "$1" =~ ^[0-9]+$ ]] ; then
    echo "Usage: knownrm line_number"
    echo "Delete a specific line from the SSH known_hosts file"
    return 1
  else
    sed -i '' "$1d" ~/.ssh/known_hosts
    echo "Line $1 removed from known_hosts file."
  fi
}

# Find a host in the known_hosts file
# Usage: knownfind hostname
knownfind() {
  if [[ ! "$1" ]] ; then
    echo "Usage: knownfind hostname"
    echo "Find a host in the SSH known_hosts file"
    return 1
  fi
  
  grep -n "$1" ~/.ssh/known_hosts
}

# SSH tunnel to a remote host
# Usage: sshtunnel local_port remote_host remote_port [ssh_user@ssh_host]
sshtunnel() {
  if [[ ! "$1" || ! "$2" || ! "$3" ]] ; then
    echo "Usage: sshtunnel local_port remote_host remote_port [ssh_user@ssh_host]"
    echo "Create an SSH tunnel from local port to a remote host:port through an SSH server"
    return 1
  fi
  
  local local_port="$1"
  local remote_host="$2"
  local remote_port="$3"
  local ssh_host="${4:-$remote_host}"
  
  echo "Creating SSH tunnel from localhost:$local_port to $remote_host:$remote_port via $ssh_host"
  ssh -L "$local_port:$remote_host:$remote_port" "$ssh_host" -N
}

# Upload SSH public key to a remote server
# Usage: sshcopyid user@host
sshcopyid() {
  if [[ ! "$1" ]] ; then
    echo "Usage: sshcopyid user@host"
    echo "Upload your SSH public key to a remote server"
    return 1
  fi
  
  local pubkey="$HOME/.ssh/id_rsa.pub"
  if [[ ! -f "$pubkey" ]]; then
    echo "SSH public key not found at $pubkey"
    return 1
  fi
  
  cat "$pubkey" | ssh "$1" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
  echo "Public key uploaded to $1"
}
