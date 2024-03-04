# Install bashrc

DIRNAME=$(dirname $0)

cd $DIRNAME
cat bashrc > ~/.bashrc
cat tmux > ~/.tmux.conf
if [ ! -f ~/.bashrc_local ]; then
    touch ~/.bashrc_local
    echo "# Local bashrc file. Edit as you please!" > .bashrc_local
fi

cat gitconfig > ~/.gitconfig

git submodule update --init --recursive

ln -s $DIRNAME/neovim ~/.config/nvim

echo "Dotfiles installed"

cp -r scripts $HOME
echo "Copied scripts"

# cd scripts/goto
# make install
# echo "Installed goto manpages"
