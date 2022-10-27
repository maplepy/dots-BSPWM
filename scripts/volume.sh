#!/bin/bash
# changevolume
# by Maplepy


# Notification tag
mic_tag="micvolume"
speaker_tag="speakervolume"

mic_source="@DEFAULT_SOURCE@"
speaker_source="@DEFAULT_SINK@"

# TODO: Remove repetitions
mic_update() {
    mic_volume=$(pactl get-source-volume $mic_source | grep -Pow '\d{0,3}+%' | head -1)
    mic_muted=$(pactl get-source-mute $mic_source | grep -Pow "(yes|no)")

    if [[ -z "${mic_volume}" ]]; then
        echo "mic not found"
        exit 1
    fi
}

speaker_update() {
    speaker_volume=$(pactl get-sink-volume $speaker_source | grep -Pow '\d{0,3}+(?=%)' | head -1)
    speaker_muted=$(pactl get-sink-mute $speaker_source | grep -Pow "(yes|no)")

    if [[ -z "${speaker_volume}" ]]; then
        echo "speaker not found"
        exit 1
    fi
}

mic () {
    case "$1" in
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
            polybar-msg action "#mic.hook.1" > /dev/null
        ;;
        toggle)
            pactl set-source-mute   $mic_source toggle
            polybar-msg action "#mic.hook.1" > /dev/null
        ;;
        raise|inc)
            pactl set-source-mute   $mic_source 0
            pactl set-source-volume $mic_source +5%
            polybar-msg action "#mic.hook.1" > /dev/null
            canberra-gtk-play -i audio-volume-change -d "changeVolume"
        ;;
        lower|dec)
            pactl set-source-mute   $mic_source 0
            pactl set-source-volume $mic_source -5%
            polybar-msg action "#mic.hook.1" > /dev/null
            canberra-gtk-play -i audio-volume-change -d "changeVolume"
        ;;
        *)
            echo "Available commands: status, init, toggle, raise|inc, lower|dec"
        ;;
    esac
}

speaker () {
    case "$1" in
        init)
            pactl set-sink-volume $speaker_source 25%
            pactl set-sink-mute   $speaker_source 0
        ;;
        toggle)
            pactl set-sink-mute   $speaker_source toggle
        ;;
        raise|inc)
            pactl set-sink-mute   $speaker_source 0
            pactl set-sink-volume $speaker_source +5%
        ;;
        lower|dec)
            pactl set-sink-mute   $speaker_source 0
            pactl set-sink-volume $speaker_source -5%
        ;;
        *)
            echo "Available commands: status, init, toggle, raise|inc, lower|dec"
        ;;
    esac

    speaker_update

    if [[ "$speaker_muted" == "yes" || $speaker_volume == "0" ]]; then
        dunstify -a "changevolume"                      \
            -i speaker-off                              \
            -h string:x-dunst-stack-tag:$speaker_tag    \
            "Speaker" "Volume: <b>muted</b>"
    else
        if [ "$speaker_volume" -gt 0 ] && [ "$speaker_volume" -le 33 ]; then
            speaker_notif_state=low
        elif [ "$speaker_volume" -gt 33 ] && [ "$speaker_volume" -le 66 ]; then
            speaker_notif_state=medium
        else
            speaker_notif_state=high
        fi
        dunstify -a "changevolume"                    \
            -h string:x-dunst-stack-tag:$speaker_tag  \
            -h int:value:"$speaker_volume"            \
            -i "speaker-$speaker_notif_state"         \
            "Speaker" "Volume: <b>$speaker_volume%</b>"
    fi
    canberra-gtk-play -i audio-volume-change -d "changeVolume"
}

case "$1" in
    mic|speaker)
        "$1" "$2"
    ;;
    *)
        echo "available args: mic, speaker"
    ;;
esac
