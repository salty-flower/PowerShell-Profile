$dotfile_mappings = @{
  "lazygit-config.yml" ="$env:LOCALAPPDATA\lazygit\config.yml"
}

foreach ($key in $dotfile_mappings.Keys)
{
  $source = "$global:REPO_HOME\dotfiles.d\$key"
  $destination = $dotfile_mappings[$key]
  $destination_dir = Split-Path $destination

  Write-Host "Linking $source to $destination..."
  New-Item -ItemType Directory -Path $destination_dir -ErrorAction SilentlyContinue
  if (Test-Path $destination)
  {
    New-Item -ItemType SymbolicLink -Path $destination -Value $source
  } else
  {
    Write-Host "Destination already exists."
    $response = Read-Host -Prompt "Overwrite? (o)"
    if ($response -eq "o")
    {
      Remove-Item $destination
    } else
    {
      continue
    }
  }
  New-Item -ItemType SymbolicLink -Path $destination -Value $source
}
