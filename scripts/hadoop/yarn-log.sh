#!/bin/bash

# YARN Application Log Retrieval Script

APPLICATION_ID="$1"
LOG_TYPE="${2:-all}"  # Default to all logs
FOLLOW_MODE="${3:-false}"

# Validate application ID
if [[ -z "$APPLICATION_ID" ]]; then
    echo "Usage: $0 <application_id> [log_type] [follow]"
    echo "Log Types: stdout, stderr, all"
    echo "Follow Mode: true/false"
    exit 1
}

# Construct log retrieval command
LOG_COMMAND="yarn logs -applicationId $APPLICATION_ID"

# Add log type filtering
case "$LOG_TYPE" in
    stdout)
        LOG_COMMAND+=" -log_files stdout"
        ;;
    stderr)
        LOG_COMMAND+=" -log_files stderr"
        ;;
    all)
        # No additional filtering
        ;;
    *)
        echo "Invalid log type. Use stdout, stderr, or all."
        exit 1
        ;;
esac

# Add follow mode if requested
if [[ "$FOLLOW_MODE" == "true" ]]; then
    LOG_COMMAND+=" -follow"
fi

# Execute log retrieval
echo "Retrieving logs with command: $LOG_COMMAND"
eval "$LOG_COMMAND"
