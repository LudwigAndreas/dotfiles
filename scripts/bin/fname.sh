#!/usr/bin/env bash
# ==============================================================================
# Script Name:   fname.sh
# Description:   Find all files recursively in current directory matching paggern *arg*
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./fname.sh [file or directory...]
#
# Example:
#   ./fname.sh input.txt my_directory
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

fname() {
    for arg in "$@"; do
        find . -iname "*$arg*"
    done
}


fname "$@"
