#!/bin/bash
set -e

NVIM_DIR="$HOME/.config/nvim"

echo "==> Neovim config uninstall"

# --- Remove symlink ---
if [ -L "$NVIM_DIR" ]; then
  echo "==> Removing config symlink"
  rm "$NVIM_DIR"
fi

# --- Restore most recent backup if one exists ---
LATEST_BACKUP="$(ls -d "${NVIM_DIR}".* 2>/dev/null | sort -r | head -1)"
if [ -n "$LATEST_BACKUP" ]; then
  echo "==> Restoring backup: ${LATEST_BACKUP}"
  mv "$LATEST_BACKUP" "$NVIM_DIR"
else
  echo "==> No backup found to restore"
fi

# --- Remove plugin data ---
echo "==> Cleaning plugin data"
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# --- Remove npm packages ---
if command -v npm &>/dev/null; then
  echo "==> Removing npm global packages"
  npm uninstall -g @mermaid-js/mermaid-cli 2>/dev/null || true
fi

echo "==> Done. Run 'brew autoremove' to clean up orphaned brew dependencies."
