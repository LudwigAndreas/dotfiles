#!/bin/bash

# HDFS File Fetcher
# This script fetches a file from HDFS via a remote host and copies it to the local machine

# Configuration - modify these variables according to your environment
REMOTE_HOST="your.remote.host.com"
REMOTE_USER="your_username"
# We'll use a temporary directory on the remote host
REMOTE_TEMP_DIR="/tmp/hdfs_fetcher_$USER"
# Default local destination directory (current directory)
LOCAL_DEST_DIR="."

# Function to display usage information
function show_usage {
    echo "Usage: $0 <hdfs_file_path> [local_destination_directory]"
    echo "  hdfs_file_path: Path to the file in HDFS"
    echo "  local_destination_directory: Optional. Directory where the file will be saved locally"
    echo "                               Defaults to current directory if not specified"
    exit 1
}

# Function to handle errors
function handle_error {
    echo "ERROR: $1" >&2
    exit 1
}

# Check if the required argument is provided
if [ $# -lt 1 ]; then
    show_usage
fi

# Parse command line arguments
HDFS_FILE_PATH="$1"
if [ $# -ge 2 ]; then
    LOCAL_DEST_DIR="$2"
fi

# Check if local destination directory exists
if [ ! -d "$LOCAL_DEST_DIR" ]; then
    handle_error "Local destination directory '$LOCAL_DEST_DIR' does not exist"
fi

# Extract the filename from the HDFS path
FILENAME=$(basename "$HDFS_FILE_PATH")
echo "File to fetch: $FILENAME"
echo "HDFS path: $HDFS_FILE_PATH"

# SSH to remote host and perform HDFS operations
echo "Connecting to $REMOTE_HOST to fetch file from HDFS..."
ssh -T "$REMOTE_USER@$REMOTE_HOST" << EOF || handle_error "SSH connection failed"
    # Create a temporary directory if it doesn't exist
    mkdir -p "$REMOTE_TEMP_DIR" || { echo "Failed to create temp directory"; exit 1; }
    
    # Check if file exists in HDFS
    hdfs dfs -test -e "$HDFS_FILE_PATH" || { echo "File does not exist in HDFS"; exit 1; }
    
    # Copy file from HDFS to temporary directory
    echo "Copying file from HDFS to temp directory on remote host..."
    hdfs dfs -get "$HDFS_FILE_PATH" "$REMOTE_TEMP_DIR/" || { echo "Failed to get file from HDFS"; exit 1; }
    
    # Verify file was copied
    if [ ! -f "$REMOTE_TEMP_DIR/$FILENAME" ]; then
        echo "File not found in temp directory after HDFS get operation"
        exit 1
    fi
    
    echo "File successfully copied to temp directory on remote host"
    exit 0
EOF

# Copy the file from remote host to local machine
echo "Copying file from remote host to local machine..."
scp "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TEMP_DIR/$FILENAME" "$LOCAL_DEST_DIR/" || handle_error "Failed to copy file from remote host"

# Clean up temporary files on remote host
echo "Cleaning up temporary files on remote host..."
ssh "$REMOTE_USER@$REMOTE_HOST" "rm -rf $REMOTE_TEMP_DIR" || echo "Warning: Failed to clean up temporary files"

echo "SUCCESS: File '$FILENAME' has been copied to '$LOCAL_DEST_DIR'"
