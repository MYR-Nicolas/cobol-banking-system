#!/usr/bin/env bash
# run_tests.sh — Compiles and runs test drivers (tests/**/TEST-*.cbl),
#                then aggregates a PASS/FAIL report.
#
# Tests are organized by category in subfolders:
#   tests/functional/, tests/input/, tests/integration/,
#   tests/regression/, tests/robustness/, tests/unit/
#
# Usage:
#   ./scripts-bash/RUN-TESTS.sh                 # all tests, all categories
#   ./scripts-bash/RUN-TESTS.sh unit             # all tests in tests/unit/
#   ./scripts-bash/RUN-TESTS.sh TEST-U-FORMAT    # a single test, any category

set -euo pipefail

# Paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTS_DIR="$PROJECT_ROOT/tests"
COPYBOOKS_DIR="$PROJECT_ROOT/copybooks"
BIN_DIR="$PROJECT_ROOT/bin"
DATA_DIR="$PROJECT_ROOT/data"
LOG_DIR="$PROJECT_ROOT/logs/tests"

# Colors
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'

mkdir -p "$BIN_DIR" "$LOG_DIR"

# COB_FILE_PATH: GnuCOBOL searches each directory listed here (colon-separated)
# for any relative filename used in ASSIGN TO "...".
#   - $DATA_DIR/vsam   -> VSAM files (ACCOUNTS, CUSTOMERS, TRANSACTIONS, ...)
#   - $TESTS_DIR/input -> CSV test-case input files (e.g. test-balance-cases.csv)
export COB_FILE_PATH="$DATA_DIR/vsam:$TESTS_DIR/input"
export COB_LIBRARY_PATH="$BIN_DIR"

total_pass=0
total_fail=0
declare -a failed_tests=()

# Run one test
run_one_test() {
  local src_file="$1"
  local name
  name="$(basename "$src_file" .cbl)"
  local binary="$BIN_DIR/${name}"
  local log_file="$LOG_DIR/${name}.log"

  echo -e "${YELLOW}--- $name ($(dirname "$src_file" | sed "s|$TESTS_DIR/||")) ---${NC}"

  if ! cobc -x -I "$COPYBOOKS_DIR" -L "$BIN_DIR" -o "$binary" "$src_file" > "$log_file" 2>&1; then
    echo -e "${RED}[COMPILE FAIL]${NC} $name"
    failed_tests+=("$name (compilation)")
    return
  fi

  local output
  if ! output="$("$binary" 2>&1)"; then
    echo -e "${RED}[RUNTIME FAIL]${NC} $name (non-zero exit code)"
    echo "$output" >> "$log_file"
    failed_tests+=("$name (runtime)")
    return
  fi
  echo "$output" >> "$log_file"

  local pass_count fail_count
  pass_count=$(grep -c "PASS" <<< "$output" || true)
  fail_count=$(grep -c "FAIL" <<< "$output" || true)

  if [[ $pass_count -eq 0 && $fail_count -eq 0 ]]; then
    echo -e "${RED}[NO RESULTS]${NC} $name — no PASS/FAIL detected in output"
    failed_tests+=("$name (no test results detected)")
    total_fail=$((total_fail + 1))
    return
  fi

  total_pass=$((total_pass + pass_count))
  total_fail=$((total_fail + fail_count))

  echo "$output" | grep -E "PASS|FAIL"

  if [[ $fail_count -gt 0 ]]; then
    failed_tests+=("$name ($fail_count failing case(s))")
  fi
}

echo -e "${BOLD}=== COBOL test suite — cobol-core-banking-system ===${NC}"
echo ""

# Target selection
if [[ $# -eq 1 ]]; then
  arg="$1"

  if [[ -d "$TESTS_DIR/$arg" ]]; then
    # Category mode: run every TEST-*.cbl inside tests/<arg>/
    mapfile -t targets < <(find "$TESTS_DIR/$arg" -type f -name "TEST-*.cbl" | sort)
    if [[ ${#targets[@]} -eq 0 ]]; then
      echo -e "${RED}No TEST-*.cbl found in tests/$arg/${NC}"
      exit 1
    fi
  else
    # Single test mode: search by name across all categories
    mapfile -t targets < <(find "$TESTS_DIR" -type f -name "${arg}.cbl")
    if [[ ${#targets[@]} -eq 0 ]]; then
      echo -e "${RED}Test not found: ${arg}.cbl (searched under $TESTS_DIR)${NC}"
      exit 1
    fi
  fi
else
  # All tests, all categories
  mapfile -t targets < <(find "$TESTS_DIR" -type f -name "TEST-*.cbl" | sort)
fi

for src in "${targets[@]}"; do
  run_one_test "$src"
  echo ""
done

# Summary
echo "================================================="
echo -e "${GREEN}PASS: $total_pass${NC}   ${RED}FAIL: $total_fail${NC}"
echo "================================================="

if [[ ${#failed_tests[@]} -gt 0 ]]; then
  echo -e "${RED}Failing tests:${NC}"
  for t in "${failed_tests[@]}"; do
    echo "  - $t"
  done
  echo -e "${YELLOW}Detailed logs in: $LOG_DIR${NC}"
  exit 1
fi

echo -e "${GREEN}All tests passed.${NC}"
exit 0