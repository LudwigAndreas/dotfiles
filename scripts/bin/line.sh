#!/usr/bin/env bash
# ==============================================================================
# Script Name:   line.sh
# Description:   Show content of file on specific line
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./line.sh [FLAGS] [ARGS...]
#
# Example:
#   ./line.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

lineno="$1"; shift
sed -n "${lineno}p" -- "$@"
