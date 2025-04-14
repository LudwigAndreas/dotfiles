#!/bin/bash

output=$(top -l 1 | grep "CPU usage")
cpu_usage=$(echo "$output" | awk -F " " '{print $3}' | cut -d% -f1)

echo "CPU Usage: ${cpu_usage}%"
