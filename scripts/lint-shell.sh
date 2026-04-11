#!/bin/bash
# Lint all shell scripts in the project using shellcheck
# Works with: bash, zsh, sh (POSIX shell linter)

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

check_shellcheck() {
  if ! command -v shellcheck &> /dev/null; then
    log_error "shellcheck is not installed"
    echo ""
    echo "Install it with:"
    echo "  brew install shellcheck      # macOS"
    echo "  apt install shellcheck       # Linux"
    echo "  ./scripts/setup-shell-tools.sh"
    exit 1
  fi
}

# ============================================================================
# Lint shell scripts
# ============================================================================

lint_scripts() {
  local count=0
  local passed=0
  local failed=0
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Linting shell scripts in: $PROJECT_DIR"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Find all shell scripts
  while IFS= read -r -d '' file; do
    ((count++))
    
    if shellcheck "$file"; then
      log_success "Passed: $file"
      ((passed++))
    else
      log_error "Failed: $file"
      ((failed++))
    fi
  done < <(find "$PROJECT_DIR" -type f \( -name "*.sh" -o -name ".bashrc" -o -name ".zshrc" \) -print0)
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Linting Results:"
  echo "  Total files checked: $count"
  echo "  Passed: $passed"
  echo "  Failed: $failed"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  if [[ $failed -gt 0 ]]; then
    exit 1
  fi
}

# ============================================================================
# Main
# ============================================================================

main() {
  check_shellcheck
  lint_scripts
}

main
