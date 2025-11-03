#!/usr/bin/env bash
# ==============================================================================
# Script Name:   stopwatch.sh
# Description:   Simple bash stopwatch implementation
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./stopwatch.sh [FLAGS] [ARGS...]
#
# Example:
#   ./stopwatch.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

date "+%l:%M:%S%p: stopwatch started (^D to stop)"
time cat
date "+%l:%M:%S%p: stopwatch stopped"
