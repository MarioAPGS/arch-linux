# export shortcuts conf files

dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > org_gnome_settings-daemon_plugins_media-keys
dconf dump /org/gnome/desktop/wm/keybindings/ > org_gnome_desktop_wm_keybindings
dconf dump /org/gnome/shell/keybindings/ > org_gnome_shell_keybindings
dconf dump /org/gnome/mutter/keybindings/ > org_gnome_mutter_keybindings
dconf dump /org/gnome/mutter/wayland/keybindings/ > org_gnome_mutter_wayland_keybindings