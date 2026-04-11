#!/bin/bash
# Format all shell scripts in the project using shfmt
# Works with: bash, zsh, sh (POSIX shell formatter)

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# ============================================================================
# Helper Functions
# ============================================================================

log_success() {
  echo "✓ $1"
}

log_error() {
  echo "✗ $1"
}

log_info() {
  echo "ℹ $1"
}

# ============================================================================
# Check dependencies
# ============================================================================

check_shfmt() {
  if ! command -v shfmt &> /dev/null; then
    log_error "shfmt is not installed"
    echo ""
    echo "Install it with:"
    echo "  brew install shfmt      # macOS"
    echo "  apt install shfmt       # Linux"
    echo "  ./scripts/setup-shell-tools.sh"
    exit 1
  fi
}

# ============================================================================
# Format shell scripts
# ============================================================================

format_scripts() {
  local count=0
  local formatted=0
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Formatting shell scripts in: $PROJECT_DIR"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Find all shell scripts
  while IFS= read -r -d '' file; do
    ((count++))
    
    # Check if file needs formatting
    if ! shfmt -d "$file" &> /dev/null; then
      log_info "Formatting: $file"
      shfmt -i 2 -w "$file"
      ((formatted++))
    else
      log_success "Already formatted: $file"
    fi
  done < <(find "$PROJECT_DIR" -type f \( -name "*.sh" -o -name ".bashrc" -o -name ".zshrc" \) -print0)
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log_success "Formatting complete!"
  echo "  Total files found: $count"
  echo "  Files formatted: $formatted"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ============================================================================
# Main
# ============================================================================

main() {
  check_shfmt
  format_scripts
}

main
