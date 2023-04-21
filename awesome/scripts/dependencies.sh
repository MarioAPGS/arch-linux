function install_dependencies () {
    # Update packages
    pacman -Syu

    # Desktop
    pacman -S jq rofi firefox
    ## jq      = used to monitor temperature
    ## rofi    = popup menu
    ## firefox = web explorer

    # Console
    pacman -S kitty zsh lsd bat picom
    ## kitty = console powered by GPU 
    ## zsh   = shell
    ## lsd   = display ls with colors and icons (fancy ls command)
    ## bat   = fancy file displayer (fancy cat command)
    ## picom = background transparency
}

read -p "Do you want to install dependencies: " update
if [ "$update" != "${update#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    install_dependencies;
else
    echo Skipping install dependencies
fi