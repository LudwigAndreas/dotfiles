#!/usr/bin/env bash
# ==============================================================================
# Script Name:   <SCRIPT_NAME>.sh
# Description:   <Short description of what this script does>
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./<SCRIPT_NAME>.sh [FLAGS] [ARGS...]
#
# Example:
#   ./<SCRIPT_NAME>.sh --verbose input.txt
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

main() {
  log::debug "Running ${SCRIPT_NAME}..."

  declare -a ARGS=()

  log::debug "Parsing arguments"
  parse_args "$@"
  log::debug "Accepted arguments: ${ARGS}"

  if [[ ${#ARGS[@]:-0} -eq 0 ]]; then
    log::warn "No arguments provided."
    usage
    exit 1
  fi

  local arg="${ARGS[0]}"
  log::info "Processing: ${arg}"
}

main "$@"
