#!/bin/bash
# Install nvm (Node Version Manager)

set -euo pipefail

readonly NVM_DIR="${HOME}/.nvm"
readonly NVM_VERSION="v0.39.0"
readonly NVM_REPO="https://raw.githubusercontent.com/nvm-sh/nvm"

# Check if nvm is already installed
if [[ -d "$NVM_DIR" ]]; then
  echo "✓ nvm is already installed at $NVM_DIR"
  exit 0
fi

echo "Installing nvm ($NVM_VERSION)..."

# Download and install nvm
if ! command -v curl &> /dev/null; then
  echo "✗ Error: curl is required to install nvm"
  exit 1
fi

curl -o- "${NVM_REPO}/${NVM_VERSION}/install.sh" | bash

# Load nvm
export NVM_DIR="$NVM_DIR"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

echo "✓ nvm installed successfully"
echo "\nPlease restart your terminal or run:"
echo "  source $NVM_DIR/nvm.sh"
