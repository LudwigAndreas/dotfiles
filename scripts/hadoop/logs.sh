#!/bin/bash

# YARN Log Fetcher
# This script fetches logs from a YARN application, separating them into client, appmaster, and container logs

# Usage message
usage() {
  echo "Usage: $0 -a APPLICATION_ID [-c CLIENT_ID] [-o OUTPUT_DIR]"
  echo "  -a APPLICATION_ID    YARN application ID"
  echo "  -c CLIENT_ID         Client ID (optional)"
  echo "  -o OUTPUT_DIR        Output directory (default: ./logs)"
  echo "  -h                   Display this help message"
  exit 1
}

# Default values
OUTPUT_DIR="./logs"
APPLICATION_ID=""
CLIENT_ID=""

# Parse command line arguments
while getopts "a:c:o:h" opt; do
  case ${opt} in
    a)
      APPLICATION_ID=$OPTARG
      ;;
    c)
      CLIENT_ID=$OPTARG
      ;;
    o)
      OUTPUT_DIR=$OPTARG
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      usage
      ;;
  esac
done

# Check if APPLICATION_ID is provided
if [ -z "$APPLICATION_ID" ]; then
  echo "ERROR: Application ID is required"
  usage
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
echo "Logs will be saved to: $OUTPUT_DIR"

# Function to get client logs (from Oozie)
fetch_client_logs() {
  echo "Fetching client logs..."
  
  if [ -n "$CLIENT_ID" ]; then
    echo "Using Client ID: $CLIENT_ID"
    # If you have specific commands to fetch client logs using Client ID, add them here
    # For example, you might need to query Oozie logs
    oozie job -log "$CLIENT_ID" > "$OUTPUT_DIR/client.log" 2>&1
  else
    # Try to get client logs from application ID
    echo "No Client ID provided, attempting to fetch client logs from application logs..."
    yarn logs -applicationId "$APPLICATION_ID" | grep -A 50 "client" > "$OUTPUT_DIR/client.log" 2>&1
  fi
  
  echo "Client logs saved to: $OUTPUT_DIR/client.log"
}

# Function to get AppMaster logs
fetch_appmaster_logs() {
  echo "Fetching AppMaster logs..."
  
  # Get appmaster container ID
  APPMASTER_CONTAINER=$(yarn application -status "$APPLICATION_ID" | grep "AM" | awk '{print $1}')
  
  if [ -n "$APPMASTER_CONTAINER" ]; then
    echo "AppMaster container found: $APPMASTER_CONTAINER"
    yarn logs -applicationId "$APPLICATION_ID" -containerId "$APPMASTER_CONTAINER" > "$OUTPUT_DIR/appmaster.log" 2>&1
  else
    echo "AppMaster container not found, fetching all logs and filtering..."
    yarn logs -applicationId "$APPLICATION_ID" | grep -A 1000 "ApplicationMaster" > "$OUTPUT_DIR/appmaster.log" 2>&1
  fi
  
  echo "AppMaster logs saved to: $OUTPUT_DIR/appmaster.log"
}

# Function to get all container logs
fetch_container_logs() {
  echo "Fetching container logs..."
  
  # Get list of all containers
  CONTAINERS=$(yarn application -status "$APPLICATION_ID" | grep "container" | awk '{print $1}')
  
  if [ -z "$CONTAINERS" ]; then
    echo "No containers found, trying alternative method..."
    # If containers aren't listed in status, try to get them from logs
    yarn logs -applicationId "$APPLICATION_ID" -show_application_log_info | grep "Container: container" | awk '{print $2}' > "$OUTPUT_DIR/container_list.txt"
    CONTAINERS=$(cat "$OUTPUT_DIR/container_list.txt")
  fi
  
  if [ -z "$CONTAINERS" ]; then
    echo "WARNING: No containers found. Getting all non-AppMaster logs..."
    yarn logs -applicationId "$APPLICATION_ID" | grep -v "ApplicationMaster" | grep -v "client" > "$OUTPUT_DIR/container.log" 2>&1
  else
    echo "Found containers: $CONTAINERS"
    echo "Fetching logs for each container..."
    
    # Create an empty container log file
    > "$OUTPUT_DIR/container.log"
    
    # For each container, get its logs and append to container.log
    for container in $CONTAINERS; do
      echo "Processing container: $container"
      echo "===================== $container =====================" >> "$OUTPUT_DIR/container.log"
      yarn logs -applicationId "$APPLICATION_ID" -containerId "$container" >> "$OUTPUT_DIR/container.log" 2>&1
      echo "" >> "$OUTPUT_DIR/container.log"
    done
  fi
  
  echo "Container logs saved to: $OUTPUT_DIR/container.log"
}

# Main execution
echo "Starting log collection for YARN application: $APPLICATION_ID"

fetch_client_logs
fetch_appmaster_logs
fetch_container_logs

echo "Log collection complete. All logs saved to: $OUTPUT_DIR"
echo "  - Client logs: $OUTPUT_DIR/client.log"
echo "  - AppMaster logs: $OUTPUT_DIR/appmaster.log"
echo "  - Container logs: $OUTPUT_DIR/container.log"
