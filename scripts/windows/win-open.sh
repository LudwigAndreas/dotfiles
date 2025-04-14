#!/bin/bash

# Function to open an application based on input
open_application() {
    local app_name="$1"
    
    # Convert app name to lowercase for case-insensitive matching
    app_name=$(echo "$app_name" | tr '[:upper:]' '[:lower:]')
    
    # Define application paths (modify these to match your system)
    case "$app_name" in
        "chrome")
            start "" "C:\Program Files\Google\Chrome\Application\chrome.exe"
            ;;
        "firefox")
            start "" "C:\Program Files\Mozilla Firefox\firefox.exe"
            ;;
        "vscode")
            start "" "C:\Users\$(whoami)\AppData\Local\Programs\Microsoft VS Code\Code.exe"
            ;;
        "notepad++")
            start "" "C:\Program Files\Notepad++\notepad++.exe"
            ;;
        "spotify")
            start "" "C:\Users\$(whoami)\AppData\Roaming\Spotify\Spotify.exe"
            ;;
        *)
            echo "Application '$1' not found in the script. Please add its path."
            return 1
            ;;
    esac
}

# Check if an application name was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <application_name>"
    echo "Supported applications: chrome, firefox, vscode, notepad++, spotify"
    exit 1
fi

# Call the function with the provided application name
open_application "$1"
