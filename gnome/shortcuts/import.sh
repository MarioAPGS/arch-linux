# import configuration

cat org_gnome_settings-daemon_plugins_media-keys | dconf load /org/gnome/settings-daemon/plugins/media-keys/
cat org_gnome_desktop_wm_keybindings | dconf load /org/gnome/desktop/wm/keybindings/
cat org_gnome_shell_keybindings | dconf load /org/gnome/shell/keybindings/
cat org_gnome_mutter_keybindings | dconf load /org/gnome/mutter/keybindings/
cat org_gnome_mutter_wayland_keybindings | dconf load /org/gnome/mutter/wayland/keybindings/