#!/usr/bin/env bash
#
# stow-lite.sh: a simple bash reimplementation of GNU stow's core features
#
# Supported flags:
#   -R : restow (uninstall then install)
#   -D : delete/uninstall
#   -v : verbose
#   -t targetdir : set target directory
#
# Example:
#   ./stow-lite.sh -v -t "$HOME" bash
#   ./stow-lite.sh -D -v bash

set -euo pipefail

main() {
  local restow=0
  local delete=0
  local verbose=0
  local target=".."

  while getopts ":RDvt:" opt; do
    case "${opt}" in
      R) restow=1 ;;
      D) delete=1 ;;
      v) verbose=1 ;;
      t) target="${OPTARG}" ;;
      *) echo "Unknown option: -${OPTARG}" >&2; exit 1 ;;
    esac
  done

  shift $((OPTIND - 1))

  if [[ $# -eq 0 ]]; then
    echo "No package specified." >&2
    exit 1
  fi

  local packages=("$@")

  for pkg in "${packages[@]}"; do
    local src_dir="$pkg"
    if [[ ! -d "$src_dir" ]]; then
      echo "Package '$pkg' does not exist." >&2
      continue
    fi

    if [[ "$delete" -eq 1 ]]; then
      uninstall_package "$src_dir" "$target" "$verbose"
    elif [[ "$restow" -eq 1 ]]; then
      uninstall_package "$src_dir" "$target" "$verbose"
      install_package "$src_dir" "$target" "$verbose"
    else
      install_package "$src_dir" "$target" "$verbose"
    fi
  done
}

install_package() {
  local src_dir="$1"
  local target_dir="$2"
  local verbose="$3"

  find "$src_dir" -type f | while read -r file; do
    local relpath="${file#$src_dir/}"
    local link_target="$target_dir/$relpath"
    local link_dir
    link_dir=$(dirname "$link_target")

    if [[ ! -d "$link_dir" ]]; then
      mkdir -p "$link_dir"
      [[ "$verbose" -eq 1 ]] && echo "Created directory $link_dir"
    fi

    if [[ -e "$link_target" ]]; then
      echo "Warning: $link_target already exists, skipping." >&2
      continue
    fi

    ln -s "$(realpath "$file")" "$link_target"
    [[ "$verbose" -eq 1 ]] && echo "Linked $file -> $link_target"
  done
}

uninstall_package() {
  local src_dir="$1"
  local target_dir="$2"
  local verbose="$3"

  find "$src_dir" -type f | while read -r file; do
    local relpath="${file#$src_dir/}"
    local link_target="$target_dir/$relpath"
    if [[ -L "$link_target" ]]; then
      rm "$link_target"
      [[ "$verbose" -eq 1 ]] && echo "Removed $link_target"
    fi
  done
}

main "$@"

