#!/bin/bash

# Get a list of all .app directories in /Applications
app_list=$(find /Applications -maxdepth 1 -type d -name "*.app")

# Loop through the list and extract application names
IFS=$'\n'  # Set the Internal Field Separator to newline
for app_path in $app_list; do
    app_name=$(basename "$app_path" ".app")
    echo "$app_name"
done
