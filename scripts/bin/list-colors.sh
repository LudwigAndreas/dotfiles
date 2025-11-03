#!/usr/bin/env bash
# ==============================================================================
# Script Name:   list-colors.sh
# Description:   Print all 256 ANSI foreground and background colors with aligned numbers
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./list-colors.sh [FLAGS] [ARGS...]
#
# Example:
#   ./list-colors.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# Function to format number to 3 characters
pad() {
    printf "%3s" "$1"
}

echo "=== 256-color Foreground ==="
for i in {0..255}; do
    # Print foreground color with 3-character width
    echo -ne "\e[38;5;${i}m$(pad $i) "
    if (( (i + 1) % 16 == 0 )); then
        echo -e "\e[0m"
    fi
done
echo -e "\e[0m\n"

echo "=== 256-color Background ==="
for i in {0..255}; do
    # Print background color with 3-character width
    echo -ne "\e[48;5;${i}m$(pad $i) "
    if (( (i + 1) % 16 == 0 )); then
        echo -e "\e[0m"
    fi
done
echo -e "\e[0m"
