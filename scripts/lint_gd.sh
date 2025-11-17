#!/bin/bash
# GDScript Linting Script - The Core Descent
# Run with: bash scripts/lint_gd.sh

set -e

echo "🔍 Linting GDScript files..."

# Find all .gd files and run gdlint
find codigo/ -name "*.gd" -type f -print0 | while IFS= read -r -d '' file; do
    echo "Linting: $file"
    gdlint "$file" || true  # Non-blocking for initial runs
done

echo "✅ Lint complete. Review warnings above."
