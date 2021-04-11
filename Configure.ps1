function InstallOrRefresh-Module([string] $moduleName) {
    # List all installed versions of the given module
    $allInstalledModules = Get-InstalledModule -Name $moduleName -ErrorAction Ignore
    $allInstalledModules | Format-Table | Out-Host
    $galleryLatestModule = Find-Module -Name $moduleName

    if ($allInstalledModules.Count -gt 0) {
        [Version] $latestInstalledVersion = ( $allInstalledModules | ForEach-Object { [Version]::Parse($_.Version)} | Measure-Object -Maximum ).Maximum
        [Version] $galleryModuleVersion = [Version]::Parse($galleryLatestModule.Version);

        if ($galleryModuleVersion -gt $latestInstalledVersion) {
            Write-Host "Removing installed '$moduleName'"
            Get-InstalledModule $moduleName -AllVersions | Where-Object { $_.Version -ne $Latest.Version } | Uninstall-Module
            $allInstalledModules = @()
        } else {
            Write-Host "Module '$moduleName' is up to date"
        }
    }

    if ($allInstalledModules.Count -eq 0) {
        Write-Host "Installing module '$moduleName'"
        $galleryLatestModule | Format-Table | Out-Host

        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module $moduleName -Scope CurrentUser
    }
}


function InstallOrRefresh-OhMyPoshTheme([string] $themeFileName, [string] $themeUrl) {
    [string] $userOhMyPoshProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath "oh-my-posh"
    [string] $themeFullyQualifiedPath = Join-Path -Path $userOhMyPoshProfileFullPath -ChildPath $themeFileName
    if (Test-Path -Path $themeFullyQualifiedPath) {
        Write-Host "Custom theme already exists - Removing"
        Remove-Item -Path $themeFullyQualifiedPath -Force
    }
    Write-Host "Refreshing 'oh-my-posh' theme at '$themeFullyQualifiedPath'"
    New-Item -ItemType Directory -Force -Path $userOhMyPoshProfileFullPath
    Invoke-WebRequest -Uri $themeUrl -OutFile $themeFullyQualifiedPath
}


function Ensure-OhMyPoshProfileEntry([string] $themeFileName) {
    if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts))
    {
        Write-Host "Creating profile for Current User, All Hosts at `$PROFILE.CurrentUserAllHosts ($PROFILE.CurrentUserAllHosts)"
        New-Item -Type File -Path $PROFILE.CurrentUserAllHosts -Force
    }

    # Update $PROFILE to configure the custom theme if it is not yet enabled
    [string] $ohMyPoshPromptEnableCommand = 'Set-PoshPrompt "$env:USERPROFILE\oh-my-posh\' + $themeFileName + '"'
    [string] $currentUsersAllHostsProfileContent = Get-Content $PROFILE.CurrentUserAllHosts
    [bool] $hasOhMyPoshProfileCustomization = $false
    if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
        $currentUsersAllHostsProfileContent | ForEach-Object { $hasOhMyPoshProfileCustomization = $false } { $hasOhMyPoshProfileCustomization = $hasOhMyPoshProfileCustomization -or $_.Contains($ohMyPoshPromptEnableCommand) } { $hasOhMyPoshProfileCustomization }
    }

    if ($hasOhMyPoshProfileCustomization -ne $true) {
        Write-Host "Adding 'oh-my-posh' to `$PROFILE.CurrentUserAllHosts"
        if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
            Add-Content -Path $PROFILE.CurrentUserAllHosts `n
        }
        Add-Content -Path $PROFILE.CurrentUserAllHosts "# Start oh-my-posh"
        Add-Content -Path $PROFILE.CurrentUserAllHosts $ohMyPoshPromptEnableCommand
    } else {
        Write-Host "`$PROFILE.CurrentUserAllHosts up to date"
    }
}


function Install-OhMyPosh() {
    [string] $ohMyPoshThemeFileName = "GillesIO.omp.json"

    # Install oh-my-posh 3
    InstallOrRefresh-Module "oh-my-posh"
    
    # Copy custom oh-my-posh 3 theme
    InstallOrRefresh-OhMyPoshTheme $ohMyPoshThemeFileName "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/oh-my-posh/GillesIO.omp.json"
    
    # Add oh-my-posh entry to Powershell profile if needed
    Ensure-OhMyPoshProfileEntry $ohMyPoshThemeFileName
}




# Install oh-my-posh 3, copy custom theme(s) and insert entry in user profile
Install-OhMyPosh