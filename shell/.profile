if ! command -v source >/dev/null 2>&1; then
    source() {
        . "$@"
    }
fi
source $HOME/.shell/sh/index.sh
