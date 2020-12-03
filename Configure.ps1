# oh-my-posh
if ([String]::IsNullOrEmpty((Get-Module -Name oh-my-posh))) {
    Write-Host "Installing module 'oh-my-posh'"
    Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease
} else {
    Write-Host "Updating module 'oh-my-posh'"
    Update-Module oh-my-posh -Scope CurrentUser -AllowPrerelease
}

# Copy custom theme
[string] $userOhMyPoshProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath "oh-my-posh"
[string] $themeFullyQualifiedPath = Join-Path -Path $userOhMyPoshProfileFullPath -ChildPath "GillesIO.omp.json"
if (Test-Path -Path $themeFullyQualifiedPath) {
    Write-Host "Custom theme already exists - Removing"
    Remove-Item -Path $themeFullyQualifiedPath -Force
}
Write-Host "Refreshing oh-my-posh theme at" $themeFullyQualifiedPath
New-Item -ItemType Directory -Force -Path $userOhMyPoshProfileFullPath
Invoke-WebRequest -Uri https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/oh-my-posh/GillesIO.omp.json -OutFile $themeFullyQualifiedPath

# Update $PROFILE to configure the custom theme
# TODO: Automate adding to $PROFILE the following - Set-PoshPrompt "$env:USERPROFILE\oh-my-posh\GillesIO.omp.json"
