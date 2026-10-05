#!/usr/bin/env bash
set -euo pipefail

# PR Review — Automated pull request review helper
# Usage: pr-review.sh <PR_NUMBER> [REPO]
# Requires: gh CLI authenticated

REPO="${2:-}"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: pr-review.sh <PR_NUMBER> [REPO]"
  echo "Example: pr-review.sh 123 owner/repo"
  exit 0
fi

if [[ -z "${1:-}" ]]; then
  echo "Usage: pr-review.sh <PR_NUMBER> [REPO]"
  exit 1
fi

PR_NUMBER="$1"

if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI not found. Install from https://cli.github.com/"
  exit 1
fi

echo "=== PR Review: #${PR_NUMBER} ==="

# Get PR info
if [[ -n "$REPO" ]]; then
  PR_DATA=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json title,author,body,additions,deletions,changedFiles,state,url)
else
  PR_DATA=$(gh pr view "$PR_NUMBER" --json title,author,body,additions,deletions,changedFiles,state,url)
fi

TITLE=$(echo "$PR_DATA" | jq -r '.title')
AUTHOR=$(echo "$PR_DATA" | jq -r '.author.login')
BODY=$(echo "$PR_DATA" | jq -r '.body')
ADDITIONS=$(echo "$PR_DATA" | jq -r '.additions')
DELETIONS=$(echo "$PR_DATA" | jq -r '.deletions')
CHANGED_FILES=$(echo "$PR_DATA" | jq -r '.changedFiles')
STATE=$(echo "$PR_DATA" | jq -r '.state')
URL=$(echo "$PR_DATA" | jq -r '.url')

echo "Title:    $TITLE"
echo "Author:   $AUTHOR"
echo "State:    $STATE"
echo "Files:    $CHANGED_FILES"
echo "Diff:     +${ADDITIONS} -${DELETIONS}"
echo "URL:      $URL"
echo ""

# Check for common issues
ISSUES=()

# Check PR title length
if [[ ${#TITLE} -gt 72 ]]; then
  ISSUES+=("PR title exceeds 72 characters (${#TITLE})")
fi

# Check for empty body
if [[ -z "$BODY" || "$BODY" == "null" ]]; then
  ISSUES+=("PR body is empty — add a description")
fi

# Check for large PRs
TOTAL_CHANGES=$((ADDITIONS + DELETIONS))
if [[ $TOTAL_CHANGES -gt 500 ]]; then
  ISSUES+=("Large PR: ${TOTAL_CHANGES} changes — consider splitting")
fi

# Check for WIP in title
if echo "$TITLE" | grep -qiE '\b(WIP|DO NOT MERGE|FIXME)\b'; then
  ISSUES+=("PR title contains WIP/DO NOT MERGE/FIXME")
fi

# Get changed files for pattern checks
if [[ -n "$REPO" ]]; then
  FILES=$(gh pr diff "$PR_NUMBER" --repo "$REPO" --name-only)
else
  FILES=$(gh pr diff "$PR_NUMBER" --name-only)
fi

# Check for merge conflict markers
if echo "$FILES" | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then
  ISSUES+=("Merge conflict markers detected")
fi

# Check for secrets patterns in changed files
if echo "$FILES" | grep -qiE '\.(env|pem|key|p12|pfx)$'; then
  ISSUES+=("Potentially sensitive files changed (.env/.pem/.key)")
fi

# Check for TODO/FIXME in changed files
if echo "$FILES" | grep -qE '(TODO|FIXME|HACK|XXX)'; then
  ISSUES+=("TODO/FIXME markers in changed files")
fi

# Output results
if [[ ${#ISSUES[@]} -eq 0 ]]; then
  echo "✅ No issues found — PR looks good!"
else
  echo "⚠️  Found ${#ISSUES[@]} issue(s):"
  for issue in "${ISSUES[@]}"; do
    echo "  - $issue"
  done
fi

echo ""
echo "=== Review Complete ==="
