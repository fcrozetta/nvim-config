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

# Brew dependencies are installed by the formula's `depends_on`; this script
# only does the post-install steps that brew's sandbox cannot perform.

# --- Symlink config ---
if [ "$SCRIPT_DIR" != "$NVIM_DIR" ]; then
  if [ -L "$NVIM_DIR" ]; then
    rm "$NVIM_DIR"
  elif [ -e "$NVIM_DIR" ]; then
    BACKUP="${NVIM_DIR}.$(date +%Y%m%d%H%M%S)"
    echo "==> Backing up existing config to ${BACKUP}"
    mv "$NVIM_DIR" "$BACKUP"
  fi
  mkdir -p "$(dirname "$NVIM_DIR")"
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

# --- Neovim headless setup ---
echo "==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "==> Installing Treesitter parsers..."
nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true

echo "==> Done. Mason LSP servers install on first launch."
