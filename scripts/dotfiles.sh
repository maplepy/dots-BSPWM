#!/usr/bin/env bash

dots_cmd="/usr/bin/git --git-dir=$HOME/$folder/ --work-tree=$HOME"

read -rep "Dotfiles folder name: " -i ".dotfiles" folder
read -rp "Git repo: " repo

if [[ -n "$repo" ]]; then
    # echo "Initialising dotfiles folder to $HOME/$folder/"

    printf "\nAdding exception for git\n"
    echo "$folder" >> "$HOME/.gitignore"

    printf "Cloning the dotfiles repo\n"
    git clone --bare "$1" "$HOME/dotfiles"
    $dots_cmd config --local status.showUntrackedFiles no

    printf "\nSuccessfully initialised the dotfiles repo\n"
    $dots_cmd checkout

    printf "\nNow you'll need to add an alias to your shell:\n"
    printf "alias config='/usr/bin/git --git-dir=%s/%s/ --work-tree=%s'" "$HOME" "$folder" "$HOME"
else
    printf "\nYou need to provide the repo to initialise the dotfiles"
fi
