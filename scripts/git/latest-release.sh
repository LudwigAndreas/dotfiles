#!/bin/bash

# Default values
PREFIX="release/"
VERSION_PREFIX=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --version-prefix)
            VERSION_PREFIX="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to extract version from branch name
extract_version() {
    local branch="$1"
    # Remove prefix from branch name
    local version="${branch#$PREFIX}"
    # Remove version prefix if specified
    version="${version#$VERSION_PREFIX}"
    echo "$version"
}

# Get branches matching the prefix
branches=$(git branch -r | grep "origin/$PREFIX")

# If no branches found, exit
if [ -z "$branches" ]; then
    echo "No branches found with prefix $PREFIX"
    exit 1
fi

# Filter and sort branches
latest_branch=$(echo "$branches" | while read -r branch; do
    # Remove 'origin/' prefix from branch name for clean processing
    clean_branch="${branch#origin/}"
    version=$(extract_version "$clean_branch")
    
    # Use sort -V for version number sorting
    echo "$version $clean_branch"
done | sort -V | tail -n 1 | awk '{print $2}')

# Output the latest branch
if [ -n "$latest_branch" ]; then
    echo "$latest_branch"
else
    echo "No valid branches found"
    exit 1
fi
