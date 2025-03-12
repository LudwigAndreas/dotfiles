#!/bin/bash

# state_manager.sh - Template for managing script state and configuration
# Usage: source state_manager.sh

# Configuration
STATE_DIR="${STATE_DIR:-$HOME/.local/state}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config}"
DEFAULT_CONFIG_NAME="config.cfg"
DEFAULT_STATE_NAME="state.dat"

# Ensure directories exist
create_dirs() {
  local script_name="$1"
  
  # Create script-specific directories
  mkdir -p "$STATE_DIR/$script_name"
  mkdir -p "$CONFIG_DIR/$script_name"
  
  # Return status
  return $?
}

# Initialize state management for a script
init_state_manager() {
  # Get the calling script's name without path
  SCRIPT_NAME=$(basename "${BASH_SOURCE[1]}" .sh)
  
  # Create necessary directories
  create_dirs "$SCRIPT_NAME"
  
  # Set default paths
  CONFIG_FILE="$CONFIG_DIR/$SCRIPT_NAME/$DEFAULT_CONFIG_NAME"
  STATE_FILE="$STATE_DIR/$SCRIPT_NAME/$DEFAULT_STATE_NAME"
  
  # Export variables for use in the calling script
  export SCRIPT_NAME CONFIG_FILE STATE_FILE
  
  # Load config and state if they exist
  load_config
  load_state
  
  return 0
}

# Load configuration from file
load_config() {
  if [ -f "$CONFIG_FILE" ]; then
    echo "# Loading configuration from $CONFIG_FILE"
    # Source the config file to load variables
    source "$CONFIG_FILE"
    return 0
  else
    echo "# No configuration file found at $CONFIG_FILE"
    return 1
  fi
}

# Save configuration to file
save_config() {
  local var_prefix="${1:-CONFIG_}"
  
  echo "# Saving configuration to $CONFIG_FILE"
  
  # Make sure the directory exists
  mkdir -p "$(dirname "$CONFIG_FILE")"
  
  # Create/clear the config file
  : > "$CONFIG_FILE"
  
  # Save all variables that start with the prefix
  env | grep "^$var_prefix" | while read -r line; do
    echo "$line" >> "$CONFIG_FILE"
  done
  
  return $?
}

# Add or update a config variable
set_config() {
  local key="$1"
  local value="$2"
  local prefix="${3:-CONFIG_}"
  
  # Normalize key - uppercase and ensure it has the prefix
  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  [[ "$key" != "$prefix"* ]] && key="${prefix}${key}"
  
  # Set the variable in the current environment
  export "$key=$value"
  
  # Optionally save immediately
  [ "$4" = "save" ] && save_config "$prefix"
  
  return 0
}

# Get a config variable
get_config() {
  local key="$1"
  local prefix="${2:-CONFIG_}"
  
  # Normalize key - uppercase and ensure it has the prefix
  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  [[ "$key" != "$prefix"* ]] && key="${prefix}${key}"
  
  # Get the value using eval
  eval echo "\$$key"
  
  return 0
}

# Load state from file
load_state() {
  if [ -f "$STATE_FILE" ]; then
    echo "# Loading state from $STATE_FILE"
    # Source the state file to load variables
    source "$STATE_FILE"
    return 0
  else
    echo "# No state file found at $STATE_FILE"
    return 1
  fi
}

# Save state to file
save_state() {
  local var_prefix="${1:-STATE_}"
  
  echo "# Saving state to $STATE_FILE"
  
  # Make sure the directory exists
  mkdir -p "$(dirname "$STATE_FILE")"
  
  # Create/clear the state file
  : > "$STATE_FILE"
  
  # Save all variables that start with the prefix
  env | grep "^$var_prefix" | while read -r line; do
    echo "$line" >> "$STATE_FILE"
  done
  
  return $?
}

# Add or update a state variable
set_state() {
  local key="$1"
  local value="$2"
  local prefix="${3:-STATE_}"
  
  # Normalize key - uppercase and ensure it has the prefix
  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  [[ "$key" != "$prefix"* ]] && key="${prefix}${key}"
  
  # Set the variable in the current environment
  export "$key=$value"
  
  # Optionally save immediately
  [ "$4" = "save" ] && save_state "$prefix"
  
  return 0
}

# Get a state variable
get_state() {
  local key="$1"
  local prefix="${2:-STATE_}"
  
  # Normalize key - uppercase and ensure it has the prefix
  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  [[ "$key" != "$prefix"* ]] && key="${prefix}${key}"
  
  # Get the value using eval
  eval echo "\$$key"
  
  return 0
}

# Create a lockfile to prevent concurrent execution
create_lock() {
  local lock_file="$STATE_DIR/$SCRIPT_NAME/lock"
  
  if [ -e "$lock_file" ]; then
    # Check if the process is still running
    local pid=$(cat "$lock_file")
    if kill -0 "$pid" 2>/dev/null; then
      echo "# Another instance is already running with PID $pid"
      return 1
    else
      echo "# Stale lock found, removing"
      rm -f "$lock_file"
    fi
  fi
  
  # Create lock with current PID
  echo $$ > "$lock_file"
  return 0
}

# Release the lockfile
release_lock() {
  local lock_file="$STATE_DIR/$SCRIPT_NAME/lock"
  rm -f "$lock_file"
  return $?
}

# Create a backup of state or config
backup_file() {
  local file="$1"
  local backup_dir="$(dirname "$file")/backups"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local backup_file="$backup_dir/$(basename "$file").$timestamp"
  
  # Create backup directory if it doesn't exist
  mkdir -p "$backup_dir"
  
  # Create backup
  cp "$file" "$backup_file"
  echo "# Backup created: $backup_file"
  
  # Cleanup old backups (keep last 5)
  ls -t "$backup_dir" | tail -n +6 | xargs -I {} rm "$backup_dir/{}" 2>/dev/null
  
  return 0
}

# Initialize on source
[ "$0" != "${BASH_SOURCE[0]}" ] && echo "# State manager loaded" || echo "# This script should be sourced, not executed directly"









#!/bin/bash
# // example_counter.sh - Example of using state management

# // Source the state manager
# source ./state_manager.sh

# // Initialize state management
# init_state_manager

# // Try to acquire lock (prevent multiple instances)
# if ! create_lock; then
#   echo "Error: Script is already running"
#   exit 1
# fi

# // Make sure to release lock when script exits
# trap release_lock EXIT

# // Check if this is the first run
# if [ -z "$(get_state COUNTER)" ]; then
#  echo "First run detected, initializing counter"
#  set_state COUNTER 0
#  set_state FIRST_RUN "$(date)"
# fi

# // Increment counter
# current=$(get_state COUNTER)
# new_count=$((current + 1))
# set_state COUNTER $new_count

# // Set some configuration if it doesn't exist
# if [ -z "$(get_config MAX_COUNT)" ]; then
  # set_config MAX_COUNT 10
  # save_config
# fi

# // Get max count from config
# max_count=$(get_config MAX_COUNT)

# // Display state
# echo "This script has been run $new_count times"
# echo "First run was on: $(get_state FIRST_RUN)"
# echo "Maximum allowed runs: $max_count"

# // Check if we've reached the maximum
# if [ "$new_count" -ge "$max_count" ]; then
  # echo "Maximum number of runs reached!"
  
  # // Backup state before resetting
  # backup_file "$STATE_FILE"
  
  # // Reset counter
  # set_state COUNTER 0
  # echo "Counter has been reset"
# fi

# Save state changes
# save_state

# echo "Script completed successfully"
# exit 0
