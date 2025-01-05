#!/bin/bash


# Fetch system information
OS=$(sw_vers -productName)  # macOS product name
OS_VERSION=$(sw_vers -productVersion)  # macOS version
KERNEL=$(uname -r)
SHELL=$(basename "$SHELL")
UPTIME=$(uptime | awk -F'( |,)' '{print $4, $5}')  # Get the uptime
CPU=$(sysctl -n machdep.cpu.brand_string)  # CPU information
MEMORY=$(vm_stat | awk '/free/ {free=$3} /active/ {active=$3} /inactive/ {inactive=$3} /wired/ {wired=$3} END {printf "%.2f GB / %.2f GB\n", (active+inactive+wired)/256, (free+active+inactive+wired)/256}')  # Memory usage

# Display the information
echo "================================"
echo -e "OS:        $OS $OS_VERSION"
echo -e "Kernel:    $KERNEL"
echo -e "Shell:     $SHELL"
echo -e "Uptime:    $UPTIME"
echo -e "CPU:       $CPU"
echo -e "Memory:    $MEMORY"
echo "================================"
