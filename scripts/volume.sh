#!/bin/bash
# by Maplepy

# Notification tag
mic_tag="micvolume"

# Change the volume using alsa(might differ if you use pulseaudio)
amixer -c 0 set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer -c 0 get Master | tail -1 | awk '{print $4}' | sed 's/[^0-9]*//g')"
mute="$(amixer -c 0 get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$mic_tag "Volume muted"
else
    # Show the volume notification
    dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$mic_tag \
    -h int:value:"$volume" "Volume: ${volume}%"
fi

# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"



# Source = input
# Sink   = output
mic_source="@DEFAULT_SOURCE@"
mic_volume=$(stdbuf -oL pactl get-source-volume $mic_source | grep -Pow '\d+%' | head -1)
mic_muted=$(pactl get-source-mute $mic_source | grep -Pow "(yes|no)")


if [[ -z "${mic_volume}" ]]; then
    echo "mic not found"
    exit 1
fi

check_mic_mute() {
    if [[ "$mic_muted" == "yes" || $mic_volume == "0%" ]]; then
        echo "muted"
    fi
}

# amixer
# amixer set Master 5%+
# amixer set Master toggle


# speaker
sh -c "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%"
sh -c "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 -5%"
pactl set-sink-mute 0 toggle

# mic
pactl set-source-mute 1 toggle





case "$1" in
    inc)
        echo "item = 1"
    ;;
    2|3)
        echo "item = 2 or item = 3"
    ;;
    *)
        echo "default (none of above)"
    ;;
esac
