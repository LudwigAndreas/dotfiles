#!/usr/bin/env bash
# ==============================================================================
# Script Name:   snipped.sh
# Description:   <Short description of what this script does>
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./snipped.sh [FLAGS] [ARGS...]
#
# Example:
#   ./snipped.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"
readonly XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
readonly SNIPPETS_PATH="$XDG_CONFIG_HOME/snippets"

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

die() {
  log::error "No snippet found at $1" 1>&2
  exit 1
}

snipped() {
  local filepath="${SNIPPETS_PATH}/$1"
  cat "$filepath" 2>/dev/null || die "$filepath"
}

main() {
  declare -a ARGS=()
  parse_args "$@"

  local arg="${ARGS[0]}"
  snipped "${arg}"
}

main "$@"
