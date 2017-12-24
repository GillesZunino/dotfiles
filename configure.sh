#!/bin/bash

# Configure apt-get repositories
echo "Updating apt-get repository list..."
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository ppa:jonathonf/vim

# Update pkg lists
echo "Updating package lists..."
sudo apt-get update

# zsh install
echo ''
echo "Installing zsh..."
echo ''
sudo apt install zsh -y

# git install
echo ''
echo "Installing git and bash-completion..."
sudo apt-get install git bash-completion -y

echo ''
echo "Configuring git-completion..."
GIT_VERSION=`git --version | awk '{print $3}'`
URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
echo ''
echo "Downloading git-completion for git version: $GIT_VERSION..."
if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
	echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
fi

# oh-my-zsh install
echo ''
echo "Installing oh-my-zsh..."
echo ''
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# oh-my-zsh plugin install
echo ''
echo "Installing oh-my-zsh plugins..."
echo ''
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# powerlevel9k install
echo ''
echo "Installing powerlevel9k..."
echo ''
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Bash color scheme
echo ''
echo "Installing solarized dark WSL color scheme..."
echo ''
wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
mv dircolors.256dark .dircolors

# vim-plug install
echo ''
echo "Installing vim-plug..."
echo ''
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo ''
echo "Now pulling down Gilles Zunino dotfiles..."
git clone https://github.com/gilleszunino/dotfiles.git ~/.dotfiles
echo ''
cd $HOME/.dotfiles && echo "switched to .dotfiles dir..."
echo ''
echo "Checking out WSL branch..." && git checkout wsl
echo ''
echo "Now configuring symlinks..." && $HOME/.dotfiles/script/bootstrap
if [[ $? -eq 0 ]]
then
    echo "Successfully configured your environment with Gilles Zunino's dotfiles..."
else
    echo "Gilles Zunino's dotfiles were not applied successfully..." >&2

# Set default shell to zsh
echo ''
read -p "Do you want to change your default shell? y/n" -n 1 -r REPLY
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Setting zsh as default shell..."
    chsh -s $(which zsh); exit 0
    if [[ $? -eq 0 ]]
    then
        echo "Successfully set your default shell to zsh..."
    else
        echo "Default shell not set successfully..." >&2
fi
else 
    echo "You chose not to configure zsh as default shell"
fi
echo ''
echo '	Done'
