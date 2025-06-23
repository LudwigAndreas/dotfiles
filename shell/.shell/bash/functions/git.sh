
#######################################
# Open current repo in browser
# Arguments:
#   - Path to repo (optional)
# Outputs:
#   - opens current repository url
#######################################
repo() {
    # Validate we are inside a git repo
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not a git repo!"
        return 1
    fi

    remote="$(git remote get-url origin)"
    branch="$(git rev-parse --abbrev-ref HEAD)"
    full_path="$(pwd)"
    git_root="$(git rev-parse --show-toplevel)"
    rel_path="${full_path#$git_root}"
    rel_path="$(echo "$rel_path" | sed 's#^/##')"  # remove leading /

    # Optional manual override
    hosting="$(git config --get remote.origin.git-hosting-type)"

    # Parse remote URL
    proto=""
    host=""
    path=""
    if echo "$remote" | grep -q '^ssh://'; then
        # SSH URL form: ssh://git@host:port/project/repo.git
        clean_url="${remote#ssh://}"
        clean_url="${clean_url#git@}"
        host_port="${clean_url%%/*}"      # host:port
        path="/${clean_url#*/}"           # /project/repo.git
        host="${host_port%%:*}"           # host only
    elif echo "$remote" | grep -q '^[^:]*://'; then
        # URL form: protocol://host[:port]/path
        proto="$(echo "$remote" | sed -E 's#^([^:]+)://.*#\1#')"
        host="$(echo "$remote" | sed -E 's#^[^:]+://([^/:]+).*#\1#')"
        path="/$(echo "$remote" | sed -E 's#^[^:]+://[^/]+/?##')"
    else
        # SCP form: git@host:path
        proto="ssh"
        host="$(echo "$remote" | sed -E 's#.+@([^:/]+).*#\1#')"
        path="/$(echo "$remote" | sed -E 's#.+:[/]*##')"
    fi

    path="$(echo "$path" | sed 's#\.git$##')" # strip .git
    base_url="https://$host"

    # Detect default host type
    if [ -z "$hosting" ]; then
        if echo "$host" | grep -qi 'github'; then
            hosting="github"
        elif echo "$host" | grep -qi 'gitlab'; then
            hosting="gitlab"
        elif echo "$host" | grep -qi 'bitbucket'; then
            hosting="bitbucket-server"
        else
            hosting="unknown"
        fi
    fi

    # URL-encode rel_path
    rel_url_path=""
    if [ -n "$rel_path" ]; then
        rel_url_path="$(printf "%s" "$rel_path" | sed -E 's/([^a-zA-Z0-9._~-])/\1/g' | xargs -0 printf "%s")"
    fi

    url=""
    if [ "$hosting" = "github" ] || [ "$hosting" = "gitlab" ]; then
        url="${base_url}${path}/tree/${branch}"
        if [ -n "$rel_url_path" ]; then
            url="${url}/${rel_url_path}"
        fi
    elif [ "$hosting" = "bitbucket-server" ]; then
        # Extract projectKey + repo
        project="$(echo "$path" | cut -d/ -f2 | tr '[:tolower:]' '[:toupper:]')"
        repo="$(echo "$path" | cut -d/ -f3)"
        url="${base_url}/projects/${project}/repos/${repo}/browse"
        if [ -n "$rel_url_path" ]; then
            url="${url}/${rel_url_path}"
        fi
        encoded_branch="$(urlencode "refs/heads/${branch}")"
        url="${url}?at=${encoded_branch}"
    else
        echo "Unknown or unsupported hosting type."
        echo "Set manually via: git config remote.origin.git-hosting-type github|gitlab|bitbucket-server"
        echo "Remote URL: $remote"
        return 1
    fi

    echo "Opening: $url"
    command -v open >/dev/null && open "$url" && return 0
    command -v xdg-open >/dev/null && xdg-open "$url" && return 0

    echo "Please open manually: $url"
    return 0
}

# URL-encode branch name for query param
urlencode() {
    # POSIX-safe URL encode
    # Usage: urlencode "string"
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    s="$1"
    out=""
    while [ -n "$s" ]; do
        c=${s%${s#?}}
        case "$c" in
            [a-zA-Z0-9.~_-]) out="${out}${c}" ;;
            *) out="${out}$(printf '%%%02X' "'$c")" ;;
        esac
        s=${s#?}
    done
    LC_COLLATE=$old_lc_collate
    printf "%s" "$out"
}

