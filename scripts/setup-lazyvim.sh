#!/bin/bash
# Clean existing Neovim environment, install Neovim >= 0.11.2 (no sudo), and install LazyVim

set -euo pipefail

readonly NVIM_DIST_DIR="$HOME/.local/lib/nvim-dist"
readonly NVIM_BIN="$HOME/.local/bin/nvim"
readonly NVIM_MIN_VERSION="0.11.2"

# ============================================================================
# Helper Functions
# ============================================================================

log_section() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_success() { echo "✓ $1"; }
log_error()   { echo "✗ $1" >&2; }
log_info()    { echo "ℹ $1"; }

# Returns 0 if $1 >= $2 (semver)
version_gte() {
  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# ============================================================================
# Install Neovim into $NVIM_DIST_DIR (no sudo, self-contained tarball)
# ============================================================================

install_neovim() {
  log_section "Installing Neovim >= $NVIM_MIN_VERSION (no sudo)"

  # Only skip if OUR managed install already exists and satisfies the minimum.
  # Never trust a random system nvim — it may be broken or missing runtime files.
  if [[ -x "$NVIM_DIST_DIR/bin/nvim" ]]; then
    local current_version
    current_version=$("$NVIM_DIST_DIR/bin/nvim" --version | head -1 | grep -oP '\d+\.\d+\.\d+' | head -1)
    if version_gte "$current_version" "$NVIM_MIN_VERSION"; then
      log_success "Neovim $current_version already installed at $NVIM_DIST_DIR, skipping"
      export PATH="$HOME/.local/bin:$PATH"
      return 0
    fi
    log_info "Existing install ($current_version) is too old — upgrading"
  else
    log_info "No managed Neovim install found — installing latest stable"
  fi

  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' EXIT

  local archive="nvim-linux-x86_64.tar.gz"
  # Use the 'stable' tag — guaranteed to be a proper release, not nightly
  local url="https://github.com/neovim/neovim/releases/download/stable/$archive"

  log_info "Downloading $url"
  curl -fsSL "$url" -o "$tmp_dir/$archive"

  # Wipe any previous install and extract into a dedicated directory.
  # Keeping everything under $NVIM_DIST_DIR means the binary finds its runtime
  # at ../share/nvim/runtime relative to itself — no $VIMRUNTIME hacks needed.
  rm -rf "$NVIM_DIST_DIR"
  mkdir -p "$NVIM_DIST_DIR"
  tar -xzf "$tmp_dir/$archive" -C "$NVIM_DIST_DIR" --strip-components=1
  log_success "Extracted to $NVIM_DIST_DIR"

  # Replace whatever is at ~/.local/bin/nvim (could be an old direct-copy binary)
  # with a symlink into our managed install.
  mkdir -p "$HOME/.local/bin"
  ln -sf "$NVIM_DIST_DIR/bin/nvim" "$NVIM_BIN"
  log_success "Symlinked: $NVIM_BIN -> $NVIM_DIST_DIR/bin/nvim"

  export PATH="$HOME/.local/bin:$PATH"
  log_success "Installed: $("$NVIM_DIST_DIR/bin/nvim" --version | head -1)"
}

# ============================================================================
# Clean Neovim config / plugin data (NOT the nvim-dist runtime install)
# ============================================================================

clean_neovim() {
  log_section "Cleaning existing Neovim config and plugin data"

  local dirs=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
  )

  for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]]; then
      rm -rf "$dir"
      log_success "Removed $dir"
    else
      log_info "Skipped (not found): $dir"
    fi
  done
}

# ============================================================================
# Install LazyVim starter
# ============================================================================

install_lazyvim() {
  log_section "Installing LazyVim starter"

  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  log_success "Cloned LazyVim starter to ~/.config/nvim"

  rm -rf "$HOME/.config/nvim/.git"
  log_success "Removed .git (ready to track in your own repo)"
}

# ============================================================================
# Main
# ============================================================================

main() {
  for cmd in git curl; do
    if ! command -v "$cmd" &> /dev/null; then
      log_error "$cmd is required but not installed."
      exit 1
    fi
  done

  echo "Setting up LazyVim..."

  install_neovim
  clean_neovim
  install_lazyvim

  log_section "Done!"
  echo ""
  echo "Ensure ~/.local/bin is first in your PATH (add to ~/.bashrc or ~/.zshrc):"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
  echo "Then run: nvim"
  echo "LazyVim will bootstrap itself on first launch."
  echo ""
}

main
