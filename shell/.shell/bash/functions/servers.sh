#######################################
# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
# Globals:
#   - 
# Arguments:
#   port or 8000 for default
# Outputs:
#   -
#######################################
phpserver() {
	local port="${1:-8000}";
	local ip=$(ipconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}

#######################################
# Start a python server from a directory, optionally specifying the port
# Globals:
#   - VERBOSE
# Arguments:
#   port or 8000 for default
# Outputs:
#   Writes log string into stdout if $VERBOSE is set
#######################################
pyserver() {
    local port="${1:-8000}";
    python -m http.server $port
}

