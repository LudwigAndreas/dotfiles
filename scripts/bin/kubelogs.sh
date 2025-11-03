#!/usr/bin/env bash
# ==============================================================================
# Script Name:   kubelogs.sh
# Description:   Fast access logs of pod
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./kubelogs.sh [pod-name]
#
# Example:
#   ./kubelogs.sh nginx-pod
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

kubelogs() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    kubectl logs $pod --tail=100 -f 
}

kubelogs "$@"
