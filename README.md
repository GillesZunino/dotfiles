# Personal dotfiles - MacOS

1. On the Mac, run:
    ```bash
    cd ~
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/gilleszunino/dotfiles/macos/configure.sh)"
    ```

2. After installation, start vim and run:
    ```bash
    :PlugInstall
    ```
3. Run the following and install the recommended font:
    ```bash
    p10k configure
    ```