#!/bin/bash

# YARN Application Host Discovery Script

get_application_host() {
    local application_id="$1"
    
    # Retrieve application details
    local app_details=$(yarn app -status "$application_id")
    
    # Extract host information using multiple methods
    local host_info=""
    
    # Method 1: Try to extract from application details
    host_info=$(echo "$app_details" | grep -oP 'Host\s*:\s*\K[^\s]+')
    
    # Method 2: Use YARN application list with more detailed information
    if [[ -z "$host_info" ]]; then
        host_info=$(yarn app -list -appStates ALL | grep "$application_id" | awk '{print $8}')
    }
    
    # Method 3: Use advanced YARN command to get comprehensive information
    if [[ -z "$host_info" ]]; then
        host_info=$(yarn applicationattempt -list "$application_id" | grep -oP 'Node NodeId\s*:\s*\K[^\s]+' | cut -d ':' -f1)
    }
    
    # Output the host
    if [[ -n "$host_info" ]]; then
        echo "$host_info"
        return 0
    else
        echo "Could not determine host for application $application_id" >&2
        return 1
    }
}

# Function to get all container details for an application
get_application_containers() {
    local application_id="$1"
    
    # Use YARN command to list containers
    yarn org.apache.hadoop.yarn.client.cli.ApplicationCLI containerlist -applicationId "$application_id"
}

# Main function to demonstrate usage
main() {
    local application_id="$1"
    
    if [[ -z "$application_id" ]]; then
        echo "Usage: $0 <application_id>"
        exit 1
    }
    
    # Get and display host
    echo "Application Host:"
    get_application_host "$application_id"
    
    # Optional: Get container details
    echo -e "\nContainer Details:"
    get_application_containers "$application_id"
}

# Execute main function with provided application ID
main "$1"
