#!/usr/bin/env bash
# ==============================================================================
# Script Name:   open.sh
# Description:   <Short description of what this script does>
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./open.sh [FLAGS] [ARGS...]
#
# Example:
#   ./open.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if ! command -v open > /dev/null 2>&1; then
    if [ ! $(uname -s) = 'Darwin' ]; then
        if [[ $(uname -s) == *MINGW* ]] || [grep -q Microsoft /proc/version]; then
            # Ubuntu on Windows using the Linux subsystem
            alias open='explorer.exe';
        else
            alias open='xdg-open';
        fi
    fi
fi

main "$@"
