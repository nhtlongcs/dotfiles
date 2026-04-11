#!/bin/bash
# Main setup script for dotfiles

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
readonly NODE_VERSION="${1:-lts/*}"

# ============================================================================
# Helper Functions
# ============================================================================

log_step() {
  local step_num="$1"
  local step_desc="$2"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step $step_num: $step_desc"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_success() {
  echo "\n✓ $1"
}

# ============================================================================
# Main
# ============================================================================

echo "Starting dotfiles setup..."

log_step 1 "Installing nvm (Node Version Manager)"
bash "$SCRIPT_DIR/install-nvm.sh"

log_step 2 "Setting up Node.js and npm"
bash "$SCRIPT_DIR/setup-nodejs.sh" "$NODE_VERSION"

log_success "Setup completed!"
echo ""
echo "Please restart your terminal or run:"
echo "  source ~/.nvm/nvm.sh"
