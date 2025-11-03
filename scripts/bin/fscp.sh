#!/usr/bin/env bash
# ==============================================================================
# Script Name:   fscp.sh
# Description:   Fast scp. Sends $1 to first defined host in ~/.ssh/config:$2
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./fscp.sh file remote_location
#
# Example:
#   ./fscp.sh index.html /path/on/remote/host
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"


fscp() {
    local first_host
    first_host=$(awk '/^Host / && !/[*?]/ { print $2; exit }' ~/.ssh/config)

    if [ -z "$first_host" ]; then
        echo "No valid Host found in ~/.ssh/config"
        return 1
    fi

    scp -r "$1" "${first_host}:$2"
}

fscp "$@"
