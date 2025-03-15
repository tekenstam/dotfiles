# Docker utility functions

# Run a temporary docker container with a specific image
# Usage: dockrun [ubuntu|centos|debian|fedora|etc.]
dockrun() {
  local image="${1:-ubuntu:latest}"
  docker run -it --rm "$image" /bin/bash
}

# Enter a running Docker container with bash shell
# Usage: denter container_name_or_id
denter() {
  if [[ ! "$1" ]] ; then
    echo "Usage: denter container_name_or_id"
    echo "Enter a running Docker container with an interactive bash shell"
    return 1
  fi

  docker exec -it "$1" bash || docker exec -it "$1" sh
  return 0
}

# List all Docker containers with their IPs and exposed ports
# Usage: dockips
dockips() {
  docker ps --format "{{.Names}}: {{.Ports}}" | sort
}

# Clean up Docker resources (use with caution)
# Usage: dockclean
dockclean() {
  echo "This will remove all stopped containers, unused networks, and dangling images."
  echo "Are you sure you want to continue? [y/N]"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    docker system prune -f
    echo "Docker resources cleaned."
  else
    echo "Operation canceled."
  fi
}
