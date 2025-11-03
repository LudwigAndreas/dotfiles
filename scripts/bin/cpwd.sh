#!/usr/bin/env bash
# ==============================================================================
# Script Name:   cpwd.sh
# Description:   Copy pwd into clipboard
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./cpwd.sh [FLAGS] [ARGS...]
#
# Example:
#   ./cpwd.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

cpwd() {
  pwd | tr -d '\n' | pbcopy
}

cpwd "$@"
