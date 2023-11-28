param(  
  [Parameter(Mandatory)]  
  [string]$new_api_key  
)  
$api_url = "https://wakapi.dev.getperspect.dev/api/v1"
$URL = "https://perspect.dev/setup-tva/success"
$file_path = "$env:USERPROFILE\.wakatime\wakatime-internal.cfg"

if (-not (Test-Path $file_path)) {
    New-Item -ItemType File -Path $file_path | Out-Null
    Write-Host "File created: $file_path"
}

# Check if any line contains "api_key ="
if (Get-Content $file_path | Select-String "api_key =") {
    # Update the line with the new API key
    (Get-Content $file_path) | ForEach-Object {
        $_ -replace "api_key = .*", "api_key = $new_api_key" `
           -replace "api_url = .*", "api_url = $api_url"
    } | Set-Content $file_path
    Write-Host "API key updated in $file_path"
} else {
    # Add a new line with the API key
    Add-Content $file_path "api_key = $new_api_key"
    Add-Content $file_path "api_url = $api_url"
    Write-Host "API key added to $file_path"
}

Start-Process "explorer" -ArgumentList $URL