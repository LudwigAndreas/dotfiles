#!/usr/bin/env bash
# ==============================================================================
# Script Name:   math.sh
# Description:   <Short description of what this script does>
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./math.sh [FLAGS] [ARGS...]
#
# Example:
#   ./math.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

if command -v rink >/dev/null 2>&1; then
	exec rink
elif command -v python3 >/dev/null 2>&1; then
	exec python3 -i -c 'from math import *; from statistics import *'
elif command -v bc >/dev/null 2>&1; then
	exec bc
else
	>&2 echo "couldn't find any math program"
	exit 1
fi
