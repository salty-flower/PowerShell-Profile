Write-Host
$timer = [Diagnostics.Stopwatch]::StartNew()
$total = 0

$MyInvocation.MyCommand.Path | Get-Item
| ForEach-Object { $_.Target ?? $_.FullName }
| Split-Path | Join-Path -ChildPath "profile.d"
| Push-Location

. "./variables.ps1"
Get-ChildItem -Path "." -Filter "*.ps1"
| ForEach-Object {
  $timer.Restart()

  . $_

  $timer.Stop()
  Write-Host "  + $($_.Name.PadRight(20)) | $($timer.ElapsedMilliseconds)ms"
  $total += $timer.ElapsedMilliseconds
}

Pop-Location
Remove-Item -Path Variable:\timer
Write-Host ("-" * 35)
Write-Host "==> $("Total".PadRight(20)) | $($total)ms"
