#!/bin/bash
set -e

# Usage: ./scripts/generate-formula.sh <version> <sha256> <repo-url>
# Example: ./scripts/generate-formula.sh 1.0.0 abc123 https://github.com/fcrozetta/nvim-config

VERSION="${1:?Usage: $0 <version> <sha256> <repo-url>}"
SHA256="${2:?Usage: $0 <version> <sha256> <repo-url>}"
REPO_URL="${3:?Usage: $0 <version> <sha256> <repo-url>}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPS_FILE="$SCRIPT_DIR/../deps/brew.txt"

# Generate depends_on lines from brew.txt
DEPENDS=""
while IFS= read -r pkg || [ -n "$pkg" ]; do
  pkg="$(echo "$pkg" | xargs)"  # trim whitespace
  [ -z "$pkg" ] && continue
  [[ "$pkg" == \#* ]] && continue  # skip comments
  DEPENDS="${DEPENDS}  depends_on \"${pkg}\"
"
done < "$DEPS_FILE"

cat <<EOF
class NvimConfig < Formula
  desc "Personal Neovim configuration"
  homepage "${REPO_URL}"
  url "${REPO_URL}/archive/refs/tags/${VERSION}.tar.gz"
  sha256 "${SHA256}"
  license "MIT"

${DEPENDS}
  def install
    bin.install "setup.sh" => "nvim-config-setup"
    bin.install "scripts/uninstall.sh" => "nvim-config-uninstall"
    inreplace bin/"nvim-config-setup", /^SCRIPT_DIR=.*$/, "SCRIPT_DIR=\"#{opt_pkgshare}\""
    pkgshare.install Dir["*"], ".gitignore", ".neoconf.json"
  end

  def caveats
    <<~EOS
      Brew cannot write outside its prefix during install.
      Finish setup by running:

        nvim-config-setup

      This symlinks ~/.config/nvim (backing up any existing config),
      installs pnpm packages, and bootstraps Neovim plugins.

      Run 'nvim-config-uninstall' before 'brew uninstall' for full cleanup.
    EOS
  end
end
EOF
