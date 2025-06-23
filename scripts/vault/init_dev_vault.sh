#!/bin/bash

# Base directory (default to ~/devault if not provided)
BASE_DIR="${1:-$HOME/vault}"

echo "Creating devault structure in: $BASE_DIR"

# Define directory structure
declare -a DIRS=(
    "$BASE_DIR/projects"
    "$BASE_DIR/logs"
    "$BASE_DIR/resources"
    "$BASE_DIR/notes"
    "$BASE_DIR/tools"
)

# Create main structure
for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    echo "Created $dir"
done

echo "Vault is initialized."
