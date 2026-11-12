$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$originalZip = Join-Path $root 'third_party\VBCABLE_Driver_Pack46.zip'
Write-Host 'RIFTVOICE - VIRTUAL MIC: VB-CABLE by VB-Audio' -ForegroundColor Cyan
Write-Host 'www.vb-cable.com - DONATIONWARE; donations are welcome.'
Write-Host 'Professional use requires appropriate VB-Audio licensing.'
Write-Host 'Vendor driver setup requires administrator/UAC consent.'
Write-Host 'A reboot MAY be required; this script NEVER reboots Windows.'
if (-not (Test-Path -LiteralPath $originalZip -PathType Leaf)) {
 Write-Host 'BLAD: brak oryginalnego VB-CABLE ZIP w paczce.' -ForegroundColor Red
 exit 2
}
$answer = Read-Host 'Uruchomic oficjalny instalator sterownika? [T/N]'
if ($answer -notmatch '^(?i:t|tak|y|yes)$') { Write-Host 'Anulowano.'; return }
$target = Join-Path $env:TEMP ('RiftVoice-VBCable-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $target -Force | Out-Null
try {
 Expand-Archive -LiteralPath $originalZip -DestinationPath $target -Force
 $setup = Get-ChildItem -Path $target -File -Recurse -ErrorAction Stop |
     Where-Object { $_.Name -ieq 'VBCABLE_Setup_x64.exe' } | Select-Object -First 1
 if (-not $setup) { throw 'Brak VBCABLE_Setup_x64.exe w archiwum.' }
 $sig = Get-AuthenticodeSignature -LiteralPath $setup.FullName
 Write-Host ('Digital signature: ' + $sig.Status)
 if ($sig.Status -eq 'HashMismatch' -or $sig.Status -eq 'NotTrusted') { throw 'Nieprawidlowy podpis instalatora.' }
 $proc = Start-Process -FilePath $setup.FullName -WorkingDirectory $setup.DirectoryName -Verb RunAs -PassThru -Wait
 Write-Host ('Instalator zakonczony, kod: ' + $proc.ExitCode)
 Write-Host 'Jesli system tego wymaga, uruchom Windows ponownie.' -ForegroundColor Yellow
 Write-Host 'W CS2 ustaw mikrofon: CABLE Output.'
} catch {
 Write-Host ('BLAD: ' + $_.Exception.Message) -ForegroundColor Red
 exit 3
} finally {
 Remove-Item -LiteralPath $target -Recurse -Force -ErrorAction SilentlyContinue
}
