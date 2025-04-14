#!/bin/bash

# Oozie Workflow Deployment and Execution Automation Script

# Configuration Variables
HDFS_BASE_PATH="/user/your_username/your_workflow"
LOCAL_PROJECT_DIR="/path/to/local/project/directory"
OOZIE_SERVER_URL="http://your-oozie-server:11000/oozie"
WORKFLOW_XML_NAME="workflow.xml"
CLUSTER_NAME="your_cluster_name"

# Function to validate prerequisites
validate_prerequisites() {
    # Check if required commands exist
    for cmd in hdfs hadoop oozie yarn; do
        if ! command -v $cmd &> /dev/null; then
            echo "Error: $cmd command not found. Please ensure all dependencies are installed."
            exit 1
        fi
    done

    # Validate Kerberos authentication if required
    if [ -n "$KERBEROS_ENABLED" ]; then
        kinit -R || kinit
        if [ $? -ne 0 ]; then
            echo "Kerberos authentication failed"
            exit 1
        fi
    fi
}

# Function to clean existing HDFS directory
clean_hdfs_directory() {
    echo "Cleaning existing HDFS directory: $HDFS_BASE_PATH"
    hdfs dfs -rm -r -f "$HDFS_BASE_PATH" || true
    hdfs dfs -mkdir -p "$HDFS_BASE_PATH"
}

# Function to upload project files to HDFS
upload_to_hdfs() {
    echo "Uploading project files to HDFS..."
    
    # Upload files
    hdfs dfs -put "$LOCAL_PROJECT_DIR" "$HDFS_BASE_PATH"
}

# Function to submit Oozie workflow
submit_oozie_workflow() {
    echo "Submitting Oozie workflow..."
    
    # Prepare Oozie job properties
    cat > "$LOCAL_PROJECT_DIR/job.properties" << EOF
nameNode=hdfs://your-namenode:8020
jobTracker=your-jobtracker:8032
queueName=default
oozie.wf.application.path=$HDFS_BASE_PATH
EOF

    # Submit workflow to Oozie
    WORKFLOW_JOB_ID=$(oozie job -oozie "$OOZIE_SERVER_URL" -config "$LOCAL_PROJECT_DIR/job.properties" -submit)
    
    if [ -z "$WORKFLOW_JOB_ID" ]; then
        echo "Failed to submit Oozie workflow"
        exit 1
    fi
    
    echo "Workflow submitted with Job ID: $WORKFLOW_JOB_ID"
    return "$WORKFLOW_JOB_ID"
}

# Function to start workflow and monitor
start_and_monitor_workflow() {
    local JOB_ID="$1"
    
    # Start the workflow
    oozie job -oozie "$OOZIE_SERVER_URL" -start "$JOB_ID"
    
    # Monitor workflow status
    while true; do
        STATUS=$(oozie job -oozie "$OOZIE_SERVER_URL" -info "$JOB_ID" | grep -i 'status' | awk '{print $2}')
        
        case "$STATUS" in
            RUNNING)
                echo "Workflow is running..."
                sleep 30
                ;;
            SUCCEEDED)
                echo "Workflow completed successfully!"
                break
                ;;
            KILLED)
                echo "Workflow was killed. Check Oozie logs for details."
                exit 1
                ;;
            FAILED)
                echo "Workflow failed. Retrieving error logs..."
                oozie job -oozie "$OOZIE_SERVER_URL" -log "$JOB_ID"
                exit 1
                ;;
            *)
                echo "Unknown workflow status: $STATUS"
                sleep 30
                ;;
        esac
    done
}

# Function to capture and store logs
capture_logs() {
    local JOB_ID="$1"
    local LOG_DIR="$LOCAL_PROJECT_DIR/logs"
    
    mkdir -p "$LOG_DIR"
    
    # Capture Oozie workflow logs
    oozie job -oozie "$OOZIE_SERVER_URL" -log "$JOB_ID" > "$LOG_DIR/oozie_workflow_log.txt"
    
    # Capture YARN application logs (you might need to adjust based on your specific YARN setup)
    yarn logs -applicationId "$YARN_APP_ID" > "$LOG_DIR/yarn_application_log.txt"
}

# Main execution flow
main() {
    validate_prerequisites
    clean_hdfs_directory
    upload_to_hdfs
    
    WORKFLOW_JOB_ID=$(submit_oozie_workflow)
    start_and_monitor_workflow "$WORKFLOW_JOB_ID"
    capture_logs "$WORKFLOW_JOB_ID"
}

# Execute main function
main
