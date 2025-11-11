#!/bin/bash
set -e
echo "🧪 Running OPA policy tests..."
opa test policies/ --verbose
