function Start-Conda
{
  & "${SCOOP_HOME}\apps\mambaforge\current\Scripts\conda.exe" "shell.powershell" "hook" | Out-String | Where-Object { $_ } | Invoke-Expression
}

function Remove-Fast
{
  param([string]$Source)
  $fullPath = Resolve-Path $Source
  $emptyFolder = New-Item -Path . -Name "$(Get-Random).empty" -ItemType Directory
  Robocopy.exe $emptyFolder $fullPath /MIR | Out-Null
  Remove-Item $emptyFolder -Recurse -Force
  Remove-Item $fullPath -Recurse -Force
}


function Search-RgaFzf
{
  param(
    [Parameter(Mandatory = $true)]
    [string]$Query
  )

  $RG_PREFIX = "rga --files-with-matches"

  $FZFCommand = @{
    DefaultCommand = "$RG_PREFIX '$Query'"
    Query = $Query
    Command = "fzf --sort --preview=`"cmd /c IF NOT {}=='' rga --pretty --context 5 {q} {}`" --phony -q `"$Query`" --bind `"change:reload:$RG_PREFIX {q}`" --preview-window=`"70%:wrap`""
  }

  $file = Invoke-Expression ($FZFCommand["DefaultCommand"] + " | " + $FZFCommand["Command"])

  if (-not [string]::IsNullOrEmpty($file))
  {
    Write-Host "Opening $file in neovim (read-only mode)"
    & nvim -R $file
  }
}

function Format-PowerShellScript
{
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )
  Import-Module "${SCOOP_HOME}\modules\PowerShell-Beautifier"
  Edit-DTWBeautifyScript -SourcePath $Path
}

function Step-CourseDirectory
{
  param(
    [Parameter(Mandatory = $true)]
    [string]$CourseCode
  )

  $fullPath = Join-Path -Path $env:CURRENT_COURSE_HOME -ChildPath $CourseCode
  Push-Location -Path $fullPath
}

function Bump-ScoopApplications
{
  scoop update *
  scoop cleanup *
  scoop cache rm *
  Start-Job { nvim --headless -c "AstroUpdate" -c "qa" }
  Start-Job { nvim --headless -c "lua require('lazy').update()" -c "qa" }
  Get-Job | Wait-Job | Out-Null
}
