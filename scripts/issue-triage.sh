#!/usr/bin/env bash
set -euo pipefail

# Issue Triage — Automated issue triage helper
# Usage: issue-triage.sh [REPO]
# Requires: gh CLI authenticated

REPO="${1:-}"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: issue-triage.sh [REPO]"
  echo "Example: issue-triage.sh owner/repo"
  exit 0
fi

if ! command -v gh &>/dev/null; then
  echo "Usage: issue-triage.sh [REPO]"
  echo "Error: gh CLI not found. Install from https://cli.github.com/"
  exit 1
fi

echo "=== Issue Triage ==="

# Get open issues
if [[ -n "$REPO" ]]; then
  ISSUES=$(gh issue list --repo "$REPO" --state open --json number,title,labels,createdAt,author --limit 50)
else
  ISSUES=$(gh issue list --state open --json number,title,labels,createdAt,author --limit 50)
fi

TOTAL=$(echo "$ISSUES" | jq 'length')
echo "Found $TOTAL open issues"
echo ""

# Categorize issues
BUGS=()
ENHANCEMENTS=()
DOCS=()
OTHER=()

for i in $(seq 0 $((TOTAL - 1))); do
  TITLE=$(echo "$ISSUES" | jq -r ".[$i].title")
  LABELS=$(echo "$ISSUES" | jq -r ".[$i].labels[].name" 2>/dev/null || echo "")
  NUMBER=$(echo "$ISSUES" | jq -r ".[$i].number")

  if echo "$LABELS" | grep -qiE 'bug|crash|error|broken'; then
    BUGS+=("#$NUMBER: $TITLE")
  elif echo "$LABELS" | grep -qiE 'enhancement|feature|request'; then
    ENHANCEMENTS+=("#$NUMBER: $TITLE")
  elif echo "$LABELS" | grep -qiE 'doc|documentation|readme'; then
    DOCS+=("#$NUMBER: $TITLE")
  else
    OTHER+=("#$NUMBER: $TITLE")
  fi
done

echo "🐛 Bugs (${#BUGS[@]}):"
for bug in "${BUGS[@]}"; do echo "  - $bug"; done
echo ""

echo "✨ Enhancements (${#ENHANCEMENTS[@]}):"
for enh in "${ENHANCEMENTS[@]}"; do echo "  - $enh"; done
echo ""

echo "📝 Documentation (${#DOCS[@]}):"
for doc in "${DOCS[@]}"; do echo "  - $doc"; done
echo ""

echo "📋 Other (${#OTHER[@]}):"
for oth in "${OTHER[@]}"; do echo "  - $oth"; done

echo ""
echo "=== Triage Complete ==="
