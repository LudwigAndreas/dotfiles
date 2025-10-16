#######################################
# Function to go to projects or into a specific one 
# Globals:
#   - 
# Arguments:
#   
# Outputs:
#   -
#######################################


p() {
    local projects_dir="$HOME/vault/projects"
    if [ ! -d "$projects_dir" ]; then
        echo "Directory $projects_dir does not exist."
        return 1
    fi

    # If no argument — go to the main directory
    if [ $# -eq 0 ]; then
        cd "$projects_dir" || return
        return
    fi

    # If argument provided — go into that subdirectory
    local target="$projects_dir/$1"
    if [ -d "$target" ]; then
        cd "$target" || return
    else
        echo "Project '$1' not found in $projects_dir."
        return 1
    fi
}

