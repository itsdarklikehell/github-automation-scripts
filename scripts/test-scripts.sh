#!/usr/bin/env bash
set -euo pipefail

# Test suite for github-automation-scripts
# Run: bash scripts/test-scripts.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSED=0
FAILED=0

pass() {
  echo "  ✅ PASS: $1"
  PASSED=$((PASSED + 1))
}

fail() {
  echo "  ❌ FAIL: $1"
  FAILED=$((FAILED + 1))
}

echo "=== GitHub Automation Scripts Test Suite ==="
echo ""

# Test 1: All scripts exist and are executable
echo "Test 1: Script existence and permissions"
for script in pr-review.sh issue-triage.sh release-automation.sh; do
  if [[ -f "$SCRIPT_DIR/$script" ]]; then
    pass "$script exists"
  else
    fail "$script missing"
  fi

  if [[ -x "$SCRIPT_DIR/$script" ]]; then
    pass "$script is executable"
  else
    fail "$script is not executable"
  fi
done
echo ""

# Test 2: Bash syntax check
echo "Test 2: Bash syntax"
for script in "$SCRIPT_DIR"/*.sh; do
  if bash -n "$script" 2>/dev/null; then
    pass "$(basename "$script") syntax OK"
  else
    fail "$(basename "$script") syntax error"
  fi
done
echo ""

# Test 3: Shellcheck (if available)
echo "Test 3: Shellcheck"
if command -v shellcheck &>/dev/null; then
  for script in "$SCRIPT_DIR"/*.sh; do
    if shellcheck "$script" &>/dev/null; then
      pass "$(basename "$script") shellcheck clean"
    else
      # Shellcheck warnings are not failures, just informational
      echo "  ℹ️  $(basename "$script") has shellcheck warnings (non-blocking)"
    fi
  done
else
  echo "  ℹ️  shellcheck not installed, skipping"
fi
echo ""

# Test 4: Help/usage output
echo "Test 4: Usage output"
# Scripts with required args should show usage on no args
for script in pr-review.sh release-automation.sh; do
  OUTPUT=$(bash "$SCRIPT_DIR/$script" 2>&1 || true)
  if echo "$OUTPUT" | grep -qi "usage"; then
    pass "$script shows usage on no args"
  else
    fail "$script missing usage message"
  fi
done

# Scripts with optional args should show usage on --help
for script in pr-review.sh issue-triage.sh release-automation.sh; do
  OUTPUT=$(bash "$SCRIPT_DIR/$script" --help 2>&1 || true)
  if echo "$OUTPUT" | grep -qi "usage"; then
    pass "$script --help works"
  else
    fail "$script --help missing"
  fi
done
echo ""

# Test 5: Required tools check
echo "Test 5: Required tools"
for tool in gh jq; do
  if command -v "$tool" &>/dev/null; then
    pass "$tool is installed"
  else
    echo "  ⚠️  $tool is not installed (required for full functionality)"
  fi
done
echo ""

# Test 6: README exists and has content
echo "Test 6: Documentation"
if [[ -f "$SCRIPT_DIR/../README.md" ]]; then
  pass "README.md exists"
  LINES=$(wc -l < "$SCRIPT_DIR/../README.md")
  if [[ $LINES -gt 20 ]]; then
    pass "README.md has content ($LINES lines)"
  else
    fail "README.md too short ($LINES lines)"
  fi
else
  fail "README.md missing"
fi
echo ""

# Summary
TOTAL=$((PASSED + FAILED))
echo "=== Test Summary ==="
echo "Total:  $TOTAL"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [[ $FAILED -gt 0 ]]; then
  echo ""
  echo "❌ Some tests failed!"
  exit 1
else
  echo ""
  echo "✅ All tests passed!"
  exit 0
fi
