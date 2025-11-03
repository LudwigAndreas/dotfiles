#!/usr/bin/env bash
# ==============================================================================
# Script Name:   git-relese.sh
# Description:   Get latest release from current repo 
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./git-relese.sh [options] [ARGS...]
#
# Example:
#   ./git-relese.sh --verbose input.txt
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
PREFIX="release/"
VERSION_PREFIX=""

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
  --prefix          Specify release prefix. Default - "release"
  --version-prefix  Specify version prefix. Default - empty string
  --version         Print version and exit.

USAGE_EOF
}

version() { echo "${SCRIPT_NAME} version ${VERSION}"; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage; exit 0 ;;
      -v|--verbose) VERBOSE=true ;;
      --version) version; exit 0 ;;
      --prefix)
        PREFIX="$2"
        shift 1
        ;;
      --version-prefix)
        VERSION_PREFIX="$2"
        shift 1
        ;;
      --) shift; break ;;
      -*) log::error "Unknown flag: $1"; usage; exit 1 ;;
      *) ARGS+=("$1") ;;
    esac
    shift
  done
}


# Function to extract version from branch name
extract_version() {
    local branch="$1"
    # Remove prefix from branch name
    local version="${branch#$PREFIX}"
    # Remove version prefix if specified
    version="${version#$VERSION_PREFIX}"
    echo "$version"
}

git_release() {
  # Get branches matching the prefix
  branches=$(git branch -r | grep "origin/$PREFIX")

  # If no branches found, exit
  if [ -z "$branches" ]; then
      log::error "No branches found with prefix $PREFIX"
      exit 1
  fi

  # Filter and sort branches
  latest_branch=$(echo "$branches" | while read -r branch; do
      clean_branch="${branch#origin/}"
      version=$(extract_version "$clean_branch")
      
      echo "$version $clean_branch"
  done | sort -V | tail -n 1 | awk '{print $2}')

  # Output the latest branch
  if [ -n "$latest_branch" ]; then
      "$latest_branch"
  else
      log::error "No valid branches found"
      exit 1
  fi
}

main() {
  log::debug "Running ${SCRIPT_NAME}..."

  declare -a ARGS=()

  parse_args "$@"

  git_release
}

main "$@"
