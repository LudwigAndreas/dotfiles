
# Create a new directory and enter it
mkd() {
	mkdir -p "$@" && cd "$_";
}

# Determine size of a file or total size of a directory
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

# Run `up 3` for 3 folders up
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

fname() {
	find . -iname "*$@"
}

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

logc() {
	tail -150 $1 | more
}

logf() {
	tail -f $1
}

# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
    if [ -t 0 ]; then
        printf "%s\n" "$*" | python -mjson.tool
    else
        python -mjson.tool
    fi
}

# Function to send periodic keep-alive signals
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

