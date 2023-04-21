# arch-linux

I have started to learn linux and use it as main SO, im using the distribution Arch linux because is one of the minimalist distribution of linux, you have to install it manually so it is perfect to learn the base and start building from there.

For the instalation follow the official guide (it is really good documented and easy to follow)

[Instalation guide](https://wiki.archlinux.org/title/installation_guide)

# my errors during instalations and how to solve it

Instalation ways to dual boot windows & linux (Arch)

1. You will install both SO for first time.
2. You have windows | you will install Arch.
3. You have Arch | you will install windows.

In case you are in the 1º scenario, i suggent install windows first (it will remove some problems later regarding the GRUB)

**1. Install windows** 

The most importart part here is change the size of the UEFI boot partition (by default is 100M and in not enought to do dual boot)

When you are in the partition configuration, you should remove the UEFI boot partition and create a new one with more space (300M or 500M is enought).

**How to do it:**
* Remove the partition with label = System (it is 100M size)
* Open console (Press Shift + F10)
* Open partition program (Type ```diskpart.exe```)
* List disks (Type ```list disk```  )
* Select disk (Type ```select disk n``` where ```n``` is the disk where you will create the partition)
* Create efi partition (Type ```create partition efi size=550M```)
* Format the new partition (Type ```format quick fs=fat32 label=System```) 
* close the program (Type ```exit```)
* Click on the refresh button

you should see something like this
![win partition](./documentation/images/win_partitions.png)

---
## 2. You have windows | you will install Arch

**IMPORTANT:** you must disable the quick start option

Go to energy options > Define on/off button > Unable Quick start (recomended) 

---

## Some user packages
pacman -S sudo git


## Console

I am using the **kitty** console with **zsh** as shell.

### - Dependencies
* **kitty**: sudo pacaman -S kitty
* **zsh**: sudo pacman -S zsh
### - Configuration 


## Desktop

### - Dependencies
| Library   |      Purpose      |  Cool |
|-----------|:-----------------:|------:|
| awesome   |     create        | $1600 |
| col 2 is  |    centered       |   $12 |
| col 3 is  | right-aligned     |    $1 |

## Audio
## Wifi


