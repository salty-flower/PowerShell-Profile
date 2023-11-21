Get-ChildItem -Path ".\functions.d" -Filter "*.ps1"
| ForEach-Object {.$_ }
