#!/bin/bash

# Universal argument parser function that doesn't use 'declare'
# Usage: parse_args "$@"
parse_args() {
    # Clear any existing ARG_ variables
    unset $(env | grep ^ARG_ | cut -d= -f1)
    
    # Initialize counter for positional arguments
    ARG_POSITIONAL_COUNT=0
    
    # Loop through all arguments
    for arg in "$@"; do
        # Check if argument has the format --key=value or -k=value
        if [[ "$arg" =~ ^--([^=]+)=(.*)$ ]]; then
            # Long format: --key=value
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            # Replace hyphens with underscores for valid variable names
            key=$(echo "$key" | tr '-' '_')
            # Set variable ARG_KEY=VALUE
            export "ARG_${key}=${value}"
        elif [[ "$arg" =~ ^-([^=]+)=(.*)$ ]]; then
            # Short format: -k=value
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            export "ARG_${key}=${value}"
        elif [[ "$arg" =~ ^--([^=]+)$ ]]; then
            # Flag format: --flag (no value)
            key="${BASH_REMATCH[1]}"
            key=$(echo "$key" | tr '-' '_')
            export "ARG_${key}=true"
        elif [[ "$arg" =~ ^-([^=]+)$ ]]; then
            # Flag format: -f (no value)
            key="${BASH_REMATCH[1]}"
            export "ARG_${key}=true"
        else
            # Positional argument
            export "ARG_POSITIONAL_${ARG_POSITIONAL_COUNT}=${arg}"
            ARG_POSITIONAL_COUNT=$((ARG_POSITIONAL_COUNT + 1))
        fi
    done
    
    # Export the count of positional arguments
    export ARG_POSITIONAL_COUNT
    
    # Output a list of all ARG_ variables - useful for debugging
    # echo "# Generated ARG_ variables:"
    # env | grep ^ARG_ | sort
}

# Function to get all argument names
get_arg_names() {
    env | grep ^ARG_ | grep -v ARG_POSITIONAL | cut -d= -f1 | sed 's/^ARG_//' | sort
}

# Function to get all positional arguments
get_positional_args() {
    for ((i=0; i<$ARG_POSITIONAL_COUNT; i++)); do
        var_name="ARG_POSITIONAL_$i"
        echo "${!var_name}"
    done
}

# Example usage:
# source ./parser.sh
# parse_args "$@"
# 
# Access arguments:
# echo "File: $ARG_file"
# echo "Name: $ARG_n"
# echo "Verbose flag: $ARG_verbose"
#
# Check if an argument exists:
# if [ -n "$ARG_help" ]; then
#     show_help
# fi
#
# Loop through all arguments:
# for key in $(get_arg_names); do
#     var_name="ARG_$key"
#     echo "$key: ${!var_name}"
# done
#
# Loop through positional arguments:
# for arg in $(get_positional_args); do
#     echo "Positional arg: $arg"
# done
