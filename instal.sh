#!/bin/sh

function install_yay () {
    # download the library
    sudo pacman -S --needed fakeroot make gcc
    sudo git clone https://aur.archlinux.org/yay-git.git /opt/
    sudo chown -R $1:$$1 ./yay-git
    (cd /opt/yay-git && makepkg -si)
     
}

function install_awesome () {
    sudo pacman -S --needed base-devel fakeroot make gcc
    git clone https://aur.archlinux.org/awesome-git.git /opt/
    sudo chown -R $1:$1 ./awesome-git
    (cd /opt/awesome-git && makepkg -fsri)
}

function install_dependencies () {
    # Update packages
    sudo pacman -Syu git

    # gui server
    sudo pacman -S xorg xorg-server xorg-xinit

    # user login manager
    sudo pacman -S lightdm lightdm-gtk-greeter
    
    read -p "User owner name: " user
    install_yay $user
    install_awesome $user

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