Write-Host "PowerShell $($PSVersionTable.PSVersion)`n"
$timer = [Diagnostics.Stopwatch]::StartNew()
$PADDING_LEFT = 20
$PADDING_RIGHT = 4
$total = 0

$global:REPO_HOME = $MyInvocation.MyCommand.Path | Get-Item
| ForEach-Object { $_.Target ?? $_.FullName }
| Split-Path

$global:REPO_HOME | Join-Path -ChildPath "profile.d" | Push-Location

$hoisted = @("variables.local.ps1", "variables.ps1")
$others = Get-ChildItem -File -Filter "*.ps1" | Where-Object { $hoisted -NotContains $_.Name }
(($hoisted | Get-Item) + $others) | ForEach-Object {
  $timer.Restart()

  . $_

  $timer.Stop()
  Write-Host "  + $($_.Name.PadRight($PADDING_LEFT)) | $($timer.ElapsedMilliseconds.ToString().PadLeft($PADDING_RIGHT)) ms"
  $total += $timer.ElapsedMilliseconds
}

Pop-Location
Remove-Item -Path Variable:\timer
Write-Host "$("-" * 35)`n==> $("Total".PadRight($PADDING_LEFT)) | $($total.ToString().PadLeft($PADDING_RIGHT)) ms"
