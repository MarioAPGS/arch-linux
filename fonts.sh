install_dependencies () {
    FONTSPATH=/usr/share/fonts
    mkdir $FONTSPATH/$1
    wget $2
    mv $1.zip $FONTSPATH/$1/
    unzip $FONTSPATH/$1/$1.zip -d $FONTSPATH/$1
    rm $FONTSPATH/$1/$1.zip
}

install_dependencies "JetBrainsMono" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
install_dependencies "Agave" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Agave.zip"
install_dependencies "Hack" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"