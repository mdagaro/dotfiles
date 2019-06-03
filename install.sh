# Install bashrc
cd ~/dotfiles
cat bashrc > ~/.bashrc
cd
touch .bashrc_local
echo "\" Local bashrc file. Edit as you please!" > .bashrc_local

cd ~/dotfiles
cat gitconfig > ~/.gitconfig

git clone --depth=1 https://github.com/mdagaro/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

echo "Dotfiles installed"
