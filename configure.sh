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
git config --global pull.rebase false

# oh-my-zsh plugin install
if [ -d ~/.zsh/zsh-syntax-highlighting ]; then
    echo ''
    echo "Pulling oh-my-zsh plugins repo..."
    pushd $(pwd)
    cd ~/.zsh/zsh-syntax-highlighting && git pull
    popd
    echo ''
else
    echo ''
    echo "Installing oh-my-zsh plugins..."
    echo ''
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# powerlevel10k
if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    echo ''
    echo "Pulling powerlevel10k repo..."
    pushd $(pwd)
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
    popd
    echo ''
else
    echo ''
    echo "Installing powerlevel10k..."
    echo ''
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

# vim-plug install
echo ''
echo "Installing vim-plug..."
echo ''
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo ''
echo "Installing Gilles Zunino dotfiles..."
if [ -d ~/.dotfiles ]; then
else
    git clone https://github.com/gilleszunino/dotfiles.git ~/.dotfiles
fi
echo ''
pushd $(pwd) 
cd $HOME/.dotfiles && echo "switched to .dotfiles dir..."
echo ''
echo "Checking out macos branch..." && git checkout macos
echo ''
echo "Pulling latest MacOS branch..." && git reset --hard origin/macos && git pull
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