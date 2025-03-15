# Git utility functions

# Sync a branch with upstream and origin
# Usage: gsync branch_name
gsync() {
  if [[ ! "$1" ]] ; then
    echo "Usage: gsync branch_name"
    echo "Syncs a branch with upstream and origin"
    return 1
  fi

  local BRANCHES=$(git branch --list "$1")
  if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 1
  fi

  git checkout "$1" && \
  git pull upstream "$1" && \
  git push origin "$1"
}

# Create a new branch and push it to origin
# Usage: gnewbranch branch_name
gnewbranch() {
  if [[ ! "$1" ]] ; then
    echo "Usage: gnewbranch branch_name"
    echo "Creates a new branch and pushes it to origin"
    return 1
  fi

  git checkout -b "$1" && \
  git push -u origin "$1"
}

# Interactively rebase the last n commits
# Usage: grebase n
grebase() {
  if [[ ! "$1" ]] ; then
    echo "Usage: grebase n"
    echo "Interactively rebase the last n commits"
    return 1
  fi

  git rebase -i HEAD~"$1"
}

# Clean up local branches that have been merged and deleted on remote
# Usage: gclean
gclean() {
  echo "This will remove all local branches that have been merged and deleted on remote."
  echo "Are you sure you want to continue? [y/N]"
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
    echo "Git branches cleaned."
  else
    echo "Operation canceled."
  fi
}

# Show git repository status across directories
# Usage: gall [directory]
gall() {
  local dir="${1:-$PWD}"
  
  echo "Checking git status in subdirectories of $dir"
  
  find "$dir" -type d -name ".git" | while read -r gitdir; do
    local repo=$(dirname "$gitdir")
    echo -e "\n\033[1;34m${repo#$dir/}\033[0m"
    git -C "$repo" status -s
  done
}
