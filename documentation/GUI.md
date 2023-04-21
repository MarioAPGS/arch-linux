# GUI

**NOTE:** Do not follow the next steps with the root user, use your personal user (if you dont have user you can create it typing `useradd -m <user_name>` and `passwd user_name>`)

To install the gui you need some libraires:
## 1. Core packages
* **xorg:** graphic controller
* **xorg-server:** graphic controller service

```bash
sudo pacman -S xorg xorg-server
```
## 2. Session manager
* **lightdm:** graphic session manager service
* **lightdm-gtk-greeter:** theme for the graphic session manager

### Instalation
```bash
sudo pacman -S lightdm lightdm-gtk-greeter
```
### Configuration
* enable the lightdm service
```bash
sudo systemctl enable lightdm
```
* edit the file `/etc/lightdm/lightdm.conf` search by 'greeter-session' and remove the # 
```bash
# file: /etc/lightdm/lightdm.conf
greeter-session=lightdm-gtk-greeter
```


## 3. Desktop manager
* **awesome:** graphic desktop manager

### Dependencies and instalation

* Git - control version manager
```bash
sudo pacman -S git
```
* yay - AUR packages manager
```bash
cd /opt
# download the library
sudo git clone https://aur.archlinux.org/yay-git.git
# change the permissions of the directory
sudo chown -R <your_user>:<your_user> ./yay-git
# install the library and dependencies
sudo pacman -S fakeroot make gcc jq
cd yay-git
makepkg -si
```
* Awesome - Desktop manager

go to the [oficial repository](https://github.com/awesomeWM/awesome) and follow the **Arch** instalation guide

**Summary to install in arch**
```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/awesome-git.git
cd awesome-git
makepkg -fsri
```

**NOTE:** awesome use a default configuration in the path `/etc/xdg/awesome/rc.lua`, this configuraton try to use the console `xterm` which is not installed, change this value with your console or install xterm.


## Apply my desktop configuration

* Kitty - the console - configure the console [here](./Console.md) (optional)
```bash
sudo pacman -S kitty
```
* awesome try to find the configuration in `~/.config/awesome/rc.lua`, if you want to use my desktop configuration:
```bash
# remove preconfigured directory (if exists)
rm -r ~/.config/awesome
# create ~/.config and move there the configuration 
mkdir ~/.config
cp-r <path_of_this_repo>/awesome ~/.config/
```
Reboot the computer

NVIDIA DRIVERS
create `/etc/modprobe.d/blacklist-nvidia nvidia-utils` and add:
```
blacklist nouveau
options nouveau modeset=0
```

Refresh the linux image and install the correct drivers
```bash
sudo mkinitcpio -P
sudo pacman -S linux-headers nvidia nvidia-utils
```