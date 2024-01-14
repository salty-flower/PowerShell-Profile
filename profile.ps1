Write-Host "PowerShell $($PSVersionTable.PSVersion)`n"
$timer = [Diagnostics.Stopwatch]::StartNew()
$PADDING_LEFT = 20
$PADDING_RIGHT = 4
$total = 0

$global:REPO_HOME = $MyInvocation.MyCommand.Path | Get-Item
| ForEach-Object { $_.Target ?? $_.FullName }
| Split-Path

$global:REPO_HOME | Join-Path -ChildPath "profile.d" | Push-Location

. "./variables.ps1"
Get-ChildItem -Path "." -Filter "*.ps1"
| ForEach-Object {
  $timer.Restart()

  . $_

  $timer.Stop()
  Write-Host "  + $($_.Name.PadRight($PADDING_LEFT)) | $($timer.ElapsedMilliseconds.ToString().PadLeft($PADDING_RIGHT)) ms"
  $total += $timer.ElapsedMilliseconds
}

Pop-Location
Remove-Item -Path Variable:\timer
Write-Host "$("-" * 35)`n==> $("Total".PadRight($PADDING_LEFT)) | $($total.ToString().PadLeft($PADDING_RIGHT)) ms"
