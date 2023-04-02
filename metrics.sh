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
        subject=$(get_openssl_output_field 'subject' "$openssl_output")
        issuer=$(get_openssl_output_field 'issuer' "$openssl_output")
        not_before=$(get_openssl_output_field 'notBefore' "$openssl_output")
        not_after=$(get_openssl_output_field 'notAfter' "$openssl_output")
        serial=$(get_openssl_output_field 'serial' "$openssl_output")
        remaining_days=$(( ($not_after - $(date +%s)) / 86400 ))

    # Output the metrics
    echo "local_cert_valide{cert_file=\"$cert_file\",url=\"$url\",serial=\"$serial\",issuer=\"$issuer\",subject=\"$subject\",remaining_days=\"$remaining_days\"} 1"
    echo "local_cert_not_before{cert_file=\"$cert_file\",url=\"$url\",serial=\"$serial\"} $not_before"
    echo "local_cert_expiration_date{cert_file=\"$cert_file\",url=\"$url\",serial=\"$serial\"} $not_after"
    
done < <(find /etc/certs/ -name "*cert.pem" -print0)