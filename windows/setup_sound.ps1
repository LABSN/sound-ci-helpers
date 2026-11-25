# Someday if this breaks we can use:
# https://github.com/duncanthrax/scream/tree/master/Install
# But it signs using a SHA that is buggy with Windows 7 so don't use for now
# https://support.microsoft.com/en-us/help/2921916/the-untrusted-publisher-dialog-box-appears-when-you-install-a-driver-i
function DownloadVirtualSoundcard () {
    $webclient = New-Object System.Net.WebClient
    $url = "https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack46.zip"
    $filepath = $pwd.Path + "\vbcable.zip"
    Write-Host "Downloading" $url
    $retry_attempts = 2
    for($i=0; $i -lt $retry_attempts; $i++){
        try {
            $webclient.DownloadFile($url, $filepath)
            break
        }
        Catch [Exception]{
            Start-Sleep 1
        }
    }
    if (Test-Path $filepath) {
        Write-Host "File saved at" $filepath
    } else {
        # Retry once to get the error message if any at the last try
        $webclient.DownloadFile($url, $filepath)
    }
}

function InstallDriver ($inf) {
    Write-Host "Installing" $inf
    .\devcon.exe install $inf VBAudioVACWDM | Out-Host
    $devices = @(Get-PnpDevice -Class MEDIA -ErrorAction SilentlyContinue | Where-Object { $_.HardwareID -contains "VBAudioVACWDM" })
    $devices | Format-Table -AutoSize Status, FriendlyName, InstanceId | Out-String | Write-Host
    return ($devices.Count -gt 0) -and -not ($devices | Where-Object { $_.Status -ne "OK" })
}

function main () {
    Push-Location $PSScriptRoot
    DownloadVirtualSoundcard
    Expand-Archive -LiteralPath vbcable.zip -DestinationPath vbcable -Force
    # The win10 driver is attestation-signed, which Windows Server may refuse to load
    if (-not (InstallDriver vbcable\vbMmeCable64_win10.inf)) {
        Write-Host "win10 driver failed, falling back to win7 driver"
        .\devcon.exe remove VBAudioVACWDM | Out-Host
        certutil -addstore "TrustedPublisher" vbcable.cer
        if (-not (InstallDriver vbcable\vbMmeCable64_win7.inf)) {
            Write-Warning "VB-CABLE device does not report OK status"
        }
    }
    # Restart so the new endpoints show up without waiting for the audio service to notice them
    foreach ($svc in 'AudioEndpointBuilder', 'AudioSrv') {
        try {
            Restart-Service -Name $svc -Force -ErrorAction Stop
        } catch {
            Write-Warning "Could not restart ${svc}: $_"
        }
    }
    Pop-location
}

main
