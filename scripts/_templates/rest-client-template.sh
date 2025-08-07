#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset


readonly API_BASE_URL=""


__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

if command -v tput &>/dev/null && [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGNETA="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput sgr0)"
    RESET="$(tput init)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGNETA=""
    CYAN=""
    WHITE=""
    RESET=""
fi

logi() {
    printf "%s[*] $1%s\n" "${WHITE}" "${RESET}"
}

loge() {
    printf "%s[-] $1%s\n" "${RED}" "${RESET}" >&2
}

logs() {
    printf "%s[+] $1%s\n" "${GREEN}" "${RESET}"
}

logd() {
    [ -n "$VERBOSE" ] && printf "[*] %s$1%s\n" "${YELLOW}" "${RESET}"
}

# Tempate printing usage
usage() {
    printf %s "${WHITE}"
    echo "Usage:	$0 [Options]"
    echo
    echo "Options:"
    echo "  -h, --help		Show this help message and exit"
    echo "  -a, --action	Required argument"
    echo "  -f, --file		Optional argument"
    echo "  -v, --verbose	Enable verbose mode"
    printf %s "${RESET}"
    exit 0
}


authenticate() {
    if [[ $# -lt 1 ]]; then
        loge "Error: missing endpoint argument"
}

call_api() {

}



arg1="${1:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -p|--path)
      path="$2"
      shift 2
      ;;
    -a|--auth)
      file="$2"
      shift 2
      ;;
    *)
      loge "Error: Unknown option $1"
      usage
      ;;
  esac
done


# Check required arguments
if [ -z "$auth" ]; then
  loge "Error: auth file is required"
  usage
fi

if [ -z "$path" ]; then
  loge "Error: path file is required"
  usage
fi

exit 0
