# Function to determine the type of a file and extract CNs from it
getcertinfo() {
    if [ -z "$1" ]; then
        echo "ERROR: No file specified."
        return 1
    fi

    local file="$1"

    if [ ! -f "$file" ]; then
        echo "ERROR: File does not exist."
        return 1
    fi

    echo "Analyzing file: $file"

    # Determine file type
    local fileType
    fileType=$(file --mime-type -b "$file")

    case "$fileType" in
        application/x-pem-file|text/plain)
            echo "Detected PEM format."
            echo "Common Name(s):"
            openssl x509 -in "$file" -noout -subject | sed -n 's/^.*CN=\([^,]*\).*$/\1/p'
            echo "Subject Alternative Name(s):"
            openssl x509 -in "$file" -noout -text | grep -A 1 "Subject Alternative Name" | grep DNS | sed 's/DNS://g' | tr ',' '\n'
            ;;

        application/x-java-keystore|application/octet-stream)
            echo "Detected JKS format."
            echo "Please provide the keystore password: "
            read -s password
            keytool -list -keystore "$file" -storepass "$password" -v | grep "CN=" | sed -e "s/^.*CN=\([^,]*\).*$/\1/"
            ;;

        application/x-pkcs12)
            echo "Detected PKCS12 format (PFX/P12)."
            echo "Please provide the keystore password: "
            read -s password
            openssl pkcs12 -in "$file" -nodes -nokeys -passin pass:"$password" | openssl x509 -noout -subject | sed -n 's/^.*CN=\([^,]*\).*$/\1/p'
            ;;

        *)
            echo "ERROR: Unsupported or unrecognized file format ($fileType)."
            return 1
            ;;
    esac

    return 0
}
