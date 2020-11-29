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
3. Install the Powerline variants of [Cascadia Code](https://github.com/microsoft/cascadia-code) : `Cascadia Code PL` and `Cascadia Mono PL`.

4. Configure Windows Terminal as follows:
    ```json
    {
        "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
        "name": "Ubuntu 20.04 LTS",
        "source": "Windows.Terminal.Wsl",
        "commandline" : "wsl.exe ~ -d Ubuntu",

        "fontFace" : "Cascadia Mono PL",
        "fontWeight": "extra-light",
        "fontSize": 9,

        "useAcrylic": true,
        "acrylicOpacity": 0.8
    }
    ```