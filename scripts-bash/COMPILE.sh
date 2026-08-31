#!/usr/bin/env bash
# COMPILE.sh — Compiles the subprograms (RULE-*) then the main programs
#              of the cobol-core-banking-system project with GnuCOBOL.
#
# Usage:
#   ./scripts-bash/COMPILE.sh                    # compile everything
#   ./scripts-bash/COMPILE.sh LSTACC             # compile LSTACC + all subprograms
#   ./scripts-bash/COMPILE.sh RULE-ACCOUNT-CTRL  # compile that module only
#   ./scripts-bash/COMPILE.sh --clean            # clean bin/ before compiling
#   ./scripts-bash/COMPILE.sh --no-deps CNSACC   # compile CNSACC alone (no subprograms)

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

# Options
WITH_DEPS=1

while [[ $# -gt 0 ]]; do
  case "${1}" in
    --clean)
      log_info "Cleaning $BIN_DIR"
      rm -rf "${BIN_DIR:?}"/*
      shift
      ;;
    --no-deps)
      WITH_DEPS=0
      shift
      ;;
    *)
      break
      ;;
  esac
done

fail_count=0

# Compile one subprogram into a loadable module (.so)
# The .so name must match the PROGRAM-ID, not the file name.
compile_subprogram() {
  local src_file="$1"
  local name pgm_id
  name="$(basename "$src_file" .cbl)"

  # Extract PROGRAM-ID to detect a mismatch with the file name
  pgm_id="$(grep -i -m1 'PROGRAM-ID' "$src_file" \
            | sed -E 's/.*[Pp][Rr][Oo][Gg][Rr][Aa][Mm]-[Ii][Dd][[:space:].]*//' \
            | tr -d ' .\r')"

  if [[ -n "$pgm_id" && "$pgm_id" != "$name" ]]; then
    log_error "$name: PROGRAM-ID is '$pgm_id' but file is '${name}.cbl'"
    log_error "  -> dynamic CALL will look for '${pgm_id}.so'. Align the two."
  fi

  log_info "Compiling module: $name"

  if cobc -m -I "$COPYBOOKS_DIR" -o "$BIN_DIR/${name}.so" "$src_file" \
      > "$LOG_DIR/${name}_compile.log" 2>&1; then
    log_ok "$name.so"
    return 0
  else
    log_error "$name (see $LOG_DIR/${name}_compile.log)"
    return 1
  fi
}

# Compile one main program into an executable
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

  # No -L here: subprograms are resolved at RUNTIME via COB_LIBRARY_PATH,
  # not at link time.
  if cobc -x -I "$COPYBOOKS_DIR" -o "$BIN_DIR/${name}" "$src_file" \
      > "$LOG_DIR/${name}_compile.log" 2>&1; then
    log_ok "$name"
    return 0
  else
    log_error "$name (see $LOG_DIR/${name}_compile.log)"
    return 1
  fi
}

build_all_subprograms() {
  log_info "=== Subprograms ==="
  local found=0
  for src in "$SRC_SUBPROGRAMS"/*.cbl; do
    [[ -e "$src" ]] || continue
    found=1
    compile_subprogram "$src" || fail_count=$((fail_count + 1))
  done
  [[ $found -eq 1 ]] || log_info "No subprogram found in $SRC_SUBPROGRAMS"
}

# Single target mode
if [[ $# -eq 1 ]]; then
  target="$1"

  # A subprogram asked for by name
  if [[ -f "$SRC_SUBPROGRAMS/${target}.cbl" ]]; then
    compile_subprogram "$SRC_SUBPROGRAMS/${target}.cbl" || exit 1
    echo ""
    log_ok "Module built. Remember: export COB_LIBRARY_PATH=\"$BIN_DIR\""
    exit 0
  fi

  # A main program: rebuild its dependencies first, unless --no-deps
  if [[ -f "$SRC_BATCH/${target}.cbl" || -f "$SRC_CICS/${target}.cbl" ]]; then
    if [[ $WITH_DEPS -eq 1 ]]; then
      build_all_subprograms
      echo ""
    fi

    if [[ -f "$SRC_BATCH/${target}.cbl" ]]; then
      compile_program "$SRC_BATCH/${target}.cbl" "batch" || fail_count=$((fail_count + 1))
    else
      compile_program "$SRC_CICS/${target}.cbl" "cics" || fail_count=$((fail_count + 1))
    fi

    echo ""
    if [[ $fail_count -eq 0 ]]; then
      log_ok "Build complete. Binaries in $BIN_DIR"
      log_info "Run with: COB_LIBRARY_PATH=\"$BIN_DIR\" $BIN_DIR/$target"
      exit 0
    else
      log_error "$fail_count compilation failure(s). See $LOG_DIR/"
      exit 1
    fi
  fi

  log_error "Not found in BATCH/, CICS/ or bank-parameters/: ${target}.cbl"
  exit 1
fi

# Build all
build_all_subprograms

log_info "=== BATCH programs ==="
for src in "$SRC_BATCH"/*.cbl; do
  [[ -e "$src" ]] || continue
  compile_program "$src" "batch" || fail_count=$((fail_count + 1))
done

log_info "=== CICS programs ==="
for src in "$SRC_CICS"/*.cbl; do
  [[ -e "$src" ]] || continue
  compile_program "$src" "cics" || fail_count=$((fail_count + 1))
done

# Summary
echo ""
if [[ $fail_count -eq 0 ]]; then
  log_ok "Build complete. Binaries in $BIN_DIR"
  log_info "Run with: COB_LIBRARY_PATH=\"$BIN_DIR\" $BIN_DIR/<PROGRAM>"
else
  log_error "$fail_count compilation failure(s). See $LOG_DIR/"
  exit 1
fi