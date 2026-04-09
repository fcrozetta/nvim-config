#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"
DEPS_DIR="$SCRIPT_DIR/deps"

echo "==> Neovim config setup"

# --- Install mode: skip brew deps if called from formula ---
if [ "${HOMEBREW_FORMULA:-}" != "1" ]; then

  # --- Homebrew ---
  if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "==> Installing brew packages..."
  xargs brew install < "$DEPS_DIR/brew.txt"

fi

# --- Symlink config ---
if [ "$SCRIPT_DIR" != "$NVIM_DIR" ]; then
  if [ -d "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
    BACKUP="${NVIM_DIR}.$(date +%Y%m%d)"
    echo "==> Backing up existing config to ${BACKUP}"
    mv "$NVIM_DIR" "$BACKUP"
  fi
  echo "==> Linking config to ${NVIM_DIR}"
  ln -sfn "$SCRIPT_DIR" "$NVIM_DIR"
fi

# --- npm packages ---
if command -v npm &>/dev/null; then
  echo "==> Installing npm global packages..."
  xargs npm install -g < "$DEPS_DIR/npm.txt"
else
  echo "WARNING: npm not found, skipping npm packages"
fi

# --- Skip headless Neovim setup when called from Homebrew formula ---
if [ "${HOMEBREW_FORMULA:-}" = "1" ]; then
  echo "==> Done (Homebrew). Mason LSP servers install on first launch."
  exit 0
fi

# --- Neovim headless setup ---
echo "==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "==> Installing Treesitter parsers..."
nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true

echo "==> Done. Mason LSP servers install on first launch."
