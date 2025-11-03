#!/usr/bin/env bash
# ==============================================================================
# Script Name:   fgrep.sh
# Description:   Find in current directory and grep by content and output with less
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./fgrep.sh [string to find]
#
# Example:
#   ./fgrep.sh main
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

fgrep() {
    grep --color=always "$*" \
         --exclude-dir=".git" \
         --exclude-dir="node_modules" \
         --ignore-case \
         --recursive \
         . \
        | less --no-init --raw-control-chars
          #    │         └─ Display ANSI color escape sequences in raw form.
          #    └─ Don't clear the screen after quitting less.
}

fgrep "$@"
