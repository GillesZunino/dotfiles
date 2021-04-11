function InstallOrRefresh-Module([string] $moduleName) {
    # List all installed versions of the given module
    $allInstalledModules = Get-InstalledModule -Name $moduleName -ErrorAction Ignore
    $allInstalledModules | Format-Table | Out-Host
    $galleryLatestModule = Find-Module -Name $moduleName

    if ($allInstalledModules.Count -gt 0) {
        [Version] $latestInstalledVersion = ( $allInstalledModules | ForEach-Object { [Version]::Parse($_.Version)} | Measure-Object -Maximum ).Maximum
        [Version] $galleryModuleVersion = [Version]::Parse($galleryLatestModule.Version);

        if ($galleryModuleVersion -gt $latestInstalledVersion) {
            Write-Host "Newer version '$galleryModuleVersion' available. Removing installed '$moduleName' with version '$latestInstalledVersion'"
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
        Install-Module $moduleName -Scope CurrentUser -Repository PSGallery
    }
}

function Append-ToCurrentUserAllHostsProfile([string] $commandToAppend, [string] $userFacingDescription) {
    if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
        Write-Host "Creating profile for Current User, All Hosts at `$PROFILE.CurrentUserAllHosts ($PROFILE.CurrentUserAllHosts)"
        New-Item -Type File -Path $PROFILE.CurrentUserAllHosts -Force
    }

    # Load profile and inspect if the command is already in
    [string] $currentUsersAllHostsProfileContent = Get-Content $PROFILE.CurrentUserAllHosts -Raw
    [bool] $hasProfileCustomization = $false
    if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
        $currentUsersAllHostsProfileContent | ForEach-Object { $hasProfileCustomization = $false } { $hasProfileCustomization = $hasProfileCustomization -or $_.Contains($commandToAppend) } { $hasProfileCustomization }
    }

    if ($hasProfileCustomization -ne $true) {
        Write-Host "Adding '$userFacingDescription' to `$PROFILE.CurrentUserAllHosts"
        if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
            Add-Content -Path $PROFILE.CurrentUserAllHosts `n
        }
        Add-Content -Path $PROFILE.CurrentUserAllHosts $commandToAppend
    } else {
        Write-Host "`$PROFILE.CurrentUserAllHosts up to date"
    }
}



function Install-OhMyPosh() {
    [string] $ohMyPoshUserFriendlyName = "oh-my-posh"
    [string] $ohMyPoshThemeFileName = "GillesIO.omp.json"
    [string] $ohMyPoshThemeFileUrl = "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/oh-my-posh/GillesIO.omp.json"

    # Install oh-my-posh
    InstallOrRefresh-Module $ohMyPoshUserFriendlyName
    
    # Copy custom oh-my-posh theme
    [string] $userOhMyPoshProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath $ohMyPoshUserFriendlyName
    [string] $themeFullyQualifiedPath = Join-Path -Path $userOhMyPoshProfileFullPath -ChildPath $ohMyPoshThemeFileName

    if (Test-Path -Path $themeFullyQualifiedPath) {
        Write-Host "Custom theme already exists - Removing"
        Remove-Item -Path $themeFullyQualifiedPath -Force
    }

    Write-Host "Refreshing '$ohMyPoshUserFriendlyName' theme at '$themeFullyQualifiedPath'"
    New-Item -ItemType Directory -Force -Path $userOhMyPoshProfileFullPath
    Invoke-WebRequest -Uri $ohMyPoshThemeFileUrl -OutFile $themeFullyQualifiedPath
    
    # Update $PROFILE to configure the custom theme if it is not yet enabled
    [string] $ohMyPoshPromptEnableCommand = 'Set-PoshPrompt "$env:USERPROFILE\' + $ohMyPoshUserFriendlyName + '\' + $ohMyPoshThemeFileName + '"'
    Append-ToCurrentUserAllHostsProfile "# Start $ohMyPoshUserFriendlyName`r`n$ohMyPoshPromptEnableCommand" $ohMyPoshUserFriendlyName
}




# Install oh-my-posh 3, copy custom theme(s) and insert entry in user profile
Install-OhMyPosh