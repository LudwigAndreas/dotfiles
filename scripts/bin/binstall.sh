#!/usr/bin/env bash
# ==============================================================================
# Script Name:   binstall.sh
# Description:   Create symlink for each script in SRC_DIR into user bin directory
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./binstall.sh [FLAGS]
#
# Example:
#   ./binstall.sh --verbose input.txt
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
SRC_DIR="$HOME/dotfiles/scripts/bin"
DEST_DIR="$HOME/.local/bin"
FORCE=0

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
  -i, --src         Directory containing binary files. 
  -o, --dest        Directory where symlinks will be created.
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
      -i|--src) 
        SRC_DIR="${2}"
        shift 1
        ;;
      -o|--dest) 
        DEST_DIR="${2}"
        shift 1
        ;;
      --version) version; exit 0 ;;
      --) shift; break ;;
      -*) log::error "Unknown flag: $1"; usage; exit 1 ;;
      *) ARGS+=("$1") ;;
    esac
    shift
  done
}


binreload() {
    mkdir -p "${DEST_DIR}"

    if [[ ! -d "${SRC_DIR}" ]]; then
        log::error "source directory '${SRC_DIR}' not found"
        return 1
    fi
    local file base_name link_path
    for file in "${SRC_DIR}"/*; do
      log::debug "Processing file $file"
      # [[ -f "$file" && -x "$file" ]] || continue
      [[ -f "$file" ]] || continue
      base_name=$(basename "$file")
      base_name="${base_name%.py}"
      base_name="${base_name%.sh}"

      link_path="${DEST_DIR}/${base_name}"
      if [[ -e "${link_path}" ]]; then
        if [[ ${FORCE} -eq 1 ]]; then
          rm -f "${link_path}"
        else
          log::info "Skipping existing file: ${link_path}"
          continue
        fi
      fi
      ln -s "${file}" "${link_path}"
      log::info "Linked: ${link_path} -> ${file}"
    done

    log::info "All eligible scripts linked successfully"
}

main() {
  log::debug "Running ${SCRIPT_NAME}..."

  declare -a ARGS=()

  parse_args "$@"

  binreload 
}

main "$@"
