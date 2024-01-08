sudo pacman -S zsh lsd bat zsh-completions zsh-autosuggestions zsh-syntax-highlighting
chsh -s /bin/zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

cat ./.zshrc > ~/.zshrc