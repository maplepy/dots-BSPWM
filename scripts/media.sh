#!/usr/bin/env bash

# Customisation
fav_player="spotify"
empty=""

#
### Functions
#

cmd="$0 metadata"
prefix="$0 prefix"

function scroll() {
	zscroll --length=60 \
		--delay 0.2 \
		--before-text "" \
		--scroll-padding="$(printf ' %.0s' {1..8})" \
		--scroll 1 \
		-M "$prefix" \
		-m "none" 	"-b ''" \
		-m "spotify Paused" 	"-b '%{F#1DB954} %{F#66EEEBFF}' --scroll 0" \
		-m "spotify Playing" 	"-b '%{F#1DB954} %{F-}'" \
		-m "mpv Paused" 		"-b '%{F#A552E6} %{F#66EEEBFF}' --scroll 0" \
		-m "mpv Playing" 		"-b '%{F#A552E6} %{F-}'" \
		-m "twitch Paused" 		"-b '%{F#A970FF}既 %{F#66EEEBFF}' --scroll 0" \
		-m "twitch Playing" 	"-b '%{F#A970FF}既 %{F-}'" \
		-m "netflix Paused" 	"-b '%{F#DE0914}ﱄ %{F#66EEEBFF}' --scroll 0" \
		-m "netflix Playing" 	"-b '%{F#DE0914}ﱄ %{F-}'" \
		-m "vlc Paused" 		"-b '%{F#F58808}嗢 %{F#66EEEBFF}' --scroll 0" \
		-m "vlc Playing" 		"-b '%{F#F58808}嗢 %{F-}'" \
		-m "corridor Paused" 	"-b '%{F#ACA8C4} %{F#66EEEBFF}' --scroll 0" \
		-m "corridor Playing" 	"-b '%{F#ACA8C4} %{F-}'" \
		-m "kdeconnect Paused" 	"-b '%{F#ACA8C4} %{F#66EEEBFF}' --scroll 0" \
		-m "kdeconnect Playing" "-b '%{F#ACA8C4} %{F-}'" \
		-m "firefox Paused" 	"-b '%{F#FE932E} %{F#66EEEBFF}' --scroll 0" \
		-m "firefox Playing" 	"-b '%{F#FE932E} %{F-}'" \
		-m "youtube Paused" 	"-b '%{F#E50000}  %{F#66EEEBFF}' --scroll 0" \
		-m "youtube Playing" 	"-b '%{F#E50000}  %{F-}'" \
		-m "prime Paused" 		"-b '%{F#01B0E0} %{F#66EEEBFF}' --scroll 0" \
		-m "prime Playing" 		"-b '%{F#01B0E0} %{F-}'" \
		--update-check true "$cmd" 2>/dev/null &
	wait
}

### Check which player to use
for player in $(playerctl -l 2>/dev/null); do
	# echo "${player} available"
	player_status=$(playerctl -p "$player" status 2>/dev/null)

	# get the ones playing
	if [ "$player_status" = "Playing" ]; then
		playing=1

		# if fav player set and playing stop the search and use it
		if [[ -n "${fav_player}" ]] && [[ "${player}" == "${fav_player}"* ]]; then
			top_player=$fav_player
			fav=1

		# if player is not fav
		elif [[ "$fav" != 1 ]]; then
			top_player=$player
			fav=0
			# echo "play: $top_player"
		fi

	# if none playing but paused
	elif [ "$player_status" = "Paused" ] && [ "$playing" != 1 ]; then
		playing=0

		# if fav player set and paused, use it
		if [[ -n "${fav_player}" ]] && [[ "${player}" == "${fav_player}"* ]]; then
			top_player=$fav_player
			fav=1

		# no fav used & paused, don't change the player
		elif [[ "$fav" != 1 ]]; then
			top_player=$player
			fav=0
			# break
			# elif [[ -z "$top_player" ]]; then
			# 	top_player=$player
			# 	fav=0
			# 	echo "top empty: use $top_player"
			# echo "empty string"
		fi
	fi
done

# Get the artist and title
title=$(playerctl -p "$top_player" metadata title 2>/dev/null)
artist=$(playerctl -p "$top_player" metadata artist 2>/dev/null)

# if player is weirdly formatted, make it constant
case "$top_player" in
"firefox"*) player_name=firefox ;;
"chromium"*) player_name=youtube ;;
*) player_name=$top_player ;;
esac
# echo "changing $top_player to $player_name"

# if no artist, try to get one
if [[ -z "${artist}" ]]; then
	# get the artist from the title
	case "${title}" in
	*"Uppbeat"*)
		if [[ "$title" == *"by"* ]]; then
			title=$(playerctl -p "$top_player" metadata title | sed -e 's/\Wby.*//g')
			artist=$(playerctl -p "$top_player" metadata title | sed -e 's/.*by\W//' -e 's/\W•.*//')
		else
			artist="Uppbeat"
			title="x"
		fi
		;;
	*Twitch)
		player_name="twitch"
		title=$(playerctl -p "$top_player" metadata title | sed 's/\W-.*//')
		artist="Twitch"
		;;
	*) ;;
	esac
fi

## Format the prefix for zscroll match command
function prefix() {

	# if there is a top player create the prefix
	if [[ -n "$top_player" ]]; then
		# get the top player and its status
		echo "$player_name $(playerctl -p "$top_player" status 2>/dev/null)"
		# echo "corridor Playing"
	else
		echo "none"
	fi
}

# Get title and artist info
function metadata() {
	if [[ -n "$top_player" ]]; then
		if [[ -z "${artist}" ]]; then
			# no artist
			echo "%{T2}$title"
		elif [[ -z "${title}" ]]; then
			echo "%{T3}$artist"
		else
			# output the artist and title
			echo "%{T3}$artist %{T2}- $title"
		fi
	else
		# no player
		echo "%{T2}$empty"
	fi
}

# interact with the media
function keys() {
	# get the command
	case "$2" in
	play | pause) cmd_arg="play-pause" ;;
	prev) cmd_arg="previous" ;;
	next) cmd_arg="next" ;;
	stop) cmd_arg="stop" ;;
	esac

	playerctl -p "$top_player" "$cmd_arg"
}

# get the vars
function debug() {
	echo ""
	echo "playing=$playing"
	echo "last player tested=$player status=$player_status"
	echo "fav=$fav fav_player=$fav_player "
	echo "top_player: $top_player"
	echo ""
	echo "cmd: $0"
	echo "arg 1: $1"
	echo "arg 2: $2"
}

# Get script argument
case "$1" in
scroll | metadata | prefix | last) $1 ;;
keys | debug) $1 "$@" ;;
*) echo "need some args" ;;
	# *) echo "no args" ;;
esac

### Play pause icons

#     Big ones
# 契    Small ones
#     Round filled inverse
#     Round empty

# # if no title nothing is playing
# if [[ -z "${title}" ]]; then
# 	echo "no title ? $empty"
# else
# 	# output the artist and title
# 	echo "%{T2}$artist - %{T2}$title"
# fi
