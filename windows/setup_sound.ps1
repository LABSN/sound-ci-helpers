param (
  [string]$Url = 'https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack45.zip',
  [string]$ZipName = 'vbcable.zip',
  [string]$ExtractDir = 'vbcable'
)

function Download-Zip {
  param($Url, $Out)
  Write-Host "Downloading $Url → $Out"
  $wc = New-Object System.Net.WebClient
  0..2 | ForEach-Object {
    try { $wc.DownloadFile($Url, $Out); return } catch { Start-Sleep 1 }
  }
  $wc.DownloadFile($Url, $Out)
}

function Expand-Zip {
  param($Zip, $Dest)
  Write-Host "Extracting $Zip → $Dest"
  Expand-Archive -LiteralPath $Zip -DestinationPath $Dest -Force
}

function Trust-Cert {
  param($Cer)
  Write-Host "Adding certificate to TrustedPublisher: $Cer"
  certutil -addstore -f TrustedPublisher $Cer
}

function Install-Driver {
  param($InfDir)
  Write-Host "Installing driver(s) from $InfDir"
  Get-ChildItem -Path $InfDir -Filter 'vbMmeCable64_win*.inf' -Recurse |
    ForEach-Object {
      $inf = $_.FullName
      Write-Host "  devcon.exe install `"$inf`" VBAudioVACWDM"
      & "$PSScriptRoot\devcon.exe" install "$inf" VBAudioVACWDM
    }
}

function Restart-AudioServices {
  Write-Host "Restarting Audio services to pick up new device"
  foreach ($svc in 'AudioSrv','AudioEndpointBuilder') {
    if (Get-Service $svc -ErrorAction SilentlyContinue) {
      Restart-Service -Name $svc -Force
    }
  }
}

function Dump-Devices {
  Write-Host "Current sound devices:"
  Get-CimInstance Win32_SoundDevice |
    Select-Object Name,Status |
    Format-Table -AutoSize
}

Push-Location $PSScriptRoot

Download-Zip -Url $Url -Out (Join-Path $PSScriptRoot $ZipName)
Expand-Zip -Zip (Join-Path $PSScriptRoot $ZipName) -Dest (Join-Path $PSScriptRoot $ExtractDir)

$cer = Join-Path $PSScriptRoot 'vbcable.cer'
if (Test-Path $cer) {
  Write-Host "Adding certificate to TrustedPublisher: $cer"
  certutil.exe -addstore -f TrustedPublisher $cer
} else {
  Write-Error "Certificate not found at $cer; cannot trust the driver."
}
Install-Driver -InfDir (Join-Path $PSScriptRoot $ExtractDir)

Restart-AudioServices
Dump-Devices

Pop-Location
