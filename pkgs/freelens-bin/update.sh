#!/usr/bin/env bash
set -euo pipefail

REPO="freelensapp/freelens"
PACKAGE_FILE="$(dirname "$0")/package.nix"

echo "Fetching latest version..."
VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | jq -r .tag_name | sed 's/^v//')

CURRENT=$(grep 'version = ' "$PACKAGE_FILE" | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

if [[ "$VERSION" == "$CURRENT" ]]; then
  echo "Already up to date: ${VERSION}"
  exit 0
fi

echo "Updating ${CURRENT} -> ${VERSION}"

fetch_hash() {
  nix store prefetch-file --hash-type sha256 --json "$1" | jq -r .hash
}

BASE="https://github.com/${REPO}/releases/download/v${VERSION}"

echo "x86_64-linux:   $(fetch_hash "${BASE}/Freelens-${VERSION}-linux-amd64.AppImage")"
echo "aarch64-linux:  $(fetch_hash "${BASE}/Freelens-${VERSION}-linux-arm64.AppImage")"
echo "x86_64-darwin:  $(fetch_hash "${BASE}/Freelens-${VERSION}-macos-amd64.dmg")"
echo "aarch64-darwin: $(fetch_hash "${BASE}/Freelens-${VERSION}-macos-arm64.dmg")"
