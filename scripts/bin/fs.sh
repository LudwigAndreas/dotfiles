#!/usr/bin/env bash
# ==============================================================================
# Script Name:   fs.sh
# Description:   Determine size of a file or total size of a directory
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./fs.sh [file or directory]
#
# Example:
#   ./fs.sh my_file
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

filesize() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
}

filesize "$@"
