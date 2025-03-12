#!/bin/bash

# Traditional argument parser function that handles format "--argument value" and "-a value"
# NOTE: flag arguments (--argument) without values should go AFTER last positional argument
# Usage: parse_args "$@"
parse_args() {
    # Clear any existing ARG_ variables
    unset $(env | grep ^ARG_ | cut -d= -f1 2>/dev/null || true)
    
    # Initialize counter for positional arguments
    ARG_POSITIONAL_COUNT=0
    
    # Convert arguments to array for easier access
    args=("$@")
    total_args=${#args[@]}
    
    # Loop through all arguments
    i=0
    while [ $i -lt $total_args ]; do
        arg="${args[$i]}"
        next_idx=$((i + 1))
        
        # Check for different argument formats
        if [[ "$arg" =~ ^--([^=]+)$ ]]; then
            # Format: --key value
            key="${BASH_REMATCH[1]}"
            key=$(echo "$key" | tr '-' '_')
            
            # Check if there's a value (next argument that doesn't start with -)
            if [ $next_idx -lt $total_args ] && ! [[ "${args[$next_idx]}" =~ ^- ]]; then
                value="${args[$next_idx]}"
                export "ARG_${key}=${value}"
                i=$((i + 1))  # Skip the next argument as we've used it as a value
            else
                # It's a flag without value
                export "ARG_${key}=true"
            fi
        elif [[ "$arg" =~ ^-([a-zA-Z0-9])$ ]]; then
            # Format: -k value
            key="${BASH_REMATCH[1]}"
            
            # Check if there's a value (next argument that doesn't start with -)
            if [ $next_idx -lt $total_args ] && ! [[ "${args[$next_idx]}" =~ ^- ]]; then
                value="${args[$next_idx]}"
                export "ARG_${key}=${value}"
                i=$((i + 1))  # Skip the next argument as we've used it as a value
            else
                # It's a flag without value
                export "ARG_${key}=true"
            fi
        elif [[ "$arg" =~ ^--([^=]+)=(.*)$ ]]; then
            # Also support --key=value format for backward compatibility
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            key=$(echo "$key" | tr '-' '_')
            export "ARG_${key}=${value}"
        elif [[ "$arg" =~ ^-([^=]+)=(.*)$ ]]; then
            # Also support -k=value format for backward compatibility
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            export "ARG_${key}=${value}"
        elif [[ "$arg" =~ ^-([a-zA-Z0-9]{2,})$ ]]; then
            # Handle combined short flags: -abc (equivalent to -a -b -c)
            flags="${BASH_REMATCH[1]}"
            for ((j=0; j<${#flags}; j++)); do
                key="${flags:$j:1}"
                export "ARG_${key}=true"
            done
        else
            # Positional argument
            export "ARG_POSITIONAL_${ARG_POSITIONAL_COUNT}=${arg}"
            ARG_POSITIONAL_COUNT=$((ARG_POSITIONAL_COUNT + 1))
        fi
        
        i=$((i + 1))
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
        eval echo \"\${$var_name}\"
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
