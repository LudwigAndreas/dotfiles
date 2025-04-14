#!/bin/bash

# Smart HDFS Deployment Script with File Hash Verification

# Configuration Variables
HDFS_BASE_PATH="/user/your_username/your_distributed_app"
LOCAL_PROJECT_DIR="/path/to/local/project/directory"
HASH_STORE_FILE="/path/to/local/file_hashes.json"

# Function to calculate file hash
calculate_file_hash() {
    local file_path="$1"
    # Use SHA-256 for comprehensive file integrity check
    openssl dgst -sha256 "$file_path" | awk '{print $2}'
}

# Function to read existing file hashes from JSON
read_existing_hashes() {
    if [[ ! -f "$HASH_STORE_FILE" ]]; then
        echo "{}" > "$HASH_STORE_FILE"
    fi
    
    # Use jq for JSON manipulation
    cat "$HASH_STORE_FILE"
}

# Function to update file hashes in JSON
update_file_hashes() {
    local new_hashes="$1"
    echo "$new_hashes" > "$HASH_STORE_FILE"
}

# Function to determine files that need to be uploaded
get_files_to_upload() {
    local existing_hashes
    local files_to_upload=()
    
    # Read existing hashes
    existing_hashes=$(read_existing_hashes)
    
    # Check files in local project directory
    for file in "$LOCAL_PROJECT_DIR"/*.{jar,xml,properties,sh}; do
        [[ -e "$file" ]] || continue
        
        local filename=$(basename "$file")
        local current_hash=$(calculate_file_hash "$file")
        
        # Check if file exists in hash store and compare hash
        local stored_hash=$(echo "$existing_hashes" | jq -r --arg filename "$filename" '.[$filename] // ""')
        
        if [[ "$current_hash" != "$stored_hash" ]]; then
            files_to_upload+=("$file")
            
            # Update hash in JSON
            existing_hashes=$(echo "$existing_hashes" | jq --arg filename "$filename" --arg hash "$current_hash" '.[$filename] = $hash')
        fi
    done
    
    # Update hash store
    update_file_hashes "$existing_hashes"
    
    # Return files to upload
    printf '%s\n' "${files_to_upload[@]}"
}

# Function to upload files to HDFS
upload_changed_files() {
    local files_to_upload
    mapfile -t files_to_upload < <(get_files_to_upload)
    
    if [[ ${#files_to_upload[@]} -eq 0 ]]; then
        echo "No files need to be uploaded. All files are up to date."
        return 0
    fi
    
    echo "Files to upload:"
    printf '%s\n' "${files_to_upload[@]}"
    
    # Create HDFS directories
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH/lib"
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH/conf"
    
    # Upload each changed file
    for file in "${files_to_upload[@]}"; do
        local filename=$(basename "$file")
        
        # Determine target directory based on file extension
        local target_dir="$HDFS_BASE_PATH/lib"
        case "$filename" in 
            *.xml|*.properties)
                target_dir="$HDFS_BASE_PATH/conf"
                ;;
            *.sh)
                target_dir="$HDFS_BASE_PATH/scripts"
                hdfs dfs -mkdir -p "$target_dir"
                ;;
        esac
        
        # Upload file
        echo "Uploading $filename to $target_dir"
        hdfs dfs -put -f "$file" "$target_dir/$filename"
    done
}

# Main deployment function
deploy_to_hdfs() {
    # Validate prerequisites
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed. Please install jq to use this script."
        exit 1
    fi
    
    if ! command -v openssl &> /dev/null; then
        echo "Error: openssl is not installed. Please install openssl to use this script."
        exit 1
    fi
    
    # Perform smart upload
    upload_changed_files
}

# Execute deployment
deploy_to_hdfs
