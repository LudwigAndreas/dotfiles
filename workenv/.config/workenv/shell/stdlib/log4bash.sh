#!/bin/bash

cblack="$(tput setaf 0)"
cred="$(tput setaf 1)"
cgreen="$(tput setaf 2)"
cyellow="$(tput setaf 3)"
cblue="$(tput setaf 4)"
cmagneta="$(tput setaf 5)"
ccyan="$(tput setaf 6)"
cwhite="$(tput sgr0)"

COLOR_MODE=true
VERBOSE_MODE=true

printf_log() {
    local level="[$1]"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local color="${cwhite}"
    if [[ -n "$3" ]]; then
        color="$3"
    fi

    if [[ "$VERBOSE_MODE" == true ]]; then
        if [[ "$COLOR_MODE" == true ]]; then
            printf "%s - %s%11s%s : %s\n" "${timestamp}" "${color}" "${level}" "${cwhite}" "${message}"
        else
            printf "%s - %11s : %s\n" "${timestamp}" "${level}" "${message}"
        fi
    fi
}

# Utility function for logging
# Usage: log "INFO" "Application submitted successfully"
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    case "$level" in
        ERROR)
            printf_log "ERROR" "$message" "$cred"
            ;;
        WARNING)
            printf_log "WARNING" "$message" "$cyellow"
            ;;
        INFO)
            printf_log "INFO" "$message" "$cgreen"
            ;;
        DEBUG)
            printf_log "DEBUG" "$message" "$cblue"
            ;;
        *)
            printf_log "TRACE" "$message" "$cwhite"
            ;;
    esac
}

printf_logl() {
    local level="[$1]"
    local message="$2"
    local color="${cwhite}"
    if [[ -n "$3" ]]; then
        color="$3"
    fi

    if [[ "$VERBOSE_MODE" == true ]]; then
        if [[ "$COLOR_MODE" == true ]]; then
            printf "%s%3s %s%s\n" "${color}" "${level}" "${message}" "${cwhite}"
        else
            printf "%3s %s\n" "${level}" "${message}"
        fi
    fi
}

# Utility function for logging
# Usage: log "INFO" "Application submitted successfully"
logl() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    case "$level" in
        ERROR)
            printf_logl "-" "$message" "$cred"
            ;;
        WARNING)
            printf_logl "-" "$message" "$cyellow"
            ;;
        INFO)
            printf_logl "+" "$message" "$cgreen"
            ;;
        DEBUG)
            printf_logl "*" "$message" "$cblue"
            ;;
        *)
            printf_logl "*" "$message" "$cwhite"
            ;;
    esac
}

export -f log
export -f logl

