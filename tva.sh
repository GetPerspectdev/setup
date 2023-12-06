#!/bin/bash

setup_url="https://api.getperspect.dev/profile-api/public/tva/setup/"
api_url="https://wakapi.getperspect.dev/api/v1"
file_path="$HOME/.wakatime.cfg"
new_api_key=$1

if [ ! -e "$file_path" ]; then
    touch "$file_path"
    echo "[settings]" >> "$file_path"
    echo "File created: $file_path"
fi

# Check if any line contains "api_key ="
if grep -q "api_key =" "$file_path"; then
    # Update the line with the new API key
    sed -i -e "s,api_key = .*,api_key = $new_api_key," "$file_path"
    echo "API key updated in $file_path"
else
    # Add a new line with the API key
    echo "api_key = $new_api_key" >> "$file_path"
    echo "API key added to $file_path"
fi

# Check if any line contains "api_url ="
if grep -q "api_url =" "$file_path"; then
    # Update the line with the new API key
    sed -i -e "s,api_url = .*,api_url = $api_url," "$file_path"
    echo "API url updated in $file_path"
else
    # Add a new line with the API key
    echo "api_url = $api_url" >> "$file_path"
    echo "API url added to $file_path"
fi

curl --request POST "$setup_url$new_api_key"

echo "Perspect is all setup! 🎉"