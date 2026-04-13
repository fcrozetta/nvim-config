#!/bin/bash
set -euo pipefail

NVIM_DIR="$HOME/.config/nvim"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"

export PNPM_HOME
export PATH="$PNPM_HOME:$PATH"

echo "==> Neovim config uninstall"

echo "WARNING: This will remove:"
echo "  - ${NVIM_DIR} symlink"
echo "  - the most recent ${NVIM_DIR}.* backup, if one exists"
echo "  - Neovim data in ${XDG_DATA_HOME}/nvim"
echo "  - Neovim state in ${XDG_STATE_HOME}/nvim"
echo "  - Neovim cache in ${XDG_CACHE_HOME}/nvim"
echo "  - pnpm global Mermaid CLI package"

if [ "${NVIM_CONFIG_UNINSTALL_FORCE:-}" != "1" ] && [ -t 0 ]; then
  printf "Continue? [y/N] "
  read -r reply
  case "$reply" in
    y|Y|yes|YES)
      ;;
    *)
      echo "==> Aborted"
      exit 1
      ;;
  esac
fi

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
rm -rf "${XDG_DATA_HOME}/nvim" "${XDG_STATE_HOME}/nvim" "${XDG_CACHE_HOME}/nvim"

# --- Remove pnpm packages ---
if command -v pnpm &>/dev/null; then
  echo "==> Removing pnpm packages"
  pnpm remove -g @mermaid-js/mermaid-cli 2>/dev/null || true
fi

echo "==> Done. Run 'brew autoremove' to clean up orphaned brew dependencies."
