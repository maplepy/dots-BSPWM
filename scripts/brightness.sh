#!/usr/bin/env bash

get_brightness_icon() {
    brightness=$(printf "%.0f\n" "$(brillo -q -G)")

    # Normal brightness
    if [ "$brightness" -le 50 ]; then
        # speaker_status_icon=" %{T5}"
        brightness_icon=""
        brightness_level="normal"
    # High brightness
    else
        brightness_icon="ﯦ"
        brightness_level="high"
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
    inc) 
        brillo -q -A 2
        ;;
    dec)
        brillo -q -U 2
        ;;
    reset)
        brillo -q -S 75
esac
send_notification