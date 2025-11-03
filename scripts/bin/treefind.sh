#!/usr/bin/env bash
# ==============================================================================
# Script Name:   treefind.sh
# Description:   Find file or directory
# Author:        Ludwig Andreas
# License:       MIT
# ==============================================================================
#
# Usage:
#   ./treefind.sh [FLAGS] [ARGS...]
#
# Example:
#   ./treefind.sh --verbose input.txt
#
# Notes:
#   - This script follows the Google Shell Style Guide.
#   - It is POSIX-compliant where possible, but uses Bash-specific features.

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

if [[ $# == 0 ]]; then
  tree .
  exit 0
elif [[ $# == 1 ]]; then
  what="$1"
  where="$(pwd)"
elif [[ $# == 2 ]]; then
  what="$1"
  where="$2"
else
  echo 'too many arguments' 1>&2
  exit 1
fi

if [[ "$what" == *[[:upper:]]* ]]; then
  ignore_case_arg=''
else
  ignore_case_arg='--ignore-case'
fi

tree --prune "$ignore_case_arg" --matchdirs -P "$what" "$where"
