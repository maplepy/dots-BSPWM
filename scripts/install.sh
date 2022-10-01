#!/bin/bash

# Install yay
sudo pacman -S git base-devel
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install pkgs
yay -S --needed - < ~/pkgs

# Install fish shell
yay -S fish fisher
fisher install franciscolourenco/done
fisher install gazorby/fish-abbreviation-tips
fisher install jorgebucaran/autopair.fish
fisher install andreiborisov/sponge
fisher install nickeb96/puffer-fish
# fisher install pure-fish/pure or
fisher install IlanCosman/tide@v5


### Enable services

# Auto update mirrors
sudo systemctl enable --now reflector.service
