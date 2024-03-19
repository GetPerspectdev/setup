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
param(  
  [Parameter(Mandatory)]  
  [string]$new_api_key  
)  
$baseURL = 'https://api.dev.getperspect.dev/profile-api/public/tva/setup/'
$api_url = "https://loom.dev.getperspect.dev/api/v1"
$file_path = "$env:USERPROFILE\.wakatime.cfg"

if (-not (Test-Path -Path $file_path)) {
    $dirPath = Split-Path -Path $file_path -Parent

    # Check if the directory exists, and if not, create it
    if (-not (Test-Path -Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath
    }

    New-Item -ItemType File -Path $file_path | Out-Null
    Add-Content $file_path "[settings]"
    Write-Host "File created: $file_path"
}

# Check if any line contains "api_key ="
if (Get-Content $file_path | Select-String "api_key =") {
    # Update the line with the new API key
    (Get-Content $file_path) | ForEach-Object {
        $_ -replace "api_key = .*", "api_key = $new_api_key"
    } | Set-Content $file_path
    Write-Host "API key updated in $file_path"
} else {
    # Add a new line with the API key
    Add-Content $file_path "api_key = $new_api_key"
    Write-Host "API key added to $file_path"
}

if (Get-Content $file_path | Select-String "api_url =") {
    # Update the line with the new API url
    (Get-Content $file_path) | ForEach-Object {
        $_ -replace "api_url = .*", "api_url = $api_url"
    } | Set-Content $file_path
    Write-Host "API Url updated in $file_path"
} else {
    # Add a new line with the API url
    Add-Content $file_path "api_url = $api_url"
    Write-Host "API Url added to $file_path"
}

$url = $baseURL + $new_api_key
Invoke-RestMethod -Uri $url -Method Post

Write-Host "`nYou've completed the first step of setting up Perspect!`nNext, go to https://dev.getperspect.dev/sources and follow the instructions to set up the sources that you work with the most"