#!/bin/bash

# Function to detect the operating system
detect_os() {
    local os_type=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_type="linux"
    elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
        os_type="windows"
    else
        echo "Unsupported operating system"
        exit 1
    fi
    echo "$os_type"
}

# Function to open URL based on operating system
open_url() {
    local url="$1"
    local os_type=$(detect_os)

    # Validate URL
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "Invalid URL. Please provide a full URL starting with http:// or https://"
        exit 1
    fi

    # Open URL based on OS
    case "$os_type" in
        "macos")
            open "$url"
            ;;
        "linux")
            # Try multiple browser openers
            if command -v xdg-open > /dev/null; then
                xdg-open "$url"
            elif command -v gnome-open > /dev/null; then
                gnome-open "$url"
            elif command -v kde-open > /dev/null; then
                kde-open "$url"
            elif command -v exo-open > /dev/null; then
                exo-open "$url"
            elif command -v wslview > /dev/null; then
                wslview "$url"
            else
                echo "No suitable browser opener found on Linux"
                exit 1
            fi
            ;;
        "windows")
            # Windows support for different environments
            if command -v start > /dev/null; then
                start "$url"
            elif command -v explorer > /dev/null; then
                explorer "$url"
            elif command -v wslview > /dev/null; then
                wslview "$url"
            else
                echo "No suitable browser opener found on Windows"
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Main script execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <url>"
    echo "Example: $0 https://www.example.com"
    exit 1
fi

# Open the provided URL
open_url "$1"
