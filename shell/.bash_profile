# Include .profile for environment variables
if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# Include .bashrc for interactive shell settings
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
