#!/bin/bash

# YARN Distributed Application Deployment and Execution Script

# Configuration Variables
HDFS_BASE_PATH="/user/your_username/your_distributed_app"
LOCAL_PROJECT_DIR="/path/to/local/project/directory"
CLUSTER_NAME="your_cluster_name"

# Client Application Configuration
CLIENT_JAR="client-application.jar"
APPMASTER_JAR="appmaster.jar"
CONTAINER_JAR="container-application.jar"

# Logging and Monitoring Configuration
LOG_DIR="/path/to/local/logs"
VERBOSE_MODE=true

# Authentication and Security
KERBEROS_ENABLED=true
KEYTAB_FILE="/path/to/your/keytab"
PRINCIPAL="your_principal@REALM"

# Utility function for logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [[ "$VERBOSE_MODE" == true ]]; then
        echo "[$timestamp] [$level] $message"
    fi
}

# Validate and prepare authentication
authenticate() {
    if [[ "$KERBEROS_ENABLED" == true ]]; then
        log "INFO" "Initiating Kerberos authentication"
        
        # Destroy existing tickets
        kdestroy
        
        # Authenticate using keytab
        kinit -kt "$KEYTAB_FILE" "$PRINCIPAL"
        
        if [[ $? -ne 0 ]]; then
            log "ERROR" "Kerberos authentication failed"
            exit 1
        fi
        
        log "INFO" "Kerberos authentication successful"
    fi
}

# Prepare HDFS directory structure
prepare_hdfs_directories() {
    log "INFO" "Preparing HDFS directory structure"
    
    # Create base directories
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH/lib"
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH/conf"
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH/logs"
}

# Upload application artifacts to HDFS
upload_artifacts() {
    log "INFO" "Uploading application artifacts to HDFS"
    
    # Upload JARs
    hdfs dfs -put -f "$LOCAL_PROJECT_DIR/$CLIENT_JAR" "$HDFS_BASE_PATH/lib/"
    hdfs dfs -put -f "$LOCAL_PROJECT_DIR/$APPMASTER_JAR" "$HDFS_BASE_PATH/lib/"
    hdfs dfs -put -f "$LOCAL_PROJECT_DIR/$CONTAINER_JAR" "$HDFS_BASE_PATH/lib/"
    
    # Upload configuration files if any
    hdfs dfs -put -f "$LOCAL_PROJECT_DIR"/*.xml "$HDFS_BASE_PATH/conf/" 2>/dev/null
    hdfs dfs -put -f "$LOCAL_PROJECT_DIR"/*.properties "$HDFS_BASE_PATH/conf/" 2>/dev/null
}

# Launch YARN application
launch_yarn_application() {
    log "INFO" "Launching YARN distributed application"
    
    # Prepare command for client application
    YARN_COMMAND="yarn jar $LOCAL_PROJECT_DIR/$CLIENT_JAR \
        com.your.company.MainClientClass \
        -libjars $HDFS_BASE_PATH/lib/$APPMASTER_JAR,$HDFS_BASE_PATH/lib/$CONTAINER_JAR \
        -conf $HDFS_BASE_PATH/conf \
        -logdir $HDFS_BASE_PATH/logs"
    
    # Execute YARN application
    log "DEBUG" "Executing command: $YARN_COMMAND"
    
    # Capture application ID
    APPLICATION_ID=$(eval "$YARN_COMMAND" | grep -oP 'Submitted application \K[^ ]+')
    
    if [[ -z "$APPLICATION_ID" ]]; then
        log "ERROR" "Failed to submit YARN application"
        exit 1
    fi
    
    log "INFO" "Application submitted successfully. Application ID: $APPLICATION_ID"
    echo "$APPLICATION_ID"
}

# Monitor application status
monitor_application() {
    local app_id="$1"
    
    log "INFO" "Monitoring application: $app_id"
    
    while true; do
        # Get application state
        APP_STATE=$(yarn application -status "$app_id" | grep -oP 'State : \K\w+')
        
        case "$APP_STATE" in
            RUNNING)
                log "INFO" "Application is running"
                sleep 60  # Check every minute
                ;;
            FINISHED)
                log "SUCCESS" "Application completed successfully"
                break
                ;;
            FAILED)
                log "ERROR" "Application failed"
                capture_diagnostics "$app_id"
                exit 1
                ;;
            KILLED)
                log "ERROR" "Application was killed"
                capture_diagnostics "$app_id"
                exit 1
                ;;
            *)
                log "INFO" "Current state: $APP_STATE"
                sleep 30
                ;;
        esac
    done
}

# Capture application diagnostics
capture_diagnostics() {
    local app_id="$1"
    
    log "INFO" "Capturing application diagnostics"
    
    # Create diagnostics directory
    mkdir -p "$LOG_DIR/$app_id"
    
    # Capture application logs
    yarn logs -applicationId "$app_id" > "$LOG_DIR/$app_id/application_logs.txt"
    
    # Capture application diagnostics
    yarn application -status "$app_id" > "$LOG_DIR/$app_id/application_status.txt"
}

# Main execution flow
main() {
    # Authenticate
    authenticate
    
    # Prepare HDFS
    prepare_hdfs_directories
    
    # Upload artifacts
    upload_artifacts
    
    # Launch application
    APP_ID=$(launch_yarn_application)
    
    # Monitor application
    monitor_application "$APP_ID"
    
    # Final log capture
    capture_diagnostics "$APP_ID"
}

# Execute main function
main
