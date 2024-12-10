#!/bin/bash

print_usage() {
  echo "Usage: $0 <stow_dir> <target_dir>"
}

set -euo pipefail

SOURCE_DIR="$1"
TARGET_DIR="$2"
CONFLICTS=0

# Check if both source and target directories exist
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory '$SOURCE_DIR' does not exist."
  print_usage
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  TARGET_DIR="$HOME"
fi

# Function to check for conflicts
check_conflicts() {
  local src_file="$1"
  local relative_path="${src_file#$SOURCE_DIR/}"
  local target_file="$TARGET_DIR/$relative_path"

  if [[ -e "$target_file" && ! -L "$target_file" ]]; then
    echo "Conflict: Target file '$target_file' already exists and is not a symlink."
    CONFLICTS=$((CONFLICTS + 1))
  fi
}

# Function to create symlinks
create_symlinks() {
  local src_file="$1"
  local relative_path="${src_file#$SOURCE_DIR/}"
  local target_file="$TARGET_DIR/$relative_path"

  mkdir -p "$(dirname "$target_file")" # Create directories as needed
  ln -sf "$src_file" "$target_file"   # Create symlink
  echo "Symlinked: $src_file -> $target_file"
}

# Check for conflicts first
echo "Checking for conflicts..."
while IFS= read -r -d '' file; do
  check_conflicts "$file"
done < <(find "$SOURCE_DIR" -type f -print0)

if ((CONFLICTS > 0)); then
  echo "Conflicts detected. Resolve the conflicts and retry."
  print_usage
  exit 1
fi

# No conflicts, proceed to create symlinks
echo "No conflicts detected. Creating symlinks..."
while IFS= read -r -d '' file; do
  create_symlinks "$file"
done < <(find "$SOURCE_DIR" -type f -print0)

echo "All files have been symlinked successfully."
