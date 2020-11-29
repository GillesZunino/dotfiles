# Personal dotfiles - Windows Subsystem for Linux

1. On the UN*X system, run:
    ```bash
    cd ~
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/gilleszunino/dotfiles/wsl/configure.sh)"
    ```

2. After installation, start vim and run:
    ```bash
    :PlugInstall
    ```
3. Install all variants of `MesloLGS NF` font [MesloLGS NF](https://github.com/romkatv/powerlevel10k/blob/master/font.md).

4. Configure Windows Terminal as follows:
    ```json
    {
        "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
        "name": "Ubuntu 20.04 LTS",
        "source": "Windows.Terminal.Wsl",
        "commandline" : "wsl.exe ~ -d Ubuntu",

        "fontFace": "MesloLGS NF",
        "fontSize": 9,

        "useAcrylic": true,
        "acrylicOpacity": 0.8
    }
    ```