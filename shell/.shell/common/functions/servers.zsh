
# TODO: rewrite with python3 function
# Start an HTTP server from a directory, optionally specifying the port
# function server() {
# 	local port="${1:-8000}";
# 	sleep 1 && open "http://localhost:${port}/" &
# 	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
# 	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
# 	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
# }

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}";
	local ip=$(ipconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}
