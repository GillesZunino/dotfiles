# List all installed versions of oh-my-posh
$allOhMyPoshModules = Get-InstalledModule -Name oh-my-posh
$allOhMyPoshModules | Format-Table | Out-Host
$galleryLatestOhMyPosh = Find-Module -Name oh-my-posh

if ($allOhMyPoshModules.Count -gt 0) {
    [Version] $latestInstalledVersion = ( $allOhMyPoshModules | ForEach-Object { [Version]::Parse($_.Version)} | Measure-Object -Maximum ).Maximum
    [Version] $galleryOhMyPoshVersion = [Version]::Parse($galleryLatestOhMyPosh.Version);

    if ($galleryOhMyPoshVersion -gt $latestInstalledVersion) {
        Write-Host "Removing installed 'oh-my-posh'"
        Get-InstalledModule oh-my-posh -AllVersions | Where-Object {$_.Version -ne $Latest.Version} | Uninstall-Module
        $allOhMyPoshModules = @()
    } else {
        Write-Host "Module 'oh-my-posh' is up to date"
    }
}

if ($allOhMyPoshModules.Count -eq 0) {
    Write-Host "Installing module 'oh-my-posh'"
    $galleryLatestOhMyPosh | Format-Table | Out-Host
    Install-Module oh-my-posh -Scope CurrentUser
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

# Create profile if it does not exist
if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts))
{
    Write-Host "Creating profile for Current User, All Hosts at " $PROFILE.CurrentUserAllHosts
    New-Item -Type File -Path $PROFILE.CurrentUserAllHosts -Force
}

# Update $PROFILE to configure the custom theme if it is not yet enabled
[string] $ohMyPoshPromptEnableCommand = 'Set-PoshPrompt "$env:USERPROFILE\oh-my-posh\GillesIO.omp.json"'
[string] $currentUsersAllHostsProfileContent = Get-Content $PROFILE.CurrentUserAllHosts
$currentUsersAllHostsProfileContent | ForEach-Object { $hasOhMyPoshProfileCustomization = $false } { $hasOhMyPoshProfileCustomization = $hasOhMyPoshProfileCustomization -or $_.Contains($ohMyPoshPromptEnableCommand) } { $hasOhMyPoshProfileCustomization }
if ($hasOhMyPoshProfileCustomization -ne $true) {
    Write-Host "Adding 'oh-my-posh' to `$PROFILE.CurrentUserAllHosts"
    Add-Content -Path $PROFILE.CurrentUserAllHosts `r`n $ohMyPoshPromptEnableCommand `r`n
} else {
    Write-Host "`$PROFILE.CurrentUserAllHosts up to date"
}