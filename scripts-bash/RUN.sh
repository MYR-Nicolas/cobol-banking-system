#!/usr/bin/env bash
# run.sh — Runs a compiled COBOL program.
#
# Usage:
#   ./scripts-bash/RUN.sh 
#   ./scripts-bash/RUN.sh LSTACC --with-log

set -euo pipefail

# Paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$PROJECT_ROOT/bin"
DATA_DIR="$PROJECT_ROOT/data"
LOG_DIR="$PROJECT_ROOT/logs"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

# Argument check
if [[ $# -lt 1 ]]; then
  echo -e "${RED}Usage: $0 <PROGRAM_NAME> [--with-log]${NC}"
  exit 1
fi

PROGRAM="$1"
BINARY="$BIN_DIR/$PROGRAM"

# Binary check
if [[ ! -x "$BINARY" ]]; then
  echo -e "${RED}[FAIL]${NC} Binary not found or not executable: $BINARY"
  echo -e "${YELLOW}[INFO]${NC} Did you run ./scripts/compile.sh $PROGRAM ?"
  exit 1
fi

mkdir -p "$DATA_DIR" "$LOG_DIR"

echo -e "${YELLOW}[INFO]${NC} Running $PROGRAM (cwd = $PROJECT_ROOT) ..."
echo "-----------------------------------------------"

# Execution
cd "$PROJECT_ROOT"

if [[ "${2:-}" == "--with-log" ]]; then
  LOG_FILE="$LOG_DIR/${PROGRAM}_run_$(date +%Y%m%d_%H%M%S).log"
  "$BINARY" 2>&1 | tee "$LOG_FILE"
  exit_code=${PIPESTATUS[0]}
  echo "-----------------------------------------------"
  echo -e "${YELLOW}[INFO]${NC} Log saved: $LOG_FILE"
else
  "$BINARY"
  exit_code=$?
fi

# Result
echo "-----------------------------------------------"
if [[ $exit_code -eq 0 ]]; then
  echo -e "${GREEN}[OK]${NC} $PROGRAM finished (exit code 0)"
else
  echo -e "${RED}[FAIL]${NC} $PROGRAM finished with exit code $exit_code"
fi

exit $exit_code