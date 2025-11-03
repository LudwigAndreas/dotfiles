#!/usr/bin/env bash
# ==============================================================================
# Script Name:   kubeport.sh
# Description:   Fast port-forward to a pod by podname
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./kubeport.sh pod-name
#
# Example:
#   ./kubeport.sh nginx
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# 
# Usage: kport <pod-name> <local-port> [remote-port]
kubeport() {
    local pod=$(kubectl get pods | grep $1 | awk '{print $1}')
    
    if [ -z "$3" ]; then
        # If there are only two arguments, use the same port for both
        kubectl port-forward $pod $2:$2
    else
        # If there are three arguments, forward $2:$3
        kubectl port-forward $pod $2:$3
    fi
}


main "$@"
