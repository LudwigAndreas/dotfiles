#!/usr/bin/env bash
# ==============================================================================
# Script Name:   cptmp.sh
# Description:   Create temporary file and copy path to clipboard
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./cptmp.sh [FLAGS] [ARGS...]
#
# Example:
#   ./cptmp.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

cptmp() {
  path="$(mktemp | tr -d '\n')"
  echo -n "$path"
  echo -n "$path" | pbcopy
}

cptmp "$@"
