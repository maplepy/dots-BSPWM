#!/usr/bin/env bash

# Focus the window
xdotool search --class dota windowactivate

# Move to the ready button
sleep 0.5
xdotool mousemove 930 540
xdotool click 1

# Notify
notify-send Dota "You are now ready to go!"