#!/bin/bash

[[ $(type -t logl) == function ]] || source ./log4bash.sh

# Function to handle user input
#   Usage:
# options=("Option 1" "Option 2" "Option 3" "Option 4" "Option 5" "Option 5" "Quit")
# choose_option_vim $options
# selected=$?
# echo "You selected: ${options[$selected]}"
function choose_option_vim {

    # Function to display menu
    function _draw_menu_vim {
        selected=$1
        options=$2
        tput civis # Hide cursor
        tput sc    # Save cursor position
        logl TRACE "Use Arrow Keys or 'j'/'k' to navigate. Press 'Enter' to select."
        echo
        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf "%s[>] ${options[$i]}%s\n" "${cgreen}" "${cwhite}" # Highlight selected option
            else
                printf "    ${options[$i]}\n"
            fi
        done
        tput rc   # Restore cursor position
    }


    clear
    selected=0
    while true; do
        _draw_menu_vim $selected $1
        read -rsn1 key # Read single keypress

        case "$key" in
            $'\x1b')  # Handle arrow keys (Escape sequence)
                read -rsn2 -t 0.1 key  # Read next two characters
                case "$key" in
                    '[A') ((selected=(selected-1+${#options[@]})%${#options[@]})) ;; # Up arrow
                    '[B') ((selected=(selected+1)%${#options[@]})) ;; # Down arrow
                esac
                ;;
            'k') ((selected=(selected-1+${#options[@]})%${#options[@]})) ;; # Vim 'k' (up)
            'j') ((selected=(selected+1)%${#options[@]})) ;; # Vim 'j' (down)
            'q')  # Enter key pressed
                selected=-1
                break
                ;;
            '')  # Enter key pressed
                break
                ;;
        esac
    done
    tput cnorm
    tput ed
    clear
    return $selected
}
