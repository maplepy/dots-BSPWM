#!/bin/bash

dunstify -i audio-off -u low -h int:value:20 "Test 1" "Value to 20%"
dunstify -i media-playback-pause -u normal -h int:value:50 "Test 1" "Value to 50%"
dunstify -i mic-pause -u normal -h int:value:75 "Test 1" "Value to 75%"
dunstify -i battery-caution -u critical -h int:value:20 "Test 1" "Value to 1"
dunstify -h string:x-dunst-stack-tag:test "Replace" "First notification going to be replaced"
dunstify --action="replyAction,reply" "Message received"
dunstify -h string:x-dunst-stack-tag:test "Replaced" "correctly replaced!"
dunstify -p "print me id"
dunstify -t 10000 "long ass timeout"
