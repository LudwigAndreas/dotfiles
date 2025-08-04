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
# Create a new directory and enter it
# Arguments:
#   directory to create
#######################################
mkd() {
    mkdir -p "$@" && cd "$_";
}

#######################################
# Determine size of a file or total size of a directory
# Arguments:
#   Path to file or directory
# Outputs:
#   Writes path size into stdout and it's filename
# Usage: 
# $ fs _templates/
# 22K	_templates/
#######################################
fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
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

#######################################
# Find all files recursively in current directory matching paggern *arg*
# Arguments:
#   part of filename or filenames to find
# Outputs:
#   Writes find result to stdout
# Usage: 
#   $ fname file
#   ./filename
#   ./my-filename.sh
#   ./dir/filename.py
#######################################
fname() {
    for arg in "$@"; do
        find . -iname "*$arg*"
    done
}

#######################################
# Find in current directory by content and output with less
# Arguments:
#   stirng to find
# Outputs:
#   prints grep output into stdout using less
#######################################
s() {
    grep --color=always "$*" \
         --exclude-dir=".git" \
         --exclude-dir="node_modules" \
         --ignore-case \
         --recursive \
         . \
        | less --no-init --raw-control-chars
          #    │         └─ Display ANSI color escape sequences in raw form.
          #    └─ Don't clear the screen after quitting less.
}

#######################################
# Show last 150 lies of file and allow scrolling with less
# Arguments:
#   filename
# Outputs:
#   less output 
#######################################
logc() {
    tail -150 $1 | less
}

#######################################
# Following output file
# Arguments:
#   file to print
# Outputs:
#   prints file in follow mode using tail
#######################################
logf() {
    tail -f $1
}

#######################################
# Pretty prints json using python json.tool
# Arguments:
#  json content to pretty-print
# Outputs:
#   Writes location to stdout
# Usage: 
#   $ json '{"foo":42}'
# or 
#   $ echo '{"foo":42}' | json
#######################################
json() {
    if command -v python3 >/dev/null 2>&1; then
        _python=python3
    elif command -v python >/dev/null 2>&1; then
        _python=python
    else
        echo "Error: python3 or python not found" >&2
        return 1
    fi

    if [ -t 0 ]; then
        printf "%s\n" "$*" | ${_python} -mjson.tool
    else
        ${_python} -mjson.tool
    fi
}

#######################################
# Function to send periodic keep-alive signals
# Arguments:
#   interval (optional)
# Outputs:
#   echoing empty stirng infinitely
#######################################
afk() {
    local interval="${1:-30}"

    echo "AFK mode activated. Sending keep-alive signals every ${interval} seconds. Press Ctrl+C to stop."

    while true; do
        # Send a keep-alive signal. This could be:
        # - A simple key press simulation
        # - Sending a character to an SSH session
        # - Or simply outputting to keep a terminal session active
        echo -n " " > /dev/null

        # Wait for the specified interval
        sleep "$interval"
    done
}

#######################################
# fast scp. Sends $1 to first defined host in ~/.ssh/config:$2
# Arguments:
#   path on local
#   path on remote
# Outputs:
#   see @scp
#######################################
fscp() {
    local first_host
    first_host=$(awk '/^Host / && !/[*?]/ { print $2; exit }' ~/.ssh/config)

    if [ -z "$first_host" ]; then
        echo "No valid Host found in ~/.ssh/config"
        return 1
    fi

    scp -r "$1" "${first_host}:$2"
}
