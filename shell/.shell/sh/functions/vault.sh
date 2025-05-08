# init_project .
# adding debug dir to project to store logs, dumps, notes about it and adding
# them into gitignore
pj_init_meta() {
    local target_dir="${1:-.}"
    local debug_dir="$target_dir/debug"

    mkdir -p "$debug_dir/logs" "$debug_dir/resources" "$debug_dir/notes"

    echo "[INFO] Created debug structure in: $debug_dir"

    local gitignore_file="$target_dir/.gitignore"
    if [[ -f "$gitignore_file" ]]; then
        grep -q "^debug/" "$gitignore_file" || echo "debug/" >> "$gitignore_file"
        echo "[INFO] Added 'debug/' to .gitignore"
    fi
}


mv_meta() {
    local filepath="$1"
    if [[ ! -f "$filepath" ]]; then
        echo "[ERROR] File not found: $filepath"
        return 1
    fi

    local filename
    filename="$(basename -- "$filepath")"
    local ext="${filename##*.}"
    local dir="$(dirname -- "$filepath")"
    local date_str
    date_str="$(date +%Y_%m_%d)"

    local project
    project="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"

    echo -n "Enter short description (optional): "
    read desc

    local new_name="${date_str}_${project}"
    [[ -n "$desc" ]] && new_name+="_${desc}"
    new_name="${new_name// /-}.${ext}"

    local new_path="${dir}/${new_name}"

    mv "$filepath" "$new_path"
    echo "[INFO] Renamed to: $new_path"
}
