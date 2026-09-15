#!/usr/bin/env bash
set -euo pipefail

REPO="freelensapp/freelens"
REPO_ROOT="${UPDATE_NIX_CONFIG_ROOT:-$(git rev-parse --show-toplevel)}"
PACKAGE_FILE="${REPO_ROOT}/pkgs/freelens-bin/package.nix"

echo "Fetching latest version..."
VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | jq -er '.tag_name | sub("^v"; "")')

CURRENT=$(grep 'version = ' "$PACKAGE_FILE" | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

if [[ "$VERSION" == "$CURRENT" ]]; then
  echo "Already up to date: ${VERSION}"
  exit 0
fi

echo "Updating ${CURRENT} -> ${VERSION}"

fetch_hash() {
  local checksum_url="$1.sha256"
  local checksum

  checksum=$(curl -fsSL "$checksum_url" | awk '{ print $1 }')
  nix hash convert --hash-algo sha256 --to sri "$checksum"
}

BASE="https://github.com/${REPO}/releases/download/v${VERSION}"

X86_64_LINUX_HASH=$(fetch_hash "${BASE}/Freelens-${VERSION}-linux-amd64.AppImage")
AARCH64_LINUX_HASH=$(fetch_hash "${BASE}/Freelens-${VERSION}-linux-arm64.AppImage")
X86_64_DARWIN_HASH=$(fetch_hash "${BASE}/Freelens-${VERSION}-macos-amd64.dmg")
AARCH64_DARWIN_HASH=$(fetch_hash "${BASE}/Freelens-${VERSION}-macos-arm64.dmg")

TMP_FILE=$(mktemp "${PACKAGE_FILE}.XXXXXX")
trap 'rm -f "$TMP_FILE"' EXIT
cp -p "$PACKAGE_FILE" "$TMP_FILE"

replace_version() {
  VERSION="$VERSION" perl -0pi -e '
    s/(version\s*=\s*")[^"]+(";)/$1 . $ENV{VERSION} . $2/e
      or die "Could not update version\n";
  ' "$TMP_FILE"
}

replace_hash() {
  local system="$1"
  local hash="$2"

  SYSTEM="$system" HASH="$hash" perl -0pi -e '
    my $system = quotemeta $ENV{SYSTEM};
    s/($system\s*=\s*\{.*?hash\s*=\s*")[^"]+(";)/$1 . $ENV{HASH} . $2/se
      or die "Could not update hash for $ENV{SYSTEM}\n";
  ' "$TMP_FILE"
}

replace_version
replace_hash x86_64-linux "$X86_64_LINUX_HASH"
replace_hash aarch64-linux "$AARCH64_LINUX_HASH"
replace_hash x86_64-darwin "$X86_64_DARWIN_HASH"
replace_hash aarch64-darwin "$AARCH64_DARWIN_HASH"

mv "$TMP_FILE" "$PACKAGE_FILE"
trap - EXIT

echo "Updated ${PACKAGE_FILE} to ${VERSION}:"
echo "  x86_64-linux:   ${X86_64_LINUX_HASH}"
echo "  aarch64-linux:  ${AARCH64_LINUX_HASH}"
echo "  x86_64-darwin:  ${X86_64_DARWIN_HASH}"
echo "  aarch64-darwin: ${AARCH64_DARWIN_HASH}"
