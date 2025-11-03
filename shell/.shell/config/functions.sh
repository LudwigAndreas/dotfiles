#######################################
# Reloads current shell
# Arguments:
#   None
#######################################
reload() {
    shell="$(ps -p $$ -o args= | awk '{print $1}')"
    exec ${shell} -l
}


#######################################
# Smart cd to go to previous directory
# Globals:
#   - VERBOSE
# Arguments:
#   String to log
# Outputs:
#   Writes log string into stdout if $VERBOSE is set
# Usage: 
# $ up 3
# go for 3 folders up
#######################################
up() {
    local counter=${1:-1}
    local dirup="../"
    local out=""
    while (( counter > 0 )); do
        let counter--
        out="${out}$dirup"
    done

    cd $out
}

