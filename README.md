# arch-linux

I have started to learn linux and use it as main OS, im using the distribution Arch linux because is one of the minimalist distribution of linux, you have to install it manually OS it is perfect to learn the base and start building from there.

# arch-linux

I have started to learn linux and use it as main OS, im using the distribution Arch linux because is one of the minimalist distribution of linux, you have to install it manually OS it is perfect to learn the base and start building from there.

For the instalation follow the official guide (it is really good documented and easy to follow)

[Instalation guide](https://wiki.archlinux.org/title/installation_guide)

# my errors during instalations and how to solve it

Instalation ways to dual boot windows & linux (Arch)

1. You will install both OS for first time.
2. You have windows | you will install Arch.
3. You have Arch | you will install windows.

In case you are in the 1º scenario, i suggent install windows first (it will remove some problems later regarding the GRUB)

## 1. You will install both OS for first time
Start installing Windows 

The most importart part here is change the size of the UEFI boot partition (by default is 100M and it is not enought to do dual boot)

When you are in the partition configuration, you should remove the UEFI boot partition and create a new one with more space (**300M or 500M** is enought).

**How to do it:**
[Change the UEFI partition during the instalation of Windows](./Fixed.md##change-the-uefi-partition-during-the-instalation-of-windows)

you should see something like this

![win partition](./images/win_partitions.png)

---
## 2. You have windows | you will install Arch

**IMPORTANT:** you must disable the quick start option.
**How to do it:**
[Disable quick start in windows](./Fixed.md#disable-quick-start-in-windows)

**Instal archlinux**

Follow the oficial guideline [here](https://wiki.archlinux.org/title/installation_guide) to install it

**Summary:**

* Change keyboard map - `loadkeys es`

* Create the partitions
* check your disk and partitions - `lsblk`
* cfdisk is a console partition manager - `cfdisk /dev/<disk_name>`
* Create partitions

| Type              |      Purpose      |           Size | Notes      |  mount |
|:------------------|:-----------------:|---------------:|:-----------|:-------|
| EFI System        |    boot loader    | more than 300M | If windows is already installed, DONT create it, we will use the existing one | /boot |
| Linux filesystem  |    linux files    | 10G is enought |            | /      |
| Linux filesystem  |    user files     | 10G is enought | optional   | /home  |
| Linux SWAP        |  use as extra memory if RAM is full  | as you want, but 2G is good | optional   | SWAP  |

* Format the partitions (execute the commands in the *Format* column)

| Partition      |  Formant command  | Notes      |
|:---------------|:-----------------:|:-----------|
| EFI System     | `mkfs.fat -F 32 /dev/<boot_partition>`  | **DO NOT FORMAT IT IF YOU HAVE WINDOWS!!** it was formated during the windows instalation |
| Linux files    | `mkfs.ext4 /dev/<linux_partition>` |             |
| User files     | `mkfs.ext4 /dev/<linux_partition>` |             |
| SWAP           | `mkswap /dev/<swap_partition>` <br></br> `swapon /dev/<swap_partition>`  | Formant and activate as a swap partiton  |

* Mount every partitions

| Partition      |  mount in  | mount command                               |
|:---------------|:----------:|:--------------------------------------------|
| Linux files    |   /        | `mount --mkdir /dev/<boot_part.> /mnt`      |
| User files     |   /home    | `mount --mkdir /dev/<user_part.> /mnt/home` |
| EFI System     |   /boot    | `mount --mkdir /dev/<boot_part.> /mnt/boot`     |

* Install Arch linux, the next command will install the base of Arch linux on the /mnt directory - `pacstrap -K /mnt base linux linux-firmware ntfs-3g networkmanager sudo git nano`

* Create partition table - `genfstab -U /mnt >> /mnt/etc/fstab`

* (pacman -Sy archlinux-keyring && pacman -Syyu)
* Login into Arch OS - `arch-chroot /mnt`

* Change root password - `passwd`

* Create new user and create default home folder - `useradd -m <user_name>`

* Asign the new user a password - `passwd <user_name>`

* Add the new user to the sudo group - `echo <your_user> ALL=(ALL:ALL) ALL >> /etc/sudoers`

* Activate internet - `systemctl enable MetworkManager`

* Configure Time zone, Location, hostname (follow the oficial guide )

* Configure boot loader [GRUB instalation guide](https://wiki.archlinux.org/title/GRUB)


**IMPORTANT: Take into account during GRUB instalation**
* 100M is not enought to install dual boot
* Quick start of windows must be disabled
* Arch should be in UEFI
* the os-prober (which recogine other distros and OS) only works correctly if you are running the arch without the booted usb

**Summary GRUB instalation**

You should do the next steps using the USB booted because your bios won't recognice the new arch OS.

Note: if you reboot before install GRUB (the boot loader) your computer won't recognice the new Arch OS yet. So start linux from the USB boot installer and - `arch-chroot /mnt`

* install grub packages - `pacman -S grub os-prober efibootmgr`
* open `/etc/default/grub` and remove # in the line `GRUB_DISABLE_OS_PROBER=false`

**NOTE**: you need to be sure that the Linux image is available, you can check it going to the UEFI partition and verifying if exist this two files `initramfs-linux-fallback.img initramfs-linux.img`.

**How to fix it:**
[Linux images not found or do not exist](./Instalation-fixes.md#linux-images-not-found-or-do-not-exist)

* install arch boot loader in the existing UEFI partition - `grub-install --target=x86_64-efi --efi-directory=boot --bootloader-id=GRUB`
* Configure GRUB - `grub-mkconfig -o /boot/grub/grub.cfg`
* Exit from your Arch OS - `exit`
* Unplug the USB boot installer and reboot - `reboot now`
* Enter in bios and change the boot order making GRUB as main boot loader
* enter in the Arch OS and repeat the grub configuration command, now should detect windows boot - `grub-mkconfig -o /boot/grub/grub.cfg`

Both systems are ready to be booted by GRUB (linux & windows), at this moment the are a lot of configurations to complete: audio, wifi, bluetooth, desktop...

--- 
* ## [Graphic ui](./documentation/GUI.md)
* ## [Audio](./documentation/Audio.md)
