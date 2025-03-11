#!/bin/bash
# This file is sourced by workenv before running any action
#
# You can define functions and variables here that will be available to all actions

function git_sync() {
    git fetch --all
    git pull --rebase
}

# Do not forget to export your functions to use them within shell scripts (see: https://unix.stackexchange.com/questions/727636/use-shell-script-function-directly-on-bash)
export -f git_sync

# Add your custom functions and variables below
