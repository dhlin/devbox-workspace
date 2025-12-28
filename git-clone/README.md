# Git Clone Plugin

A Devbox plugin that automatically clones git repositories when entering a devbox shell.

## Features

- Automatically clones repositories on shell initialization
- Supports multiple repositories (space or comma separated)
- Optional branch specification
- Skips cloning if repository already exists
- Works with both HTTPS and SSH URLs

## Usage

Set the `GIT_REPO_URLS` environment variable with one or more repository URLs:

```json
{
  "env": {
    "GIT_REPO_URLS": "https://github.com/user/repo",
    "GIT_CLONE_DIR": "$DEVBOX_PROJECT_ROOT"
  }
}
```

### Multiple Repositories

```json
{
  "env": {
    "GIT_REPO_URLS": "https://github.com/user/repo1 https://github.com/user/repo2"
  }
}
```

### Clone Specific Branch

Append the branch name to the URL:

```json
{
  "env": {
    "GIT_REPO_URLS": "https://github.com/user/repo/my/branch"
  }
}
```

## Environment Variables

- `GIT_REPO_URLS`: Space or comma-separated list of repository URLs to clone
- `GIT_CLONE_DIR`: Directory where repositories will be cloned (defaults to `.devbox/virtenv`)
