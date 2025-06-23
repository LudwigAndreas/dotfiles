cr="$(tput setaf 1)"
cg="$(tput setaf 2)"
cb="$(tput setaf 4)"
cw="$(tput sgr0)"
c0="$(tput init)"

#######################################
# Common logging function.
# Globals:
#   -
# Arguments:
#   String to log
# Outputs:
#   Writes log string into stdout
#######################################
logi() {
    printf "%s[*] $1%s\n" "${cw}" "${c0}"
}

#######################################
# Common error logging function.
# Globals:
#   -
# Arguments:
#   Error string to log
# Outputs:
#   Writes error log string into stdout
#######################################
loge() {
    printf "%s[-] $1%s\n" "${cr}" "${c0}"
}

#######################################
# Common success logging function.
# Globals:
#   -
# Arguments:
#   String to log colored green
# Outputs:
#   Writes log string into stdout
#######################################
logs() {
    printf "%s[+] $1%s\n" "${cg}" "${c0}"
}

#######################################
# Common debug logging function.
# Globals:
#   - VERBOSE
# Arguments:
#   String to log
# Outputs:
#   Writes log string into stdout if $VERBOSE is set
#######################################
logd() {
    [ -n "$VERBOSE" ] && printf "[*] %s$1%s\n" "${cw}" "${c0}"
}

log() {
  logi $1
}

#######################################
# Template asking [y]es or [n]o (with case insensetive input)
# Globals:
#   - VERBOSE
# Arguments:
#   String to log
# Outputs:
#   Writes log string into stdout if $VERBOSE is set
#######################################
ask_yes_no() {
    local message=$1
    [ -n "$message" ] && log $message && sleep 1
    logi "DO YOU WANT TO PROCEED [Y/N] : "
    while true; do
        read -r install
        # Optional reassignment (only if needed case insensetive parsing)
        install=$(echo "$install" | tr 'a-z' 'A-Z')
        case $install in
            Y|YES)
                return 0
            ;;
            N|NO)
                return 1
            ;;
            *)
                loge "Invalid input. Please answer with 'Y[es]' or 'N[o]' [Y/N] : "
                continue
            ;;
        esac
    done
}

# Tempate printing usage
usage() {
    printf %s "${cw}"
    echo "Usage:	$0 [Options]"
    echo
    echo "Options:"
    echo "  -h, --help		Show this help message and exit"
    echo "  -a, --action	Required argument"
    echo "  -f, --file		Optional argument"
    echo "  -v, --verbose	Enable verbose mode"
    printf %s "${cw}"
    exit 0
}

# Template args parser
# help - default help
# verbose - flag argument (only present or not)
# argument - parameterized argument (need to specify action after it)
# file - parameterized argument (need to specify file after it)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -a|--action)
      action="$2"
      shift 2
      ;;
    -f|--file)
      file="$2"
      shift 2
      ;;
    *)
      loge "Error: Unknown option $1"
      usage
      ;;
  esac
done


# Check required arguments
if [ -z "$action" ]; then
  loge "Error: action is required"
  usage
fi
echo "Action: $action"

# Script
if [ -n "$file" ]; then
  echo "File: $file"
fi

if [ "$VERBOSE" == true ]; then
  echo "Verbose mode enabled"
fi

# Example of usage ask_yes_no
ask_yes_no
if [ $? == 1 ]; then
    loge "Aborting!"
else
    logd "Doing something" 
    sleep 2
    logs "Successfully finished"
fi

exit 0
