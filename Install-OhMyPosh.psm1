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

Export-ModuleMember -Function Install-OhMyPosh