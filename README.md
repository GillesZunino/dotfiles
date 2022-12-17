# Personal dotfiles - Windows Powershell Core

## Installation or upgrade
1. Install or upgrade [Powershell Core](https://github.com/PowerShell/PowerShell/releases/latest).
2. Open a Powershell Core window and run:
    ```powershell
    Invoke-Expression -Command ( Invoke-WebRequest -Uri https://raw.githubusercontent.com/GillesZunino/dotfiles/powershell/Configure.ps1 ).Content
    ```
3. Install all variants of `MesloLGS NF` from the [MesloLGS NF repository](https://github.com/romkatv/powerlevel10k/blob/master/font.md). Make sure to install for all users.
4. [Optional] Install all variants of `Cascadia Mono PL` from the [Cascadia GitHub release page](https://github.com/microsoft/cascadia-code/releases). Make sure to install for all users.
5. [Optional] Install all variants of `Fira Code` from [FiraCode](https://github.com/tonsky/FiraCode). Make sure to install for all users.

6. If using Windows Terminal, create a new Windows Terminal entry:
    ```json
    {
        "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
        "name": "PowerShell Core",
        "source": "Windows.Terminal.PowershellCore",
        "commandline": "C:\\Program Files\\PowerShell\\7\\pwsh.exe -NoLogo -NoExit -WorkingDirectory D:\\ -Command Cls",
        "startingDirectory": "D:\\",

        "fontFace": "MesloLGS NF",
        "fontSize": 9
    }
    ```
    See `settings.json` for a full Windows Terminal settings file.

7. Restart all instances of Powershell to ensure all customizations have been applied

## Customizations applied
The installation script automatically enables capabilities listed below:

* `oh-my-posh` for the current user on all Powershell hosts. This is done by appending the following at the end of '`$PROFILE.CurrentUserAllHosts`':
    ```powershell
    Set-PoshPrompt "$env:USERPROFILE\oh-my-posh\GillesIO.omp.json"
    ```

* `Terminal-Icons` for the current user on all Powershell hosts. This is done by appending the following at the end of '`$PROFILE.CurrentUserAllHosts`':
    ```powershell
    Import-Module Terminal-Icons
    ```