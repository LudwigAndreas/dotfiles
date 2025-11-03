#!/usr/bin/env bash
# ==============================================================================
# Script Name:   waitfor.sh
# Description:   Wait for program end by pid
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./waitfor.sh [FLAGS] [ARGS...]
#
# Example:
#   ./waitfor.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

pid="$1"

if command -v caffeinate >/dev/null 2>&1; then
  caffeinate -w "$pid"
elif command -v systemd-inhibit >/dev/null 2>&1; then
  systemd-inhibit \
    --who=waitfor \
    --why="Awaiting PID $pid" \
    tail --pid="$pid" -f /dev/null
else
  tail --pid="$pid" -f /dev/null
fi
