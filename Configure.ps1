# oh-my-posh
if ((Get-Module -Name oh-my-posh) -ne "") {
    Write-Host "Updating module 'oh-my-posh'"
    #Update-Module oh-my-posh -Scope CurrentUser -AllowPrerelease
} else {
    Write-Host "Installing module 'oh-my-posh'"
    #Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease
}

# Copy custom theme
[string] $themeFullyQualifiedPath = "$env:USERPROFILE\oh-my-posh\GillesIO.omp.json"
if (Test-Path -Path $themeFullyQualifiedPath) {
    #Remove-Item -Path $themeFullyQualifiedPath -Force
    Write-Host "Delete existing profile"
}
#Invoke-WebRequest -Uri https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Configure.ps1 -OutFile $themeFullyQualifiedPath

# Update $PROFILE to configure the custom theme
# TODO