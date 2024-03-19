#!/bin/bash

##########################################################################################################################
# @@@@@@@@@@@@@@@@@  @@@@@@@@@@@@ @@@@@@@@@@@@     @@@@@@@@@@   @@@@@@@@@@@@   @@@@@@@@@@@@   @@@@@@@@@@@  @@@@@@@@@@@@@ #
# @@@@@@@@@@@@@@@@@  @@@          @@@@     @@@@@ @@@@@    @@@@@ @@@@     @@@@  @@@@         @@@@@     @@@@@     @@@@     #
#              @@@@  @@@          @@@@      @@@@ @@@@      @@@  @@@@     @@@@  @@@@         @@@@@     @@@@@     @@@@     #
#   @@@@@      @@@@  @@@@@@@@@@@  @@@@@    @@@@@ @@@@@@@@@@@@   @@@@     @@@@  @@@@@@@@@@@@ @@@@@               @@@@     #
#   @@@@@@@@@@@@@@@  @@@@@@@@@@@  @@@@@@@@@@@@@    @@@@@@@@@@@@ @@@@@@@@@@@@@  @@@@@@@@@@@@ @@@@@               @@@@     #
#   @@@@@@@@@@@@@    @@@          @@@@     @@@@@  @@@      @@@@ @@@@           @@@@         @@@@@     @@@@@     @@@@     #
#   @@@@@            @@@          @@@@      @@@@ @@@@@   @@@@@@ @@@@           @@@@         @@@@@@    @@@@@     @@@@     #
#   @@@@@            @@@@@@@@@@@@ @@@@      @@@@   @@@@@@@@@@   @@@@           @@@@@@@@@@@@   @@@@@@@@@@@       @@@@     #
##########################################################################################################################

# This script is used to set up the Perspect API key and API URL in the WakaTime config file ~/.wakatime.cfg
#   WakaTime is an open source time tracking tool that integrates with your code editor to 
#   help you understand how you spend your time. Perspect makes use of Wakatime to track 
#   your time and provide insights into your work habits. This file is used to set up the
#   Perspect API key and API URL in the WakaTime config file. It also makes a POST request
#   to the Perspect API to indicate in the Perspect UI that setup has been done correctly.

# To learn more about Wakatime, visit https://wakatime.com/ and https://github.com/wakatime
setup_url="https://api.getperspect.dev/profile-api/public/tva/setup/"
api_url="https://loom.getperspect.dev/api/v1"
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

echo -e "\nYou've completed the first step of setting up Perspect!🎉\nNext, go to https://app.perspect.xyz/sources and follow the instructions to set up the sources that you work with the most"