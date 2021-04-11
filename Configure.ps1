function Import-RemoteScript([string] $scriptUrl) {
    [string] $scriptSource = Invoke-WebRequest -Uri $scriptUrl
    $ScriptBlock = [Scriptblock]::Create($scriptSource.Content)
    Invoke-Command -NoNewScope -ScriptBlock $ScriptBlock 
}


# Load all scripts we will need
Import-RemoteScript "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Utilities.ps1"
Import-RemoteScript "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Install-OhMyPosh.ps1"
Import-RemoteScript "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Install-TerminalIcons.ps1"


# Install oh-my-posh
Install-OhMyPosh

# Install Terminal-Icons
Install-TerminalIcons