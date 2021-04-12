function Import-RemoteModuleByUrl([string] $scriptUrl, [string] $moduleName) {
    [string] $scriptSource = Invoke-WebRequest -Uri $scriptUrl
    $scriptBlock = [Scriptblock]::Create($scriptSource)
    $module = New-Module -Name $moduleName -ScriptBlock $scriptBlock
    Import-Module $module
}

function Import-RemoteModuleByFilePath([string] $scriptFile, [string] $moduleName) {
    [string] $scriptSource = Get-Content $scriptFile -Raw
    $scriptBlock = [Scriptblock]::Create($scriptSource)
    $module = New-Module -Name $moduleName -ScriptBlock $scriptBlock
    Import-Module $module
}


# For production, load scripts as urls
Import-RemoteModuleByUrl "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Utilities.psm1" "Utilities"
Import-RemoteModuleByUrl "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Install-OhMyPosh.psm1" "Install-OhMyPosh"
Import-RemoteModuleByUrl "https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Install-TerminalIcons.psm1" "Install-TerminalIcons"


# For debugging, load scripts locally
# [string] $modulesBasePath = ( Split-Path -parent $PSCommandPath )
# Import-RemoteModuleByFilePath ( Join-Path -Path $modulesBasePath -Child "Utilities.psm1" ) "Utilities"
# Import-RemoteModuleByFilePath ( Join-Path -Path $modulesBasePath -Child "Install-OhMyPosh.psm1" ) "Install-OhMyPosh"
# Import-RemoteModuleByFilePath ( Join-Path -Path $modulesBasePath -Child "Install-TerminalIcons.psm1" ) "Install-TerminalIcons"



# Install oh-my-posh
Write-Host "=================================================================== oh-my-posh ==================================================================="
Install-OhMyPosh

# Install Terminal-Icons
Write-Host `n`n"================================================================= Terminal-Icons ================================================================="
Install-TerminalIcons