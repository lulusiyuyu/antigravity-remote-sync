<#
.SYNOPSIS
Universal Sync Helper for native Windows environments.
.DESCRIPTION
Detects if rsync is available (e.g. via Git), otherwise falls back to pure Windows native OpenSSH scp.
#>

param (
    [Parameter(Mandatory=$true)][string]$HostName,
    [Parameter(Mandatory=$true)][string]$Port,
    [Parameter(Mandatory=$true)][string]$User,
    [Parameter(Mandatory=$true)][string]$Auth,
    [Parameter(Mandatory=$true)][string]$RemoteDir
)

Write-Host "🚀 Starting cross-platform sync (Windows Node) to $HostName ..."

$HasRsync = Get-Command rsync -ErrorAction SilentlyContinue

if ($HasRsync) {
    Write-Host "[Strategy] rsync utility detected in Windows PATH. Using robust incremental sync."
    # Rsync on Windows is highly dependent on SSH Keys for non-interactive behavior.
    if ($Auth -ne 'key') {
        Write-Host "⚠️ Warning: You selected Password auth. Pure Windows rsync may pause and prompt for a password."
    }
    rsync -avz --exclude='.git' -e "ssh -o StrictHostKeyChecking=no -p $Port" ./ "$User@$HostName:$RemoteDir/"

} else {
    Write-Host "[Strategy] rsync NOT found. Falling back to native Windows OpenSSH (scp)."
    Write-Host "Info: scp performs a full copy. For large directories, rsync is recommended."
    
    if ($Auth -ne 'key') {
        Write-Host "⚠️ Warning: Windows OpenSSH does NOT support inline passwords easily. You will be prompted."
    }
    scp -P $Port -o StrictHostKeyChecking=no -r ./* "$User@$HostName:$RemoteDir/"
}

Write-Host "✅ Sync Operation Complete!"
