$MyInvocation.MyCommand.Path | Get-Item
| ForEach-Object { $_.Target ?? $_.FullName }
| Split-Path | Join-Path -ChildPath "profile.d"
| Push-Location

Get-ChildItem -Path "." -Filter "*.ps1"
| ForEach-Object {.$_ }

Pop-Location
