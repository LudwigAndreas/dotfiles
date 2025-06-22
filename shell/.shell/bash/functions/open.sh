
#######################################
# `o` with no arguments opens the current directory, otherwise opens the given location
# Globals:
#   - 
# Arguments:
#   file to open or no args for current location
# Outputs:
#   -
#######################################
function o() {
    if [ $# -eq 0 ]; then
        open .;
    else
        open "$@";
    fi;
}
