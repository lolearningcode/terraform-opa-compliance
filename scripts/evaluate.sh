#!/bin/bash
set -e

# Default to the main terraform plan if no argument provided
PLAN_FILE=${1:-"terraform/tfplan.json"}

if [[ ! -f "$PLAN_FILE" ]]; then
  echo "Error: Plan file '$PLAN_FILE' not found"
  echo "Usage: ./evaluate.sh [plan.json]"
  exit 1
fi

echo "🔍 Evaluating Terraform plan: $PLAN_FILE"
echo "📋 Running all OPA policies..."
echo ""

# Run all policies and capture output
RESULT=$(opa eval --format=pretty --data policies --input "$PLAN_FILE" 'data.terraform.deny')

# Check if there are any violations
if echo "$RESULT" | grep -q '^\[\]$' || echo "$RESULT" | grep -q '^$'; then
  echo "✅ SUCCESS: No policy violations found!"
  exit 0
else
  echo "❌ POLICY VIOLATIONS DETECTED:"
  echo ""
  echo "$RESULT"
  exit 1
fi
