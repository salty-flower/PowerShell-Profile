Write-Host "PowerShell $($PSVersionTable.PSVersion)`n"
$timer = [Diagnostics.Stopwatch]::StartNew()
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
  Write-Host "  + $($_.Name.PadRight(20)) | $($timer.ElapsedMilliseconds.ToString().PadLeft(3)) ms"
  $total += $timer.ElapsedMilliseconds
}

Pop-Location
Remove-Item -Path Variable:\timer
Write-Host "$("-" * 35)`n==> $("Total".PadRight(20)) | $($total) ms"
