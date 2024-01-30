using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Get-ChildItem -Path ".\completions.d" -Filter "*.ps1" | ForEach-Object { . $_ }
