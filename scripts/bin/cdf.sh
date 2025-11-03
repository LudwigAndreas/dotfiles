#!/usr/bin/env bash
# ==============================================================================
# Script Name:   cdf.sh
# Description:   Change working directory to the top-most Finder window location
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./cdf.sh
#
# Example:
#   ./cdf.sh
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# TODO: add linux support
cdf() { 
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

cdf "$@"
