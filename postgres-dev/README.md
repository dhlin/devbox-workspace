# PostgreSQL Development Environment

A Devbox environment for building and running PostgreSQL from source.

## Features

- Uses PostgreSQL's [Meson](https://mesonbuild.com/) build system for faster, modern builds
- Branch-specific build and isolated PostgreSQL services
- Integrated [hackorum-patch](https://hackorum.dev/) for applying patches from the PostgreSQL mailing list directly

## Prerequisites

- [Devbox](https://www.jetify.com/devbox) installed

## Quick Start

> **Important:** All `devbox` commands must be run from the root of a PostgreSQL source checkout

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
devbox run start

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
