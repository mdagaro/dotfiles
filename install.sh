# Install bashrc
cd ~/dotfiles
cat .bashrc > ~/.bashrc
cd
touch .bashrc_local
echo "\" Local bashrc file. Edit as you please!" > .bashrc_local

cd ~/dotfiles
cat .gitconfig > ~/.gitconfig

echo "Dotfiles installed"
