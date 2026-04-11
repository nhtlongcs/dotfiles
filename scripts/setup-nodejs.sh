#!/bin/bash
# Setup Node.js using nvm and configure npm

set -euo pipefail

readonly NVM_DIR="${HOME}/.nvm"
readonly NODE_VERSION="${1:-lts/*}"

# ============================================================================
# Helper Functions
# ============================================================================

# Check if nvm is installed
check_nvm_installed() {
  if [[ ! -d "$NVM_DIR" ]]; then
    echo "✗ Error: nvm is not installed"
    echo "  Please run: ./scripts/install-nvm.sh"
    exit 1
  fi
}

# Load nvm
load_nvm() {
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

# Setup Node.js version
setup_nodejs() {
  echo "Installing Node.js $NODE_VERSION..."
  nvm install "$NODE_VERSION"
  nvm use "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
  
  echo "\n✓ Node.js installed and set as default"
  node --version
  npm --version
}

# Configure npm
configure_npm() {
  echo "\nConfiguring npm..."
  npm config set save-exact false
  echo "✓ npm configured"
}

# ============================================================================
# Main
# ============================================================================

check_nvm_installed
load_nvm
setup_nodejs
configure_npm
