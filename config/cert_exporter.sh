#!/bin/bash

function get_openssl_output_field {
    local fieldname="$1"
    local openssl_output="$2"
    echo "$openssl_output" | grep "$fieldname" | sed "s/$fieldname=//"
}

while IFS= read -r -d '' cert_file; do
    output=$(openssl x509 -in "$cert_file" -noout -serial -dates -issuer -subject)
    if [[ $output == *"unable to load certificate"* ]]; then
        echo "local_cert_invalid{url=\"$url\",cert_file=\"$cert_file\"} 1"
    else
        url=$(get_openssl_output_field 'subject' "$output")
        issuer=$(get_openssl_output_field 'issuer' "$output")
        not_before=$(get_openssl_output_field 'notBefore' "$output")
        not_after=$(get_openssl_output_field 'notAfter' "$output")
        serial=$(get_openssl_output_field 'serial' "$output")
        remaining_days=$(( ($(date +%s --date="$not_after") - $(date +%s)) / 86400 ))

        # Output the metrics
        echo "cert_info{cert_file=\"$cert_file\",url=\"$url\",serial=\"$serial\",issuer=\"$issuer\",not_before=\"$not_before\",not_after=\"$not_after\",remaining_days=\"$remaining_days\"} 1"
    fi
done < <(find /etc/certs/ -name "*cert.pem" -print0)

exit 0

