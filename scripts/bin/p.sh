#!/usr/bin/env bash
# ==============================================================================
# Script Name:   p.sh
# Description:   Go to projects or into a specific one 
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./p.sh project-name
#
# Example:
#   ./p.sh dotfiles
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# TODO: make $HOME/vault/projects configurable
main() {
    local projects_dir="$HOME/vault/projects"
    if [ ! -d "$projects_dir" ]; then
        echo "Directory $projects_dir does not exist."
        return 1
    fi

    # If no argument — go to the main directory
    if [ $# -eq 0 ]; then
        cd "$projects_dir" || return
        return
    fi

    # If argument provided — go into that subdirectory
    local target="$projects_dir/$1"
    if [ -d "$target" ]; then
        echo "cd into $target"
        cd "$target" && $SHELL
    else
        echo "Project '$1' not found in $projects_dir."
        return 1
    fi
}

main "$@"
