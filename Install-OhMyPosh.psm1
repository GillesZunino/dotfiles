function Install-OhMyPosh() {
    [string] $ohMyPoshUserFriendlyName = "oh-my-posh"
    [string] $ohMyPoshThemeFileName = "GillesIO.omp.json"
    [string] $ohMyPoshThemeFileUrl = "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/oh-my-posh/GillesIO.omp.json"

    # Install or upgrade oh-my-posh
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    
    # Copy custom oh-my-posh theme
    [string] $userOhMyPoshProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath $ohMyPoshUserFriendlyName
    [string] $themeFullyQualifiedPath = Join-Path -Path $userOhMyPoshProfileFullPath -ChildPath $ohMyPoshThemeFileName

    if (Test-Path -Path $themeFullyQualifiedPath) {
        Write-Host "Custom theme already exists - Removing"
        Remove-Item -Path $themeFullyQualifiedPath -Force | Out-Null
    }

    Write-Host "Refreshing '$ohMyPoshUserFriendlyName' theme at '$themeFullyQualifiedPath'"
    New-Item -ItemType Directory -Force -Path $userOhMyPoshProfileFullPath | Out-Null
    Invoke-WebRequest -Uri $ohMyPoshThemeFileUrl -OutFile $themeFullyQualifiedPath
    
    # Update $PROFILE to configure the custom theme if it is not yet enabled
    [string] $ohMyPoshPromptEnableCommand = 'oh-my-posh init pwsh --config "$env:USERPROFILE\' + $ohMyPoshUserFriendlyName + '\' + $ohMyPoshThemeFileName + '" | Invoke-Expression'
    Merge-CommandToCurrentUserAllHostsProfile "# Start $ohMyPoshUserFriendlyName`r`n$ohMyPoshPromptEnableCommand" $ohMyPoshUserFriendlyName
}

Export-ModuleMember -Function Install-OhMyPosh