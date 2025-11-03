#!/usr/bin/env bash
# ==============================================================================
# Script Name:   extract.sh
# Description:   Extracts archive using proper archiver
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./extract.sh archive-file
#
# Example:
#   ./extract.sh archive.zip
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    # Absolute path (using realpath or readlink)
    if command -v realpath >/dev/null 2>&1; then
        fullpath=$(realpath "$1")
    else
        fullpath=$(readlink -f "$1")
    fi

    case "$fullpath" in
        *.tar.bz2|*.tb2|*.tbz|*.tbz2) tar xjf "$fullpath" ;;
        *.tar.gz|*.tgz|*.taz) tar xzf "$fullpath" ;;
        *.tar.xz|*.txz) tar Jxvf "$fullpath" ;;
        *.tar.Z|*.Z) tar xzf "$fullpath" ;;
        *.tar) tar xf "$fullpath" ;;
        *.bz2) bunzip2 "$fullpath" ;;
        *.zip|*.ZIP) unzip "$fullpath" ;;
        *.gz) gunzip "$fullpath" ;;
        *.pax) pax -r < "$fullpath" ;;
        *.pax.Z) uncompress "$fullpath" --stdout | pax -r ;;
        *.rar) unrar x "$fullpath" ;;
        *.dmg) hdiutil mount "$fullpath" ;;
        *) echo "'$1' cannot be extracted via extract()" ; return 1 ;;
    esac
}

extract "$@"
