#!/usr/bin/env bash
# compile.sh — Compiles the subprograms (RULE-*) then the main programs
#              of the cobol-core-banking-system project with GnuCOBOL.
#
# Usage:
#   ./scripts-bash/COMPILE.sh              # compile everything (subprograms + programs)
#   ./scripts-bash/COMPILE.sh LSTACC       # compile only the LSTACC program
#   ./scripts-bash/COMPILE.sh --clean      # clean bin/ before compiling

set -euo pipefail

# Paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_BATCH="$PROJECT_ROOT/src/BATCH"
SRC_CICS="$PROJECT_ROOT/src/CICS"
SRC_SUBPROGRAMS="$PROJECT_ROOT/bank-parameters"
COPYBOOKS_DIR="$PROJECT_ROOT/copybooks"
BIN_DIR="$PROJECT_ROOT/bin"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$BIN_DIR" "$LOG_DIR"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging helpers
log_info()  { echo -e "${YELLOW}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}   $1"; }
log_error() { echo -e "${RED}[FAIL]${NC} $1"; }

# Clean option
if [[ "${1:-}" == "--clean" ]]; then
  log_info "Cleaning $BIN_DIR"
  rm -rf "${BIN_DIR:?}"/*
  shift
fi

# Compile subprogram
compile_subprogram() {
  local src_file="$1"
  local name
  name="$(basename "$src_file" .cbl)"
  log_info "Compiling module: $name"

  if cobc -m -I "$COPYBOOKS_DIR" -o "$BIN_DIR/${name}.so" "$src_file" \
      > "$LOG_DIR/${name}_compile.log" 2>&1; then
    log_ok "$name.so"
  else
    log_error "$name (see $LOG_DIR/${name}_compile.log)"
    return 1
  fi
}

# Compile program
compile_program() {
  local src_file="$1"
  local mode="${2:-batch}"
  local name
  name="$(basename "$src_file" .cbl)"

  if [[ "$mode" == "cics" ]]; then
    log_info "Compiling CICS program: $name"
  else
    log_info "Compiling BATCH program: $name"
  fi

  if cobc -x -I "$COPYBOOKS_DIR" -L "$BIN_DIR" -o "$BIN_DIR/${name}" "$src_file" \
      > "$LOG_DIR/${name}_compile.log" 2>&1; then
    log_ok "$name"
  else
    log_error "$name (see $LOG_DIR/${name}_compile.log)"
    return 1
  fi
}

# Single target mode
if [[ $# -eq 1 ]]; then
  target="$1"
  if [[ -f "$SRC_BATCH/${target}.cbl" ]]; then
    compile_program "$SRC_BATCH/${target}.cbl" "batch"
    exit $?
  elif [[ -f "$SRC_CICS/${target}.cbl" ]]; then
    compile_program "$SRC_CICS/${target}.cbl" "cics"
    exit $?
  else
    log_error "Program not found in BATCH/ or CICS/: ${target}.cbl"
    exit 1
  fi
fi

# Build all
fail_count=0

log_info "=== Subprograms ==="
for src in "$SRC_SUBPROGRAMS"/*.cbl; do
  [[ -e "$src" ]] || continue
  compile_subprogram "$src" || ((fail_count++))
done

log_info "=== BATCH programs ==="
for src in "$SRC_BATCH"/*.cbl; do
  [[ -e "$src" ]] || continue
  compile_program "$src" "batch" || ((fail_count++))
done

log_info "=== CICS programs ==="
for src in "$SRC_CICS"/*.cbl; do
  [[ -e "$src" ]] || continue
  compile_program "$src" "cics" || ((fail_count++))
done

# Summary
echo ""
if [[ $fail_count -eq 0 ]]; then
  log_ok "Build complete. Binaries in $BIN_DIR"
else
  log_error "$fail_count compilation failure(s). See $LOG_DIR/"
  exit 1
fi