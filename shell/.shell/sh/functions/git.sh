#######################################
# Use Git’s colored diff when available
# Arguments:
#   git diff input
# Outputs:
#   Colored diff
#######################################
hash git 2>/dev/null;
if [ $? -eq 0 ]; then
    diff() {
        git diff --no-index --color-words "$@";
    }
fi

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

