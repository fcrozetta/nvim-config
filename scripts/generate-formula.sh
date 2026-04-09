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
    pkgshare.install Dir["*"], ".gitignore", ".neoconf.json"
    bin.install "setup.sh" => "nvim-config-setup"
    inreplace bin/"nvim-config-setup", /^SCRIPT_DIR=.*$/, "SCRIPT_DIR=\"#{pkgshare}\""
  end

  def post_install
    ENV["HOMEBREW_FORMULA"] = "1"
    system bin/"nvim-config-setup"
    unless quiet_system "python3", "--version"
      system "uv", "python", "install", "3.12", "--default"
    end
  end

  def caveats
    <<~EOS
      Config symlinked to ~/.config/nvim
      Run 'nvim-config-setup' to re-link after upgrades.
    EOS
  end
end
EOF
