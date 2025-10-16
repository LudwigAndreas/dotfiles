#######################################
# Recursively delete files that match a certain pattern
# (by default delete all `.DS_Store` files)
# # Globals:
#   - 
# Arguments:
#   -
# Outputs:
#   -
#######################################
cleanup() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}


function urlencode() {
  python -c 'import urllib, sys; print urllib.quote(sys.argv[1], sys.argv[2])' \
    "$1" "$urlencode_safe"
}



#######################################
# Create a data URL from a file
# # Globals:
#   - 
# Arguments:
#   path to file
# Outputs:
#   Writes data URL string into stdout
#######################################
dataurl() {
    local mimeType=$(file -b --mime-type "$1");
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8";
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

#######################################
# Compare original and gzipped file size
# Globals:
#   - 
# Arguments:
#   Path to file
# Outputs:
#   Writes comparison result into stdout
#######################################
gz() {
    local origsize=$(wc -c < "$1");
    local gzipsize=$(gzip -c "$1" | wc -c);
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

#######################################
# Run `dig` and display the most useful info
# Globals:
#   - 
# Arguments:
#   TODO: write description
# Outputs:
#   displays dig ouptput
#######################################
digga() {
    dig +nocmd "$1" any +multiline +noall +answer;
}

#######################################
# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
# Globals:
#   - 
# Arguments:
#   path to file or directory to archive
# Outputs:
#   Creates archive in current directory
#######################################
targz() {
    local tmpFile="${@%/}.tar";
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

    size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
    );

    local cmd="";
    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli";
    else
        if hash pigz 2> /dev/null; then
            cmd="pigz";
        else
            cmd="gzip";
        fi;
    fi;

    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
    "${cmd}" -v "${tmpFile}" || return 1;
    [ -f "${tmpFile}" ] && rm "${tmpFile}";

    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
    );

    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}


yub() {
  open "http://yubnub.org/parser/parse?command=$*"
}
