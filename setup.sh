#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"
DEPS_DIR="$SCRIPT_DIR/deps"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"

export PNPM_HOME
export PATH="$PNPM_HOME:$PATH"

echo "==> Neovim config setup"

# --- Install mode: skip brew deps if called from formula ---
if [ "${HOMEBREW_FORMULA:-}" != "1" ]; then
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

# --- pnpm packages ---
if command -v pnpm &>/dev/null; then
  echo "==> Installing pnpm packages..."
  mkdir -p "$PNPM_HOME"
  xargs pnpm add -g < "$DEPS_DIR/npm.txt"
else
  echo "WARNING: pnpm not found, skipping pnpm packages"
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
