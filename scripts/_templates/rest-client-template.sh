#!/usr/bin/env bash

# set -o errexit
# set -o pipefail
# set -o nounset


readonly API_BASE_URL="https://rickandmortyapi.com/api"


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
    RESET="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGNETA=""
    CYAN=""
    RESET=""
fi

logi() {
    printf "%s[*] $1%s\n" "${RESET}" "${RESET}"
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
    printf %s "${RESET}"
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
    local data
    data=$1

    logd "Authenticating using auth data file: ${data}"

    local response

    response=$(curl -s -X POST "${API_BASE_URL}/auth/login" \
        -H "Content-Type: application/json" \
        -d @"${data}")

    if [[ -z "${response}" ]]; then
        loge "Authentication failed. Response:"
        loge "${response}"
        exit 2
    fi

    echo ${response}
}

call_api() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"
    local token

    token="$(authenticate ${AUTH})"

    local url="${API_BASE_URL}/${endpoint}"

    logd "fetching ${endpoint}"

    if [[ -n "${data}" ]]; then
        curl -s -X "${method}" "${url}" \
            -H "Authorization: Bearer: ${token}" \
            -H "Content-Type: application/json" \
            -d "${data}"
    else
        curl -s -X "${method}" "${url}" \
            -H "Authorization: Bearer ${token}"
    fi
}

get_character() {
    call_api $1 
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -a|--auth)
                AUTH="$2"
                shift 2
                ;;
            -path|--path)
                path="$2"
                shift 2
                ;;
            *)
                loge "Error: Unknown option $1"
                usage
                ;;
        esac
    done


    # Check required arguments
    if [ -z "$AUTH" ]; then
        loge "Error: auth file is required"
        usage
    fi

    if [ -z "$path" ]; then
        loge "Error: path file is required"
        usage
    fi

    get_character "$path"

    exit 0
}

main "$@"
