#!/usr/bin/env bash
# ==============================================================================
# Script Name:   running.sh
# Description:   Show pretty printed and colored process name and pid
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./running.sh [FLAGS] [ARGS...]
#
# Example:
#   ./running.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

VERBOSE=false

log::info()    { echo -e "[INFO]    $*" >&2; }
log::warn()    { echo -e "[WARNING] $*" >&2; }
log::error()   { echo -e "[ERROR]   $*" >&2; }
log::fatal()   { echo -e "[FATAL]   $*" >&2; exit 1; }
log::debug()   { if [[ "${VERBOSE}" == true ]]; then echo -e "[DEBUG]   $*" >&2; fi; }

usage() {
  cat <<USAGE_EOF
Usage: ${SCRIPT_NAME} [OPTIONS] [ARGS...]

Options:
  -h, --help        Show this help message and exit.
  -v, --verbose     Enable verbose output.
  --version         Print version and exit.

USAGE_EOF
}

version() { echo "${SCRIPT_NAME} version ${VERSION}"; }

cleanup() {
  log::debug "Cleaning up..."
}
trap cleanup EXIT

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -v|--verbose) VERBOSE=true ;;
      --version) version; exit 0 ;;
      --) shift; break ;;
      -*) log::error "Unknown flag: $1"; usage; exit 1 ;;
      *) ARGS+=("$1") ;;
    esac
    shift
  done
}

running() {
  process_list="$(ps -eo 'pid command')"
  if [[ $# != 0 ]]; then
    process_list="$(echo "$process_list" | grep -Fiw "$@")"
  fi

  echo "$process_list" |
    grep -Fv "${BASH_SOURCE[0]}" |
    grep -Fv grep |
    GREP_COLORS='mt=00;35' grep -E --colour=auto '^\s*[[:digit:]]+'
}

main() {
  log::debug "Running ${SCRIPT_NAME}..."

  declare -a ARGS=()

  parse_args "$@"

  local arg="${ARGS[0]}"
  running "$ARGS"
}

main "$@"
