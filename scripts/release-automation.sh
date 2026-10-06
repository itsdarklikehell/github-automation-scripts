#!/usr/bin/env bash
set -euo pipefail

# Release Automation — Create a new release with changelog
# Usage: release-automation.sh <VERSION> [REPO]
# Requires: gh CLI authenticated

REPO="${2:-}"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: release-automation.sh <VERSION> [REPO]"
  echo "Example: release-automation.sh v1.2.0"
  echo ""
  echo "Options:"
  echo "  -h, --help  Show this help message"
  exit 0
fi

if [[ -z "${1:-}" ]]; then
  echo "Usage: release-automation.sh <VERSION> [REPO]"
  echo "Example: release-automation.sh v1.2.0"
  exit 1
fi

VERSION="$1"

if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI not found. Install from https://cli.github.com/"
  exit 1
fi

echo "=== Release Automation: $VERSION ==="

# Get the latest tag
LATEST_TAG=$(gh api "repos/{owner}/{repo}/tags" --jq '.[0].name' 2>/dev/null || echo "")

# Generate changelog from commits since last tag
if [[ -n "$LATEST_TAG" ]]; then
  echo "Generating changelog since $LATEST_TAG..."
  CHANGELOG=$(gh api "repos/{owner}/{repo}/compare/${LATEST_TAG}...HEAD" \
    --jq '.commits[] | "- \(.commit.message | split("\n")[0])"')
else
  echo "Generating changelog from all commits..."
  CHANGELOG=$(gh api "repos/{owner}/{repo}/commits" \
    --jq '.[0:20][] | "- \(.commit.message | split("\n")[0])"')
fi

echo ""
echo "Changelog:"
echo "$CHANGELOG"
echo ""

# Create release
if [[ -n "$REPO" ]]; then
  gh release create "$VERSION" \
    --repo "$REPO" \
    --title "Release $VERSION" \
    --notes "$CHANGELOG" \
    --generate-notes
else
  gh release create "$VERSION" \
    --title "Release $VERSION" \
    --notes "$CHANGELOG" \
    --generate-notes
fi

echo ""
echo "✅ Release $VERSION created!"
echo "=== Release Complete ==="
