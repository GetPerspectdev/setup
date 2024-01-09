param(  
  [Parameter(Mandatory)]  
  [string]$new_api_key  
)  
$baseURL = 'http://localhost:3001/profile-api/public/tva/setup/'
$api_url = "http://localhost:8080/api/v1"
$file_path = "$env:USERPROFILE\.wakatime\wakatime-internal.cfg"

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
    Write-Host "API key updated in $file_path"
} else {
    # Add a new line with the API url
    Add-Content $file_path "api_url = $api_url"
    Write-Host "API key added to $file_path"
}

$url = $baseURL + $new_api_key
Invoke-RestMethod -Uri $url -Method Post

Write-Host "Perspect is all setup! 🎉"