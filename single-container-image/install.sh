#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker before running this script."
    exit 1
fi

loginResponse=$(curl -s -X POST "${TL_URL}/api/v1/authenticate" \
    -H 'accept: application/json; charset=UTF-8' \
    -H 'content-type: application/json' \
    -d '{"username": "'"$PC_IDENTITY"'", "password": "'"$PC_SECRET"'"}')

# Parse the response and extract the token using awk
token=$(echo "$loginResponse" | awk -F'"' '/token/{print $4}')

if [ -z "$token" ]; then
    echo "Failed to obtain Token"
    exit 1
fi

export TL_TOKEN="$token"

defenderScript=$(curl -sSL --header "authorization: Bearer $TL_TOKEN" -X POST "${TL_URL}/api/v1/scripts/defender.sh")
echo "$defenderScript" > defender-install.sh

chmod +x defender-install.sh
./defender-install.sh

exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo "Defender installation completed successfully."
else
    echo "Defender installation failed with exit code $exit_status."
fi

exit $exit_status

