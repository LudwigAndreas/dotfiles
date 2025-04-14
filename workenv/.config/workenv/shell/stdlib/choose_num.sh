#!/bin/bash

[[ $(type -t logl) == function ]] || source ./log4bash.sh

# Function to display a numbered menu and accept any number as input
#   Usage
# options=("Option 1" "Option 2" "Option 3" "Option 4" "Quit")
# display_menu "${options[@]}"
# echo "Your selection ${options[$?]}"
function choose_num {
    local options=("$@")  # Accept options as arguments
    local num_options=${#options[@]}
    echo $num_options
    
    while true; do
        clear
        logl TRACE "Select an option by entering a number:"
        echo
        
        for i in "${!options[@]}"; do
             printf "[$((i+1))] ${options[$i]}\n"
        done

        echo
        logl TRACE "Enter choice (or 0 to quit):"
        read -r choice

        # Validate input: check if it's a number
        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            logl ERROR "Invalid input. Please enter a number."
            sleep 2
            continue
        fi

        # Convert to integer
        choice=$((choice))

        # Quit if 0 is entered
        if [[ $choice -eq 0 ]]; then
            logl TRACE "Exited without selection."
            choice=-2
            break
        fi
        # Check if choice is within range
        if (( choice >= 1 && choice <= num_options )); then
            break
        else
            logl ERROR "Invalid choice. Please enter a number between 1 and $num_options."
            sleep 1
        fi
    done
    tput cnorm
    tput ed
    clear
    return $((choice-1))
}

