#!/bin/bash

# Git Clone Plugin Init Hook

# Function to parse and clone a repository
_clone_repo() {
  local repo_spec="$1"

  # Check if the repo_spec contains a branch (ends with /branch_name)
  # A repo URL typically ends with the repo name
  # If it has an extra path segment after repo name, that's the branch

  local repo_url=""
  local branch=""

  # Match HTTP/HTTPS URLs
  if [[ $repo_spec =~ ^(https?://[^/]+/[^/]+/[^/]+)/(.+)$ ]]; then
    repo_url="${BASH_REMATCH[1]}"
    branch="${BASH_REMATCH[2]}"
  # Match Git SSH URLs
  elif [[ $repo_spec =~ ^(git@[^:]+:[^/]+/[^/]+)/(.+)$ ]]; then
    repo_url="${BASH_REMATCH[1]}"
    branch="${BASH_REMATCH[2]}"
  else
    # No branch specified, use the URL as-is
    repo_url="$repo_spec"
    branch=""
  fi

  # Extract repository name from URL for the directory name
  # Remove .git suffix if present, then get the last part
  local repo_name="$(basename "$repo_url" .git)"
  local clone_dir="$GIT_CLONE_DIR/${repo_name}"

  if [ -d "$clone_dir/.git" ]; then
    echo "✓ Repository $repo_name already exists at $clone_dir"
    return 0
  fi

  # Build clone command
  local CLONE_CMD="git clone"

  if [ -n "$branch" ]; then
    echo "Cloning $repo_url (branch: $branch)..."
    CLONE_CMD="$CLONE_CMD --branch $branch"
  else
    echo "Cloning $repo_url (default branch)..."
  fi

  CLONE_CMD="$CLONE_CMD $repo_url $clone_dir"

  if eval $CLONE_CMD; then
    echo "✓ Successfully cloned $repo_name to $clone_dir"
    return 0
  else
    echo "✗ Failed to clone $repo_name"
    return 1
  fi
}

# Clone repositories from GIT_REPO_URLS (space or comma separated)
if [ -n "$GIT_REPO_URLS" ]; then

  # Split on both spaces and commas
  IFS=' ,' read -ra REPO_ARRAY <<< "$GIT_REPO_URLS"

  for repo_spec in "${REPO_ARRAY[@]}"; do
    # Skip empty entries
    [ -z "$repo_spec" ] && continue
    _clone_repo "$repo_spec"
  done
fi

unset -f _clone_repo
