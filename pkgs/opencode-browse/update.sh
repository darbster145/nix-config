#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${UPDATE_NIX_CONFIG_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
PACKAGE_FILE="${REPO_ROOT}/pkgs/opencode-browse/package.nix"
REGISTRY="https://registry.npmjs.org/@opencode"

echo "Fetching latest browse release..."
VERSION=$(curl -fsSL "${REGISTRY}/browse-darwin-arm64/latest" | jq -er '.version')
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
    x86_64-linux) target=linux-x64 ;;
    aarch64-linux) target=linux-arm64 ;;
    x86_64-darwin) target=darwin-x64 ;;
    aarch64-darwin) target=darwin-arm64 ;;
  esac

  hash=$(curl -fsSL "${REGISTRY}/browse-${target}/${VERSION}" | jq -er '.dist.integrity')
  if [[ ! "$hash" =~ ^sha512- ]]; then
    echo "Missing or invalid integrity for browse-${target}@${VERSION}" >&2
    exit 1
  fi

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
