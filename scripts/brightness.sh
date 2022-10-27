#!/usr/bin/env bash

get_brightness_icon() {
    brightness=$(printf "%.0f\n" "$(brillo -q -G)")

    # Normal brightness
    if [ "$brightness" -le 50 ]; then
        brightness_icon=""
        # brightness_level="normal"
    # High brightness
    else
        brightness_icon="ﯦ"
        # brightness_level="high"
    fi
}

send_notification() {
    get_brightness_icon
    dunstify -a "changebrightness"          \
        -r "4000"                           \
        -t 4010                             \
        -h int:value:"$brightness"          \
        -i "brightness-$brightness_icon"   \
        "Backlight" "Brightness: <b>$brightness%</b>"
}

# Get args passed
case "$1" in
    -*)
        brillo -q -U "$(echo "$1" | tr -d '-')" # -2 -> 2
        ;;
    +*) 
        brillo -q -A "$(echo "$1" | tr -d '+')" # +2 -> 2
        ;;
    min)
        brillo -q -S 0
        ;;
    max)
        brillo -q -S 100
        ;;
    reset)
        brillo -q -S 75
esac
send_notification