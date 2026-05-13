#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_FILE="$SCRIPT_DIR/cases.json"
RESULTS_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RUN_DIR="$RESULTS_DIR/$TIMESTAMP"

mkdir -p "$RUN_DIR"

TOTAL=$(jq '.cases | length' "$CASES_FILE")
PASSED=0
FAILED=0

echo "MECE Skill Eval Suite"
echo "====================="
echo "Cases: $TOTAL"
echo "Results: $RUN_DIR"
echo ""

for i in $(seq 0 $((TOTAL - 1))); do
  CASE_ID=$(jq -r ".cases[$i].id" "$CASES_FILE")
  DIMENSION=$(jq -r ".cases[$i].dimension" "$CASES_FILE")
  INPUT=$(jq -r ".cases[$i].input" "$CASES_FILE")
  DESCRIPTION=$(jq -r ".cases[$i].description" "$CASES_FILE")
  CRITERIA=$(jq -r ".cases[$i].criteria | join(\"\n- \")" "$CASES_FILE")

  echo "[$((i + 1))/$TOTAL] $CASE_ID ($DIMENSION)"
  echo "  Input: $INPUT"

  # Step 1: Run the MECE skill
  MECE_OUTPUT=$(claude -p "/mece $INPUT" 2>/dev/null || echo "ERROR: claude invocation failed")

  echo "$MECE_OUTPUT" > "$RUN_DIR/${CASE_ID}_output.txt"

  # Step 2: Grade the output
  GRADER_PROMPT=$(cat <<GRADE_EOF
You are a strict eval grader for a MECE decomposition skill.

## Test Case
- **ID:** $CASE_ID
- **Dimension:** $DIMENSION
- **Description:** $DESCRIPTION
- **Input given to skill:** $INPUT

## Required Criteria (ALL must pass)
- $CRITERIA

## Skill Output to Grade
$MECE_OUTPUT

## Instructions
Evaluate the skill output against EACH criterion. For each criterion, output PASS or FAIL with a one-line reason.

Then output a final verdict: PASS (all criteria met) or FAIL (any criterion not met).

Use this exact format:
CRITERION_1: PASS|FAIL — reason
CRITERION_2: PASS|FAIL — reason
...
VERDICT: PASS|FAIL
GRADE_EOF
)

  GRADE_RESULT=$(claude -p "$GRADER_PROMPT" 2>/dev/null || echo "VERDICT: ERROR — grader invocation failed")

  echo "$GRADE_RESULT" > "$RUN_DIR/${CASE_ID}_grade.txt"

  VERDICT=$(echo "$GRADE_RESULT" | grep -oE "VERDICT: (PASS|FAIL|ERROR)" | head -1 || echo "VERDICT: ERROR")

  if echo "$VERDICT" | grep -q "PASS"; then
    echo "  Result: PASS"
    PASSED=$((PASSED + 1))
  else
    echo "  Result: FAIL"
    FAILED=$((FAILED + 1))
  fi
  echo ""
done

# Summary
echo "====================="
echo "Results: $PASSED/$TOTAL passed, $FAILED failed"
echo "Details: $RUN_DIR"

# Write summary JSON
cat > "$RUN_DIR/summary.json" <<EOF
{
  "timestamp": "$TIMESTAMP",
  "total": $TOTAL,
  "passed": $PASSED,
  "failed": $FAILED,
  "pass_rate": $(echo "scale=2; $PASSED / $TOTAL" | bc)
}
EOF

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
