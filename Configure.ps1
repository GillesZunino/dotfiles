# oh-my-posh
$allOhMyPoshModules = Get-Module -All -ListAvailable -Name oh-my-posh
if ($allOhMyPoshModules.Count -gt 0) {
    Write-Host "Removing oh-my-posh modules"
    Get-InstalledModule oh-my-posh -AllVersions | Where-Object {$_.Version -ne $Latest.Version} | Uninstall-Module
}
Write-Host "Installing module 'oh-my-posh'"
Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease

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

# Create profile if it does not exist
if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts))
{
    Write-Host "Creating profile for Current User, All Hosts at " $PROFILE.CurrentUserAllHosts
    New-Item -Type File -Path $PROFILE.CurrentUserAllHosts -Force
}

# Update $PROFILE to configure the custom theme
# TODO: Automate adding to $PROFILE the following - Set-PoshPrompt "$env:USERPROFILE\oh-my-posh\GillesIO.omp.json"
