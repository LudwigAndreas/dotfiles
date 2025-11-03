#!/usr/bin/env bash
# ==============================================================================
# Script Name:   serveit.sh
# Description:   Start ftp server on specified port (default - 8000)
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./serveit.sh [FLAGS] [ARGS...]
#
# Example:
#   ./serveit.sh -p 8000
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
PORT=8000

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
  -p, --port <port> Specify port
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
      -p|--port) 
        PORT="$2"
        shift 1;
      ;;
      --) shift; break ;;
      -*) log::error "Unknown flag: $1"; usage; exit 1 ;;
      *) ARGS+=("$1") ;;
    esac
    shift
  done
}

serveit() {
  if command -v php > /dev/null 2>&1; then
    exec php -S "localhost:$PORT"
  elif command -v python3 > /dev/null 2>&1; then
    exec python3 -m http.server "$PORT"
  elif command -v python > /dev/null 2>&1; then
    major_version="$(python -c 'import platform as p;print(p.python_version_tuple()[0])')"
    if [[ "$major_version" == '3' ]]; then
      exec python -m http.server "$PORT"
    else
      exec python -m SimpleHTTPServer "$PORT"
    fi
  elif command -v ruby > /dev/null 2>&1; then
    exec ruby -run -e httpd . -p "$PORT"
  else
    log::error 'Unable to start HTTP server' 1>&2
    exit 1
  fi
}

main() {
  declare -a ARGS=()
  parse_args "$@"
  log::info Running
  serveit
}

main "$@"
