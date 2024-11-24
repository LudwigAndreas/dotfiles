#!/bin/bash

# Time interval between keep-alive signals (in seconds)
INTERVAL=300  # 5 minutes

# Infinite loop to prevent session timeout
while true
do
    # Send a harmless keep-alive signal (you can also use another command if needed)
    echo "Preventing session timeout..."
    
    # Wait for the specified interval
    sleep $INTERVAL
done
