#!/bin/bash

# Install yay
sudo pacman -S git base-devel
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install pkgs
yay -S --needed - < ~/pkgs

# Install fish plugins
fisher install franciscolourenco/done
fisher install gazorby/fish-abbreviation-tips
fisher install jorgebucaran/autopair.fish
fisher install andreiborisov/sponge
fisher install nickeb96/puffer-fish
# fisher install pure-fish/pure or
fisher install IlanCosman/tide@v5

# Install firewall
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable --now ufw.service

# Auto update mirrors (reflector)
rm /etc/xdg/reflector/reflector.conf
ln ~/.config/etc/reflector.conf /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector.service
