#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No URLs provided."
    exit 1
fi
for url in "$@"; do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" $url)
    echo "URL: $url - Status Code: $status_code" >> http_status.log
done
echo "HTTP status check completed. Results logged to http_status.log"


# Ensure the script has execute permissions: chmod +x check_http_status.sh
# ./check_http_status.sh https://example.com https://google.com https://facebook.com https://54.224.66.194
