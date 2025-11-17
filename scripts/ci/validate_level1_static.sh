#!/bin/bash
# THE CORE DESCENT - Static Code Validation
# Arquivo: validate_level1_static.sh - Valida Level1 sem precisar do Godot
# Uso: bash scripts/ci/validate_level1_static.sh

# Removed set -e to show all test results

echo "=== Level1 Static Validation ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Test 1: Check files exist
echo "Test 1: Check required files exist"
files=(
    "codigo/BaseLevel.gd"
    "codigo/Level1.gd"
    "codigo/services/GameStateService.gd"
    "codigo/services/LevelFlowService.gd"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $file exists"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} $file NOT FOUND"
        ((FAILED++))
    fi
done

# Test 2: Check Level1 extends BaseLevel
echo ""
echo "Test 2: Verify Level1 extends BaseLevel"
if grep -q "extends BaseLevel" codigo/Level1.gd; then
    echo -e "  ${GREEN}✓${NC} Level1 extends BaseLevel"
    ((PASSED++))
else
    echo -e "  ${RED}✗${NC} Level1 does NOT extend BaseLevel"
    ((FAILED++))
fi

# Test 3: Check BaseLevel has expected methods
echo ""
echo "Test 3: Check BaseLevel methods"
base_methods=(
    "func _ready"
    "func setup_level"
    "func setup_ui"
    "func start_level"
    "func complete_level"
    "func update_move_counter"
    "func update_timer_display"
)

for method in "${base_methods[@]}"; do
    if grep -q "$method" codigo/BaseLevel.gd; then
        echo -e "  ${GREEN}✓${NC} BaseLevel has: $method"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} BaseLevel missing: $method"
        ((FAILED++))
    fi
done

# Test 4: Check Level1 unique methods
echo ""
echo "Test 4: Check Level1 unique methods"
level1_methods=(
    "func load_available_puzzles"
    "func load_puzzle"
    "func check_level_completion"
    "func complete_current_puzzle"
    "func _on_level_ready"
)

for method in "${level1_methods[@]}"; do
    if grep -q "$method" codigo/Level1.gd; then
        echo -e "  ${GREEN}✓${NC} Level1 has: $method"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Level1 missing: $method"
        ((FAILED++))
    fi
done

# Test 5: Check Level1 doesn't have duplicated boilerplate
echo ""
echo "Test 5: Verify boilerplate removed from Level1"
duplicate_patterns=(
    "var move_counter: Label"
    "var timer_label: Label"
    "func setup_level.*:#.*Configuração inicial"
    "func setup_ui.*:#.*Configura interface"
)

DUPLICATES_FOUND=0
for pattern in "${duplicate_patterns[@]}"; do
    if grep -qE "$pattern" codigo/Level1.gd; then
        echo -e "  ${YELLOW}⚠${NC}  Found duplicated code: $pattern"
        ((DUPLICATES_FOUND++))
    fi
done

if [ $DUPLICATES_FOUND -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No duplicated boilerplate found"
    ((PASSED++))
else
    echo -e "  ${RED}✗${NC} Found $DUPLICATES_FOUND potential duplicates"
    ((FAILED++))
fi

# Test 6: Check Services have signals
echo ""
echo "Test 6: Check Services define signals"
if grep -q "signal state_changed" codigo/services/GameStateService.gd; then
    echo -e "  ${GREEN}✓${NC} GameStateService has state_changed signal"
    ((PASSED++))
else
    echo -e "  ${RED}✗${NC} GameStateService missing state_changed signal"
    ((FAILED++))
fi

if grep -q "signal level_loaded" codigo/services/LevelFlowService.gd; then
    echo -e "  ${GREEN}✓${NC} LevelFlowService has level_loaded signal"
    ((PASSED++))
else
    echo -e "  ${RED}✗${NC} LevelFlowService missing level_loaded signal"
    ((FAILED++))
fi

# Test 7: Line count validation
echo ""
echo "Test 7: Line count metrics"
LEVEL1_LINES=$(wc -l < codigo/Level1.gd)
BASELEVEL_LINES=$(wc -l < codigo/BaseLevel.gd)

echo "  Level1.gd: $LEVEL1_LINES lines"
echo "  BaseLevel.gd: $BASELEVEL_LINES lines"

if [ $LEVEL1_LINES -lt 350 ]; then
    echo -e "  ${GREEN}✓${NC} Level1 successfully reduced (target: <350 lines)"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠${NC}  Level1 still large: $LEVEL1_LINES lines"
fi

# Test 8: GDScript syntax check (basic)
echo ""
echo "Test 8: Basic GDScript syntax check"
SYNTAX_ERRORS=0

# Check for common syntax errors
for file in codigo/BaseLevel.gd codigo/Level1.gd; do
    # Check balanced parentheses in function definitions
    if grep -E "^func [a-z_]+\(" "$file" | grep -v "):$" | grep -v ") ->"; then
        echo -e "  ${YELLOW}⚠${NC}  Potential syntax issue in $file"
        ((SYNTAX_ERRORS++))
    fi
done

if [ $SYNTAX_ERRORS -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} No obvious syntax errors"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠${NC}  Found $SYNTAX_ERRORS potential issues"
fi

# Test 9: Check for TODO/FIXME comments
echo ""
echo "Test 9: Check for TODO/FIXME markers"
TODOS=$(grep -E "TODO|FIXME" codigo/Level1.gd codigo/BaseLevel.gd 2>/dev/null | wc -l)
if [ $TODOS -gt 0 ]; then
    echo -e "  ${YELLOW}⚠${NC}  Found $TODOS TODO/FIXME comments"
    grep -nE "TODO|FIXME" codigo/Level1.gd codigo/BaseLevel.gd 2>/dev/null | head -5
else
    echo -e "  ${GREEN}✓${NC} No pending TODOs"
    ((PASSED++))
fi

# Test 10: Validate _init() usage in Level1
echo ""
echo "Test 10: Check Level1 initialization"
if grep -q "func _init" codigo/Level1.gd; then
    echo -e "  ${GREEN}✓${NC} Level1 has _init() for property setup"
    
    # Check if _init sets level_name
    if grep -A5 "func _init" codigo/Level1.gd | grep -q "level_name"; then
        echo -e "  ${GREEN}✓${NC} _init() sets level_name"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} _init() doesn't set level_name"
        ((FAILED++))
    fi
else
    echo -e "  ${YELLOW}⚠${NC}  Level1 missing _init() - using @export instead?"
fi

# Summary
echo ""
echo "========================================"
echo "VALIDATION SUMMARY"
echo "========================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED${NC}"
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ALL STATIC TESTS PASSED${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Test with Godot: godot --headless --script scripts/ci/test_level1.gd"
    echo "  2. Manual editor test: Open Level1 scene in Godot editor"
    echo "  3. Play test: Run game and verify UI/timer/puzzles"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    echo ""
    echo "Please review the errors above before manual testing"
    exit 1
fi
