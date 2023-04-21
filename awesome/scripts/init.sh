#!/bin/sh

cd $(dirname $0)

function exe () {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

# exe $HOME/.config/awesome/scripts/redshift.sh restore

xrdb merge $HOME/.Xresources

setxkbmap es
#xrandr --output DP-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-3 --primary --mode 1920x1080 --pos 1920x1080 --rotate normal
xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal
#feh --bg-fill /home/dxt0r/.wallpapers/aot.png &
# picom --config=/home/dxt0r/.config/awesome/assets/picom/picom.conf -b &
picom &
sh /home/dxt0r/.config/awesome/scripts/net.sh &