#!/bin/bash

# Configure apt-get repositories
echo "Updating apt-get repository list..."
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:jonathonf/vim

# Update pkg lists
echo "Updating package lists..."
sudo apt-get update

# Upgrade all the things
echo ''
echo "Upgrade all apt packages and prune unused ones..."
sudo apt-get full-upgrade -y && sudo apt-get autoremove -y

# zsh install
echo ''
echo "Installing zsh..."
echo ''
sudo apt install zsh -y

# git install
echo ''
echo "Installing git..."
sudo apt-get install -y

# git useful defaults
echo ''
echo "Setting git config --global pull.rebase false"
git config --global pull.rebase false

# git-completion.bash
echo ''
echo "Configuring git-completion..."
if [ -f "$HOME/.git-completion.bash" ]; then rm -Rf "$HOME/.git-completion.bash"; fi
GIT_VERSION=`git --version | awk '{print $3}'`
URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
echo ''
echo "Downloading git-completion for git version: $GIT_VERSION..."
if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
	echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
fi

# bash-completion install
echo ''
echo "Installing bash-completion..."
sudo apt-get install bash-completion -y

# oh-my-zsh install
if [ ! -d "$ZSH" ]
then
    echo ''
    echo "Installing oh-my-zsh..."
    echo ''
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# oh-my-zsh plugin install
if [ -d "~/.zsh/zsh-syntax-highlighting" ]
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
if [ -d "~/.oh-my-zsh/custom/themes/powerlevel10k" ]
then
    echo ''
    echo "Installing powerlevel10k..."
    echo ''
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo ''
    echo "Pulling powerlevel10k repo..."
    pushd $(pwd)
    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
    popd
    echo ''
fi

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
echo "Installing Gilles Zunino dotfiles..."
if [ -d "~/.dotfiles" ]
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

# Set default shell to zsh
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
