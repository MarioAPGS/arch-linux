# Audio
You need to uninstall old controller (in case you have it installed)
```bash
sudo pacman -Rdd pulseaudio
```
Install important libraries to control audio

**NOTE:** if you have any conflict with **jack2**, uninstall it we will replace it with **pipewire-jack**
```bash
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-media-session pipewire-pulse
```

Install the GUI managers:

**NOTE**: you need the configure the GUI first, follow this [guide](./GUI.md) 
* **carla** - MIDI controller, you can build the audio MIDI flow and manage some plugins
* **pavucontrol** - Audio controller - you can set the default device, change volumes in each device and application with a source audio
```bash
sudo pacman -S carla pavucontrol
```

## Internal audio does not work in Laptop

In my personal case, the audio controller was not recognicing my internal audio card (which manage the internal speakers and internal mic), I'm guessing you might have the same problem if you are using an intel audio card.

Get audio card name - `lspci -v | grep -i "audio"`

I found the solution [here](https://forum.manjaro.org/t/sound-not-working-after-update-to-manjaro-21-1/73773)

Edit grub config and add the following within the quotation after GRUB_CMDLINE_LINUX_DEFAULT
```bash
# file: /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="snd_intel_dspcfg.dsp_driver=1"
```

Update grub config
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reboot