function Install-TerminalIcons() {
    [string] $TerminalIconsUserFriendlyName = "Terminal-Icons"

    # Install Terminal-Icons
    InstallOrRefresh-Module $TerminalIconsUserFriendlyName

    # Update $PROFILE to configure the custom theme if it is not yet enabled
    [string] $terminalIconsEnableCommand = "Import-Module -Name $TerminalIconsUserFriendlyName"
    Append-ToCurrentUserAllHostsProfile "# Start $TerminalIconsUserFriendlyName`r`n$terminalIconsEnableCommand" $TerminalIconsUserFriendlyName
}