$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$app = Join-Path $root 'RiftVoice.exe'
if (-not (Test-Path -LiteralPath $app -PathType Leaf)) {
 Write-Host 'BRAK RiftVoice.exe! Rozpakuj caly ZIP.' -ForegroundColor Red
 exit 1
}
$hasCable = $false
try {
 $hasCable = @(Get-PnpDevice -Class AudioEndpoint -ErrorAction Stop |
   Where-Object { $_.Status -eq 'OK' -and $_.FriendlyName -match '(?i)CABLE (Input|Output)|VB-Audio Virtual Cable' }).Count -gt 0
} catch { Write-Host 'Nie udalo sie odczytac listy audio.' -ForegroundColor Yellow }
if (-not $hasCable) {
 Write-Host 'Nie wykryto aktywnego VB-CABLE do CS2/Steam.' -ForegroundColor Yellow
 $answer = Read-Host 'Uruchomic dolaczony instalator VB-CABLE? [T/N]'
 if ($answer -match '^(?i:t|tak|y|yes)$') {
   & (Join-Path $PSScriptRoot 'Install-VirtualMic.ps1')
 } else {
   Write-Host 'Bez wirtualnego kabla CS2 nie zobaczy zmienionego glosu.'
 }
}
Start-Process -FilePath $app -WorkingDirectory $root
