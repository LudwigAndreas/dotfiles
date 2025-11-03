#!/usr/bin/env bash
# ==============================================================================
# Script Name:   kubefindlog.sh
# Description:   fast search search-term in pod logs
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./kubefindlog.sh pod-name search-term
#
# Example:
#   ./kubefindlog.sh nginx-pod started
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

kubefindlog() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    kubectl logs $pod | grep $2
}

kubefindlog "$@"
