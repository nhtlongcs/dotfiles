# Dotfiles

My personal dotfiles and setup scripts.

![](assets/image.jpeg)

## Quick Setup

### Using Make

```bash
make setup              # Install everything (nvm + Node LTS + npm)
make install-nvm       # Install nvm only
make setup-nodejs      # Setup Node.js and npm
make setup-nodejs-18   # Setup Node.js 18
make help              # Show all available commands
```

### Using Just

```bash
just setup             # Install everything (nvm + Node LTS + npm)
just install-nvm       # Install nvm only
just setup-nodejs      # Setup Node.js and npm
just setup-node-18     # Setup Node.js 18
just setup-node-20     # Setup Node.js 20
just help              # Show all available commands
```

### Using scripts directly

```bash
./scripts/setup.sh              # Install everything
./scripts/install-nvm.sh        # Install nvm only
./scripts/setup-nodejs.sh       # Setup Node.js and npm (LTS)
./scripts/setup-nodejs.sh 18    # Setup Node.js 18
```

## Shell Setup

Setup shell formatting, linting, and terminal tools:

### Tools Overview

| Tool | Type | Bash | Zsh | Purpose |
|------|------|------|-----|---------|
| **shfmt** | Formatter | ✓ | ✓ | Format shell scripts |
| **shellcheck** | Linter | ✓ | ✓ | Lint shell scripts for best practices |
| **starship** | Prompt | ✓ | ✓ | Cross-shell prompt (bash, zsh, fish, etc) |
| **oh-my-zsh** | Framework | ✗ | ✓ | ZSH-specific plugin framework |
| **zsh-autosuggestions** | Plugin | ✗ | ✓ | ZSH-specific plugin for suggestions |
| **zsh-syntax-highlighting** | Plugin | ✗ | ✓ | ZSH-specific plugin for syntax colors |

### Installation

#### For both Bash and Zsh

```bash
# Install shell formatting & linting tools
make setup-shell-tools
# or
just setup-shell-tools

# Script:
./scripts/setup-shell-tools.sh
```

#### For Zsh only

```bash
# Setup oh-my-zsh with plugins
make setup-zsh
# or
just setup-zsh

# Script:
./scripts/setup-zsh.sh
```

### Usage

#### Format shell scripts (Bash & Zsh)

```bash
make format-shell
# or
just format-shell

# Script:
./scripts/format-shell.sh
```

#### Lint shell scripts (Bash & Zsh)

```bash
make lint-shell
# or
just lint-shell

# Script:
./scripts/lint-shell.sh
```

## Notes

- Make sure scripts are executable: `chmod +x scripts/*.sh`
- Some installations may require `sudo` for system-level packages
- After running setup scripts, restart your terminal to ensure environment variables are loaded
- `shfmt` formats shell scripts with consistent style
- `shellcheck` lints shell scripts for best practices
- `starship` provides a cross-shell prompt