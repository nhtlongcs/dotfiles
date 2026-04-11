#!/bin/bash
# Install and setup shell formatters and utilities
# Tools: shfmt (bash/zsh/sh), shellcheck (bash/zsh/sh), starship (bash/zsh/fish/etc)

set -euo pipefail

# ============================================================================
# Helper Functions
# ============================================================================

log_section() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_success() {
  echo "✓ $1"
}

log_error() {
  echo "✗ $1"
}

log_info() {
  echo "ℹ $1"
}

command_exists() {
  command -v "$1" &> /dev/null
}

# ============================================================================
# Install shfmt (Shell formatter)
# ============================================================================

install_shfmt() {
  log_section "Installing shfmt (Shell formatter)"
  
  if command_exists shfmt; then
    log_success "shfmt is already installed"
    shfmt --version
    return 0
  fi
  
  if command_exists brew; then
    brew install shfmt
    log_success "shfmt installed via Homebrew"
  elif command_exists apt-get; then
    log_error "Automatic install via apt-get is disabled by policy"
    log_info "Please install shfmt manually using your system package workflow"
    return 1
  else
    log_error "Please install shfmt manually: https://github.com/mvdan/sh"
    return 1
  fi
}

# ============================================================================
# Install shellcheck (Shell linter)
# ============================================================================

install_shellcheck() {
  log_section "Installing shellcheck (Shell linter)"
  
  if command_exists shellcheck; then
    log_success "shellcheck is already installed"
    shellcheck --version
    return 0
  fi
  
  if command_exists brew; then
    brew install shellcheck
    log_success "shellcheck installed via Homebrew"
  elif command_exists apt-get; then
    log_error "Automatic install via apt-get is disabled by policy"
    log_info "Please install shellcheck manually using your system package workflow"
    return 1
  else
    log_error "Please install shellcheck manually: https://github.com/koalaman/shellcheck"
    return 1
  fi
}

# ============================================================================
# Install starship (Fancy prompt)
# ============================================================================

install_starship() {
  log_section "Installing starship (Cross-shell prompt)"
  
  if command_exists starship; then
    log_success "starship is already installed"
    starship --version
    return 0
  fi
  
  if command_exists brew; then
    brew install starship
    log_success "starship installed via Homebrew"
  elif command_exists apt-get; then
    log_error "Automatic install via apt-get is disabled by policy"
    log_info "Please install starship manually using your system package workflow"
    return 1
  else
    # Install from releases
    curl -sS https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin"
    log_success "starship installed from releases"
  fi
}

# ============================================================================
# Main
# ============================================================================

main() {
  echo "Setting up shell formatting and utilities..."
  
  install_shfmt
  install_shellcheck
  install_starship
  
  log_section "Setup completed!"
  echo ""
  echo "Next steps:"
  echo "  1. Format shell scripts: shfmt -i 2 -w script.sh"
  echo "  2. Lint shell scripts: shellcheck script.sh"
  echo "  3. Initialize starship: follow https://starship.rs/guide/"
  echo ""
}

main
