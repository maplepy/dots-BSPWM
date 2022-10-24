#!/bin/sh

steamlib=/mnt/games/SteamLibrary/
mygames=$(find $steamlib/steamapps/appmanifest_*.acf | sed 's/[^0-9]*//g')    # this sed command removes everything but the digits
game_count=0

for game in $mygames; do
    bspc rule -a steam_app_"$game" desktop=^8
    game_count=$((game_count + 1))
    echo $game
done

echo "Games set: $game_count"
