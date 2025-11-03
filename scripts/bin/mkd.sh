#!/usr/bin/env bash
# ==============================================================================
# Script Name:   mkd.sh
# Description:   Create a new directory and enter it
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./mkd.sh directory
#
# Example:
#   ./mkd.sh my_dir
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

mkdir -p "$@" && cd "$_";
