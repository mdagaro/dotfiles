# Install bashrc
cd ~/dotfiles
cat bashrc > ~/.bashrc
cd
if [ ! -f .bashrc_local ]; then
    touch .bashrc_local
    echo "# Local bashrc file. Edit as you please!" > .bashrc_local
fi

cd ~/dotfiles
cat gitconfig > ~/.gitconfig

git submodule update --init --recursive

echo "Dotfiles installed"
