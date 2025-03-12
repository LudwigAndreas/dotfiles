#!/bin/bash

[[ $(type -t logl) == function ]] || source ./log4bash.sh

# Template asking [y]es or [n]o (with case insensetive input)
#   Usage:
# ask_yes_no "Do you want burger?"
# selection=$?
function ask_yes_no {
    local message="$1"
    ([ -n "$message" ] && logl TRACE "${message} [Y/N] :" && sleep 1) || logl TRACE "Do you want to continue [Y/N] : "
    while true; do
        read -r install
        # Optional reassignment (only if needed case insensetive parsing)
        install=$(echo "$install" | tr 'a-z' 'A-Z')
        case $install in
            Y|YES)
                return 0
            ;;
            N|NO)
                return 1
            ;;
            *)
                logl ERROR "Invalid input. Please answer with 'Y[es]' or 'N[o]' [Y/N] : "
                continue
            ;;
        esac
    done
}
