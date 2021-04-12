function Install-GalleryPackage([string] $moduleName) {
    # List all installed versions of the given module
    $allInstalledModules = Get-InstalledModule -Name $moduleName -ErrorAction Ignore
    #$allInstalledModules | Format-Table | Out-Host
    $galleryLatestModule = Find-Module -Name $moduleName

    if ($allInstalledModules.Count -gt 0) {
        [Version] $latestInstalledVersion = ( $allInstalledModules | ForEach-Object { [Version]::Parse($_.Version)} | Measure-Object -Maximum ).Maximum
        [Version] $galleryModuleVersion = [Version]::Parse($galleryLatestModule.Version);

        if ($galleryModuleVersion -gt $latestInstalledVersion) {
            Write-Host "Newer version '$galleryModuleVersion' available. Removing installed '$moduleName' with version '$latestInstalledVersion'"
            Get-InstalledModule $moduleName -AllVersions | Where-Object { $_.Version -ne $Latest.Version } | Uninstall-Module
            $allInstalledModules = @()
        } else {
            Write-Host "Module '$moduleName' ($latestInstalledVersion) is up to date"
        }
    }

    if ($allInstalledModules.Count -eq 0) {
        Write-Host "Installing module '$moduleName'"
        $galleryLatestModule | Format-Table | Out-Host

        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module $moduleName -Scope CurrentUser -Repository PSGallery
    }
}

function Merge-CommandToCurrentUserAllHostsProfile([string] $commandToAppend, [string] $userFacingDescription) {
    if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
        Write-Host "Creating profile for Current User, All Hosts at `$PROFILE.CurrentUserAllHosts ($PROFILE.CurrentUserAllHosts)"
        New-Item -Type File -Path $PROFILE.CurrentUserAllHosts -Force | Out-Null
    }

    # Load profile and inspect if the command is already in
    [string] $currentUsersAllHostsProfileContent = Get-Content $PROFILE.CurrentUserAllHosts -Raw
    [bool] $hasProfileCustomization = $false
    if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
        $currentUsersAllHostsProfileContent | ForEach-Object { $hasProfileCustomization = $false } { $hasProfileCustomization = $hasProfileCustomization -or $_.Contains($commandToAppend) } { $hasProfileCustomization } | Out-Null
    }

    if ($hasProfileCustomization -ne $true) {
        Write-Host "Adding '$userFacingDescription' to `$PROFILE.CurrentUserAllHosts"
        if ([String]::IsNullOrEmpty($currentUsersAllHostsProfileContent) -ne $true) {
            Add-Content -Path $PROFILE.CurrentUserAllHosts `n
        }
        Add-Content -Path $PROFILE.CurrentUserAllHosts $commandToAppend
    } else {
        Write-Host "Startup command for '$userFacingDescription' already in `$PROFILE.CurrentUserAllHosts"
    }
}

Export-ModuleMember -Function Install-GalleryPackage
Export-ModuleMember -Function Merge-CommandToCurrentUserAllHostsProfile