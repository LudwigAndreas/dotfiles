#!/bin/bash

# Variables
NAMESPACE="my-namespace"  # Default namespace, can be changed or prompted
PORT_MAPPINGS="8080:8080 5005:5005"  # Predefined port mappings

# Function to get pods and display as numbered list
choose_pod() {
    echo "Fetching pods in namespace: $NAMESPACE..."

    # Get the list of pods
    PODS=$(oc get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name")
    
    # Check if there are any pods
    if [[ -z "$PODS" ]]; then
        echo "No pods found in namespace $NAMESPACE."
        exit 1
    fi

    # Display pods with numbering
    echo "Select a pod to port-forward:"
    i=1
    declare -a POD_ARRAY
    while IFS= read -r pod; do
        echo "$i) $pod"
        POD_ARRAY+=("$pod")
        ((i++))
    done <<< "$PODS"

    # Ask user to choose a pod by number
    read -p "Enter the number of the pod: " POD_INDEX
    POD_INDEX=$((POD_INDEX - 1))

    # Validate the choice
    if [[ $POD_INDEX -ge 0 && $POD_INDEX -lt ${#POD_ARRAY[@]} ]]; then
        CHOSEN_POD=${POD_ARRAY[$POD_INDEX]}
        echo "You selected: $CHOSEN_POD"
    else
        echo "Invalid selection."
        exit 1
    fi
}

# Function to perform port-forward
port_forward() {
    echo "Starting port-forwarding on pod $CHOSEN_POD with ports $PORT_MAPPINGS..."
    oc port-forward -n "$NAMESPACE" pod/"$CHOSEN_POD" $PORT_MAPPINGS
}

# Main script execution
choose_pod
port_forward
