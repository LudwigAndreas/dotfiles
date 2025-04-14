#!/bin/bash

# Remote File Transfer and HDFS Upload Script

# Configuration Variables
REMOTE_HOST=""
REMOTE_USER=""
LOCAL_FILE=""
HDFS_DESTINATION=""

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    case "$level" in
        INFO)
            echo "[INFO] $timestamp - $message"
            ;;
        ERROR)
            echo "[ERROR] $timestamp - $message" >&2
            ;;
        WARNING)
            echo "[WARNING] $timestamp - $message"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Validate input parameters
validate_inputs() {
    # Check if required parameters are set
    if [[ -z "$REMOTE_HOST" ]]; then
        log ERROR "Remote host is not specified"
        usage
        exit 1
    fi

    if [[ -z "$REMOTE_USER" ]]; then
        log ERROR "Remote user is not specified"
        usage
        exit 1
    fi

    if [[ -z "$LOCAL_FILE" ]]; then
        log ERROR "Local file is not specified"
        usage
        exit 1
    fi

    if [[ -z "$HDFS_DESTINATION" ]]; then
        log ERROR "HDFS destination is not specified"
        usage
        exit 1
    }

    # Check if local file exists
    if [[ ! -f "$LOCAL_FILE" ]]; then
        log ERROR "Local file does not exist: $LOCAL_FILE"
        exit 1
    fi
}

# Usage instructions
usage() {
    echo "Usage: $0 -h <remote_host> -u <remote_user> -f <local_file> -d <hdfs_destination>"
    echo "Example: $0 -h hadoop-server.example.com -u hadoop -f /path/to/local/file.txt -d /user/hadoop/input/"
}

# Transfer file to remote host
transfer_file() {
    local local_file="$1"
    local remote_host="$2"
    local remote_user="$3"
    
    log INFO "Transferring file to remote host"
    
    # Use scp for file transfer with compression
    scp -C "$local_file" "$remote_user@$remote_host:/tmp/$(basename "$local_file")"
    
    if [[ $? -ne 0 ]]; then
        log ERROR "File transfer failed"
        exit 1
    fi
    
    log INFO "File transfer completed successfully"
}

# Execute remote commands via SSH
execute_remote_hdfs_upload() {
    local remote_host="$1"
    local remote_user="$2"
    local remote_file="/tmp/$(basename "$LOCAL_FILE")"
    local hdfs_destination="$3"
    
    log INFO "Executing remote HDFS upload"
    
    # SSH command with inline HDFS upload
    ssh "$remote_user@$remote_host" << EOSSH
        # Authenticate Kerberos if needed
        kinit -R || true
        
        # Check HDFS directory existence, create if not exists
        hdfs dfs -test -d "$hdfs_destination" || hdfs dfs -mkdir -p "$hdfs_destination"
        
        # Upload file to HDFS
        hdfs dfs -put -f "$remote_file" "$hdfs_destination"
        
        # Check upload status
        if [[ $? -eq 0 ]]; then
            echo "File successfully uploaded to HDFS"
            
            # Optional: Remove local temporary file
            rm "$remote_file"
        else
            echo "HDFS upload failed"
            exit 1
        fi
EOSSH
    
    # Check SSH exit status
    if [[ $? -ne 0 ]]; then
        log ERROR "Remote HDFS upload failed"
        exit 1
    fi
    
    log INFO "HDFS upload completed successfully"
}

# Main execution function
main() {
    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--host)
                REMOTE_HOST="$2"
                shift 2
                ;;
            -u|--user)
                REMOTE_USER="$2"
                shift 2
                ;;
            -f|--file)
                LOCAL_FILE="$2"
                shift 2
                ;;
            -d|--destination)
                HDFS_DESTINATION="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log ERROR "Unknown parameter: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Validate inputs
    validate_inputs
    
    # Execute workflow
    transfer_file "$LOCAL_FILE" "$REMOTE_HOST" "$REMOTE_USER"
    execute_remote_hdfs_upload "$REMOTE_HOST" "$REMOTE_USER" "$HDFS_DESTINATION"
    
    log INFO "Workflow completed successfully"
}

# Run main function with all arguments
main "$@"
