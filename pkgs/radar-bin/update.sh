#!/usr/bin/env bash
set -euo pipefail

REPO="skyhook-io/radar"
REPO_ROOT="${UPDATE_NIX_CONFIG_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
PACKAGE_FILE="${REPO_ROOT}/pkgs/radar-bin/package.nix"

echo "Fetching latest Radar release..."
VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | jq -er '.tag_name | sub("^v"; "")')
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Unexpected release version: ${VERSION}" >&2
  exit 1
fi

CURRENT=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";.*/\1/p' "$PACKAGE_FILE")
if [[ -z "$CURRENT" ]]; then
  echo "Could not read package version" >&2
  exit 1
fi
if [[ "$VERSION" == "$CURRENT" ]]; then
  echo "Already up to date: ${VERSION}"
  exit 0
fi

echo "Updating ${CURRENT} -> ${VERSION}"
CHECKSUMS=$(curl -fsSL "https://github.com/${REPO}/releases/download/v${VERSION}/checksums.txt")

# Prepare all changes in a temporary copy so failures leave the package intact.
TMP_FILE=$(mktemp "${PACKAGE_FILE}.XXXXXX")
trap 'rm -f "$TMP_FILE"' EXIT
cp -p "$PACKAGE_FILE" "$TMP_FILE"

VERSION="$VERSION" perl -0pi -e '
  s/(version\s*=\s*")[^"]+(";)/$1 . $ENV{VERSION} . $2/e
    or die "Could not update version\n";
' "$TMP_FILE"

for system in x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin; do
  case "$system" in
    x86_64-linux) platform=linux_amd64 ;;
    aarch64-linux) platform=linux_arm64 ;;
    x86_64-darwin) platform=darwin_amd64 ;;
    aarch64-darwin) platform=darwin_arm64 ;;
  esac

  archive="radar_v${VERSION}_${platform}.tar.gz"
  checksum=$(printf '%s\n' "$CHECKSUMS" | awk -v name="$archive" '$2 == name { print $1 }')
  if [[ ! "$checksum" =~ ^[[:xdigit:]]{64}$ ]]; then
    echo "Missing or invalid SHA-256 checksum for ${archive}" >&2
    exit 1
  fi
  hash=$(nix hash convert --hash-algo sha256 --to sri "$checksum")

  SYSTEM="$system" HASH="$hash" perl -0pi -e '
    my $system = quotemeta $ENV{SYSTEM};
    s/($system\s*=\s*\{.*?hash\s*=\s*")[^"]+(";)/$1 . $ENV{HASH} . $2/se
      or die "Could not update hash for $ENV{SYSTEM}\n";
  ' "$TMP_FILE"
  echo "  ${system}: ${hash}"
done

mv "$TMP_FILE" "$PACKAGE_FILE"
trap - EXIT
echo "Updated ${PACKAGE_FILE} to ${VERSION}"
