#!/usr/bin/env bash
# ==============================================================================
# Script Name:   notify.sh
# Description:   Cross-platform notification: Linux (notify-send) and macOS (osascript)
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./notify.sh [FLAGS] [ARGS...]
#
# Example:
#   ./notify.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

title="${1:-Notification}"
description="${2:-$(date --iso-8601=seconds 2>/dev/null || date)}"

# Try Linux notify-send first
if command -v notify-send >/dev/null 2>&1; then
    notify-send --expire-time=5000 "$title" "$description" && exit 0
fi

# Try macOS osascript (AppleScript)
if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"${description//\"/\\\"}\" with title \"${title//\"/\\\"}\"" && exit 0
fi

# Fallback
echo "Can't send notification" >&2
exit 1
