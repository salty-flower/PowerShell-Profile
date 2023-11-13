$MyInvocation.MyCommand.Path | Get-Item
| ForEach-Object { $_.Target ?? $_.FullName }
| Split-Path | Join-Path -ChildPath "profile.d"
| Push-Location

. "./variables.ps1"
Get-ChildItem -Path "." -Filter "*.ps1"
| ForEach-Object {.$_ }

Pop-Location
