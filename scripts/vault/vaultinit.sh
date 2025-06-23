#!/bin/bash
# vaultinit.sh - Initialize vault directory structure
# Author: LudwigAndreas

set -euo pipefail

# Helper functions
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

initialize() {
    local base_dir=$1
    local -a dirs=("${@:2}")
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo script_dir=$script_dir

    log "Creating devault structure in: $base_dir"
    # Create main structure
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log "Created $dir"
    done
    log "Copying template files"
    ln -sf "${script_dir}/Makefile" "${base_dir}/Makefile"
    ln -sfn "${script_dir}/templates" "${base_dir}/templates"
    log "Vault is initialized."
}

main() {
    # Global constants
    local base_dir="${1:-${HOME}/vault}"
    # Directory structure
    declare -a dirs=(
        "${base_dir}/projects"
        "${base_dir}/notes"
        "${base_dir}/tools"
    )
    initialize "${base_dir}" "${dirs[@]}"
}

main "$@"
