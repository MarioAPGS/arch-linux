# Install display link

### Connect screens and docker station via USB

Source documentation: https://wiki.archlinux.org/title/DisplayLink

`yay -S evdi-git`

If there is an error during the instalation trying to install evdi (it does not break the instalation, only display a error in some point of the process), try to install evdi-git which is the dev package, you can check if is working executing the following command:
`sudo modprobe evdi`.
If the command does not return anything is working fine.

Install, enable the service and reboot

`yay -S displaylink`

`sudo systemctl enable displaylink`

`sudo reboot now`

If you want to check if the service is working fine after the reboot check the output of `sudo systemctl status displaylink`
