on run argv
	tell application "Tunnelblick" to connect (item 1 of argv)
	return
end run
