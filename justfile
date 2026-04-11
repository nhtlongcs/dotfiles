set shell := ["bash", "-c"]

# Variables
default_version := "lts/*"

# Show help
help:
    @echo "Dotfiles Setup Commands"
    @echo ""
    @echo "Usage: just [recipe]"
    @echo ""
    @echo "Node.js Setup:"
    @echo "  setup                  Install nvm, Node.js (LTS), and configure npm"
    @echo "  setup-nodejs           Setup Node.js and npm (default: LTS)"
    @echo "  install-nvm            Install nvm only"
    @echo ""
    @echo "Shell Setup:"
    @echo "  setup-shell-tools      Install shfmt, shellcheck, starship"
    @echo "  setup-zsh              Setup oh-my-zsh with plugins"
    @echo "  format-shell           Format all shell scripts with shfmt"
    @echo "  lint-shell             Lint all shell scripts with shellcheck"
    @echo ""
    @echo "Examples:"
    @echo "  just setup"
    @echo "  just setup-nodejs 18"
    @echo "  just setup-zsh"
    @echo "  just format-shell"

# Default recipe
default: help

# Install everything
setup version=default_version:
    ./scripts/setup.sh {{ version }}

# Install nvm only
install-nvm:
    ./scripts/install-nvm.sh

# Setup Node.js and npm
setup-nodejs version=default_version:
    ./scripts/setup-nodejs.sh {{ version }}

# Setup specific Node versions
setup-node-18:
    ./scripts/setup-nodejs.sh 18

setup-node-20:
    ./scripts/setup-nodejs.sh 20

setup-node-22:
    ./scripts/setup-nodejs.sh 22

# Setup shell tools (shfmt, shellcheck, starship)
setup-shell-tools:
    ./scripts/setup-shell-tools.sh

# Setup oh-my-zsh with plugins
setup-zsh:
    ./scripts/setup-zsh.sh

# Format all shell scripts
format-shell:
    ./scripts/format-shell.sh

# Lint all shell scripts
lint-shell:
    ./scripts/lint-shell.sh
