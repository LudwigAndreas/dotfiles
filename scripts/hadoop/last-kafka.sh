#!/bin/bash

# Kafka Last Message Download Script

# Configuration Variables
KAFKA_BROKER="localhost:9092"
KAFKA_CONSUMER_GROUP="last-message-consumer-group"

# Function to print usage
usage() {
    echo "Usage: $0 <topic_name> [output_file]"
    echo "Examples:"
    echo "  $0 my-topic"
    echo "  $0 my-topic /path/to/output.txt"
    exit 1
}

# Check Kafka tools availability
check_kafka_availability() {
    if ! command -v kafka-console-consumer.sh &> /dev/null; then
        echo "Error: Kafka tools not found. Ensure Kafka is installed and in PATH."
        exit 1
    fi
}

# Download last message from Kafka topic
get_last_kafka_message() {
    local topic="$1"
    local output_file="${2:-last_kafka_message.txt}"
    
    # Validate input
    if [[ -z "$topic" ]]; then
        usage
    fi
    
    # Ensure output directory exists
    mkdir -p "$(dirname "$output_file")"
    
    # Get the last message using Kafka console consumer
    echo "Retrieving last message from topic: $topic"
    
    # Use kafka-console-consumer to get the last message
    kafka-console-consumer.sh \
        --bootstrap-server "$KAFKA_BROKER" \
        --topic "$topic" \
        --group "$KAFKA_CONSUMER_GROUP" \
        --max-messages 1 \
        --from-beginning \
        --timeout-ms 10000 > "$output_file" 2>/dev/null
    
    # Check if message was retrieved
    if [[ ! -s "$output_file" ]]; then
        echo "No messages found in topic: $topic"
        rm "$output_file"
        exit 1
    fi
    
    echo "Last message downloaded to: $output_file"
    
    # Display message contents
    echo -e "\nMessage Contents:"
    cat "$output_file"
}

# Advanced message parsing (optional)
parse_message() {
    local input_file="$1"
    
    # Check if jq is available for JSON parsing
    if command -v jq &> /dev/null; then
        echo -e "\nParsed JSON Message:"
        jq '.' "$input_file" 2>/dev/null
    fi
}

# Main execution
main() {
    # Check Kafka tools availability
    check_kafka_availability
    
    # Get last message
    local topic="$1"
    local output_file="$2"
    
    get_last_kafka_message "$topic" "$output_file"
    
    # Optional JSON parsing
    parse_message "$output_file"
}

# Run main with arguments
main "$1" "$2"
