#!/bin/bash
# Power menu
# by Maplepy


# Options for powermenu
lock="  Lock"
logout="  Logout"
shutdown="  Shutdown"
reboot="  Reboot"
sleep="  Sleep"
hybrid="   Hybrid Sleep"
hibernate="   Hibernate"

# chosen=$(printf "  Power Off\n  Restart\n  Lock" | rofi -dmenu -i -theme-str '@import "powermenu.rasi"')

# Get answer from user via rofi
selected_option=$(echo "$lock
$logout
$reboot
$shutdown
$hybrid
$hibernate
$sleep" | rofi -dmenu\
                  -i\
                  -p "Power"\
                  -config "$HOME/.config/rofi/powermenu.rasi" \
                  -lines 4 \
                  -line-margin 3\
                  -line-padding 10\
                  -scrollbar-width "0" )


# Do something based on selected option
case "${selected_option}" in
    "$lock") /home/"$USER"/.config/bspwm/scripts/i3lock-fancy/i3lock-fancy.sh ;;
    "$shutdown") shutdown now ;;
    "$reboot") systemctl reboot ;;
    "$hibernate") systemctl hibernate ;;
    "$hybrid") systemctl hybrid-sleep ;;
    "$logout") bspc quit ;;
    "$sleep")
        amixer set Master mute
        systemctl suspend
    ;;
    *)
        echo "Choice is invalid"
    ;;
esac
