#!/usr/bin/env bash
# ==============================================================================
# Script Name:   gitrepo.sh
# Description:   Open current repo in browser
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./gitrepo.sh 
#
# Example:
#   ./gitrepo.sh 
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

repo() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not a git repo!"
        return 1
    fi

    remote_url=$(git remote get-url origin 2>/dev/null || git remote -v | awk 'NR==1{print $2}')
    if [[ -z "$remote_url" ]]; then
      echo "No Git remote found." >&2
      return 1
    fi

    if [[ "$remote_url" =~ ^git@ ]]; then
      remote_url=${remote_url/git@/https:\/\/}
      remote_url=${remote_url//:/\/}
    elif [[ "$remote_url" =~ ^ssh://git@ ]]; then
      remote_url=${remote_url/ssh:\/\/git@/https:\/\/}
    fi

    remote_url=${remote_url%.git}

    echo "Opening: $remote_url"
    open "$remote_url"
}

repo "$@"
