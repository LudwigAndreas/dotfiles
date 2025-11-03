#!/usr/bin/env bash
# ==============================================================================
# Script Name:   json.sh
# Description:   Pretty prints json using python json.tool
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./json.sh [json content]
#
# Example:
#   ./json.sh '{"foo":42}'
#   echo '{"foo":42}' | ./json.sh
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

json() {
    if command -v python3 >/dev/null 2>&1; then
        _python=python3
    elif command -v python >/dev/null 2>&1; then
        _python=python
    else
        echo "Error: python3 or python not found" >&2
        return 1
    fi

    if [ -t 0 ]; then
        printf "%s\n" "$*" | ${_python} -mjson.tool
    else
        ${_python} -mjson.tool
    fi
}
