#!/bin/bash
# Setup oh-my-zsh with plugins and theme
# ZSH-SPECIFIC: This script configures the Z shell (zsh) only

set -euo pipefail

readonly OMZ_DIR="${HOME}/.oh-my-zsh"
readonly PLUGINS_DIR="${OMZ_DIR}/custom/plugins"

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

log_info() {
  echo "ℹ $1"
}

command_exists() {
  command -v "$1" &> /dev/null
}

# ============================================================================
# Install oh-my-zsh
# ============================================================================

install_oh_my_zsh() {
  log_section "Installing oh-my-zsh"

  if [[ -d "$OMZ_DIR" ]]; then
    log_success "oh-my-zsh is already installed"
    return 0
  fi

  if ! command_exists zsh; then
    log_info "Installing zsh first..."
    if command_exists brew; then
      brew install zsh
    elif command_exists apt; then
      sudo apt-get install -y zsh
    fi
  fi

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log_success "oh-my-zsh installed"
}

# ============================================================================
# Install plugins
# ============================================================================

install_plugins() {
  log_section "Installing zsh plugins"

  mkdir -p "$PLUGINS_DIR"

  # zsh-autosuggestions
  if [[ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
    log_success "Installed zsh-autosuggestions"
  else
    log_success "zsh-autosuggestions already installed"
  fi

  # zsh-syntax-highlighting
  if [[ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
    log_success "Installed zsh-syntax-highlighting"
  else
    log_success "zsh-syntax-highlighting already installed"
  fi
}

# ============================================================================
# Configure .zshrc
# ============================================================================

configure_zshrc() {
  log_section "Configuring .zshrc"

  local zshrc="${HOME}/.zshrc"

  # Backup original
  if [[ -f "$zshrc" ]]; then
    cp "$zshrc" "${zshrc}.backup.$(date +%s)"
    log_info "Backed up original .zshrc"
  fi

  # Add plugins to oh-my-zsh config if not already present
  if grep -q "^plugins=" "$zshrc"; then
    log_info ".zshrc already configured with plugins"
  else
    log_info "Adding plugins configuration to .zshrc"
    cat >> "$zshrc" << 'EOF'

# Oh My Zsh plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  brew
  npm
  node
)
EOF
  fi

  log_success ".zshrc configured"
}

# ============================================================================
# Main
# ============================================================================

main() {
  echo "Setting up oh-my-zsh..."
  echo ""

  install_oh_my_zsh
  install_plugins
  configure_zshrc

  log_section "Setup completed!"
  echo ""
  echo "Next steps:"
  echo "  1. Restart your terminal or run: exec zsh"
  echo "  2. Customize theme in ~/.zshrc (ZSH_THEME variable)"
  echo "  3. Popular themes: spaceship, powerlevel10k, agnoster"
  echo ""
}

main
