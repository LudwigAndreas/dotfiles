#!/usr/bin/env bash
# ==============================================================================
# Script Name:   tre.sh
# Description:   `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./tre.sh [directory]
#
# Example:
#   ./tre.sh .
#   ./tre.sh my_directory
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.
#   - the `.git` directory, listing directories first. The output gets piped into
#     `less` with options to preserve color and line numbers, unless the output is
#     small enough for one screen.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

tre "$@"
