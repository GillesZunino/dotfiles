#!/bin/bash

# Upgrade all the things
echo ''
echo "Upgrade all brew packages and prune unused ones..."
brew update && brew outdated && brew upgrade

# git install
echo ''
echo "Installing git..."
brew install git

# git useful defaults
echo ''
echo "Setting git config --global pull.rebase false"
git config --global pull.rebase falses

# oh-my-zsh plugin install
if [ ! -d "~/.zsh/zsh-syntax-highlighting" ]
then
    echo ''
    echo "Installing oh-my-zsh plugins..."
    echo ''
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
else
    echo ''
    echo "Pulling oh-my-zsh plugins repo..."
    pushd $(pwd)
    cd ~/.zsh/zsh-syntax-highlighting && git pull
    popd
    echo ''
fi

# powerlevel10k
if [ ! -d "~/.oh-my-zsh/custom/themes/powerlevel10k" ]
then
    echo ''
    echo "Installing powerlevel10k..."
    echo ''
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
else
    echo ''
    echo "Pulling powerlevel10k repo..."
    pushd $(pwd)
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
    popd
    echo ''
fis

# vim-plug install
echo ''
echo "Installing vim-plug..."
echo ''
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo ''
echo "Installing Gilles Zunino dotfiles..."
if [ ! -d "~/.dotfiles" ]
then
    git clone https://github.com/gilleszunino/dotfiles.git ~/.dotfiles
fi
echo ''
pushd $(pwd) 
cd $HOME/.dotfiles && echo "switched to .dotfiles dir..."
echo ''
echo "Checking out WSL branch..." && git checkout wsl
echo ''
echo "Pulling latest WSL branch..." && git reset --hard origin/wsl && git pull
echo ''
echo "Now configuring symlinks..." && $HOME/.dotfiles/script/bootstrap
if [[ $? -eq 0 ]]
then
    echo "Successfully configured your environment with Gilles Zunino's dotfiles..."
else
    echo "Gilles Zunino's dotfiles were not applied successfully..." >&2
fi

# Restore path
popd

# Set default shell to zsh only if it is not currently set
currentShell=`grep $USER /etc/passwd | awk -F: '{ print $7 }'`
if [ "$currentShell" != "/usr/bin/zsh" ]; then
    echo ''
    read -p "Do you want to change your default shell? Yy/Nn: " -n 1 -r REPLY
    echo ''
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Setting zsh as default shell..."
        sudo chsh -s $(which zsh) $USER
        if [[ $? -eq 0 ]]
        then
            echo "Successfully set your default shell to zsh..."
        else
            echo "Default shell not set successfully..." >&2
    fi
    else 
        echo "You chose not to configure zsh as default shell"
    fi
    echo 'Done'
fi