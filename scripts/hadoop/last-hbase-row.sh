#!/bin/bash

# HBase Latest Data Retrieval Script

# Function to print usage
usage() {
    echo "Usage: $0 [namespace:table]"
    echo "Examples:"
    echo "  $0 mynamespace:mytable"
    echo "  $0 default:users"
    exit 1
}

# Check if HBase shell is available
check_hbase_availability() {
    if ! command -v hbase &> /dev/null; then
        echo "Error: HBase shell not found. Ensure HBase is installed and in PATH."
        exit 1
    fi
}

# Retrieve latest data from HBase table
get_latest_hbase_data() {
    local namespace_table="$1"
    
    # Validate input
    if [[ -z "$namespace_table" ]]; then
        usage
    fi
    
    # Split namespace and table
    IFS=':' read -r namespace table <<< "$namespace_table"
    
    # Validate namespace and table
    if [[ -z "$namespace" ]] || [[ -z "$table" ]]; then
        echo "Error: Invalid namespace:table format"
        usage
    fi
    
    # Temporary file for HBase command output
    local temp_output=$(mktemp)
    
    # HBase shell command to get latest records
    hbase shell <<EOF > "$temp_output" 2>&1
    scan '$namespace:$table', {LIMIT => 10, VERSIONS => 1, REVERSED => true}
EOF

    # Check if scan was successful
    if grep -q "ERROR" "$temp_output"; then
        echo "Error occurred while scanning HBase table:"
        cat "$temp_output"
        rm "$temp_output"
        exit 1
    fi

    # Process and display results
    echo "Latest records for $namespace_table:"
    grep -E "^COLUMN" "$temp_output" | sed 's/^/  /'
    
    # Clean up
    rm "$temp_output"
}

# Main execution
main() {
    # Check HBase availability
    check_hbase_availability
    
    # Get latest data
    get_latest_hbase_data "$1"
}

# Run main with first argument
main "$1"
