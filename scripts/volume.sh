#!/bin/bash
# changevolume
# by Maplepy


# # Play the volume changed sound
# canberra-gtk-play -i audio-volume-change -d "changeVolume"

# Notification tag
mic_tag="micvolume"

# Source = input
# Sink   = output
mic_source="@DEFAULT_SOURCE@"

mic_update() {
    mic_volume=$(pactl get-source-volume $mic_source | grep -Pow '\d+%' | head -1)
    mic_muted=$(pactl get-source-mute $mic_source | grep -Pow "(yes|no)")

    if [[ -z "${mic_volume}" ]]; then
        echo "mic not found"
        exit 1
    fi
}

case "$1" in
    update)

    ;;
    status)
        mic_update

        if [[ "$mic_muted" == "yes" || $mic_volume == "0%" ]]; then
            echo "%{F#aaF7F8F7}%{T4}%{T-} off"
            dunstify -a "changevolume"                  \
                -i mic-off                              \
                -h string:x-dunst-stack-tag:$mic_tag    \
                "Mic" "Volume: <b>muted</b>"
        else
            # echo "%{F#f0c674}%{T5}%{T-} %{F#F7F8F7}$mic_volume"
            echo "%{F#F7F8F7}%{T5}%{T-} $mic_volume"
            dunstify -a "changevolume"                  \
                -i mic-high                             \
                -h string:x-dunst-stack-tag:$mic_tag    \
                -h int:value:"$mic_volume"              \
                "Microphone" "Volume: <b>$mic_volume</b>"
        fi
    ;;
    init)
        pactl set-source-volume $mic_source 80%
        pactl set-source-mute   $mic_source 1
        polybar-msg action "#mic.hook.1"
    ;;
    toggle)
        pactl set-source-mute   $mic_source toggle
        polybar-msg action "#mic.hook.1"
    ;;
    raise)
        pactl set-source-mute   $mic_source 0
        pactl set-source-volume $mic_source +5%
        polybar-msg action "#mic.hook.1"
    ;;
    lower)
        pactl set-source-mute   $mic_source 0
        pactl set-source-volume $mic_source -5%
        polybar-msg action "#mic.hook.1"
    ;;
    *)
        echo "Available commands: status, init, toggle, raise, lower"
    ;;
esac

# amixer
# amixer set Master 5%+
# amixer set Master toggle
