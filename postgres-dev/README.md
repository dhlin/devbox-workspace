# PostgreSQL Development Environment

A Devbox environment for building and running PostgreSQL from source.

## Features

- Branch-specific build directories and data directories
- Dynamic port assignment based on branch name

## Prerequisites

- [Devbox](https://www.jetify.com/devbox) installed

## Quick Start

```bash
# Enter the development shell
devbox shell

# Configure the build (first time or after changes)
devbox run setup

# Build and install PostgreSQL
devbox run build

# Initialize the database (first time only)
devbox run initdb

# Start PostgreSQL in the background
devbox services up -b

# Connect to the database
devbox run psql
```

## Build Configuration

### Environment Variables

You can customize the PostgreSQL build by setting these environment variables before running `devbox run setup`:

- **`PG_BUILDTYPE`**: Controls the Meson build type (default: `debug`)

  Example:
  ```bash
  PG_BUILDTYPE=release devbox run setup
  ```

## Working with Branches

Each git branch gets its own:
- Build directory
- Data directory
- Port number

This allows switching between branches without conflicts.
