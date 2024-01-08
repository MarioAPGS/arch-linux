https://dev.to/vitorvargas/how-to-install-the-nvidia-driver-on-archlinux-5bgc

sudo pacman -S nvidia nvidia-utils nvidia-settings opencl-nvidia xorgs-server-devel


yay -S evdi-git displayLink
systemctl enable displaylink.service


pacman -S --needed xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
