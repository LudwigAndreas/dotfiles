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

    # Read git remote URL
    remote="$(git remote get-url origin)"

    # Optional manual override
    hosting="$(git config --get remote.origin.git-hosting-type)"

    # Parse URL
    proto=""
    host=""
    port=""
    path=""
    if echo "$remote" | grep -q '^[^:]*://'; then
        # URL form: protocol://host[:port]/path
        proto="$(echo "$remote" | sed -E 's#^([^:]+)://.*#\1#')"
        host="$(echo "$remote" | sed -E 's#^[^:]+://([^/:]+).*#\1#')"
        port="$(echo "$remote" | sed -nE 's#^[^:]+://[^/:]+:([0-9]+).*#\1#p')"
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

    branch="$(git rev-parse --abbrev-ref HEAD)"

    url=""
    if [ "$hosting" = "github" ] || [ "$hosting" = "gitlab" ]; then
        url="${base_url}${path}/tree/${branch}"
    elif [ "$hosting" = "bitbucket-server" ]; then
        # Extract projectKey + repo
        if echo "$path" | grep -qE '^/[^/]+/[^/]+$'; then
            project="$(echo "$path" | cut -d/ -f2)"
            repo="$(echo "$path" | cut -d/ -f3)"
            url="${base_url}/projects/${project}/repos/${repo}/browse?at=refs/heads/${branch}"
        else
            echo "Cannot parse Bitbucket Server path: $path"
            return 1
        fi
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

