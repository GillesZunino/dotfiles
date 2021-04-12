function Install-TerminalIcons() {
    [string] $TerminalIconsUserFriendlyName = "Terminal-Icons"

    # Install Terminal-Icons
    Install-GalleryPackage $TerminalIconsUserFriendlyName

    # Update $PROFILE to configure the custom theme if it is not yet enabled
    [string] $terminalIconsEnableCommand = "Import-Module -Name $TerminalIconsUserFriendlyName"
    Merge-CommandToCurrentUserAllHostsProfile "# Start $TerminalIconsUserFriendlyName`r`n$terminalIconsEnableCommand" $TerminalIconsUserFriendlyName
}

Export-ModuleMember -Function Install-TerminalIcons