#!/bin/bash

# Install yay
sudo pacman -S --needed git bspwm sxhkd xorg-xinit
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
rm ~/yay/ -rf

# Install dotfiles
cd
read -rep "Dotfiles folder name: " -i ".dotfiles" folder
# read -rp "Git repo: " -i "https://github.com/maplepy/dots-BSPWM" repo
read -rp "Git repo: " -i "git@github.com:maplepy/dots-BSPWM.git" repo
dots_cmd="/usr/bin/git --git-dir=$HOME/$folder/ --work-tree=$HOME"

echo "Initialising dotfiles folder to $HOME/$folder/"
printf "\nAdding exception for git\n"
echo "$folder" >> "$HOME/.gitignore"

printf "Cloning the dotfiles repo\n"
git clone --bare "$repo" "$HOME/$folder"
$dots_cmd config --local status.showUntrackedFiles no

printf "\nSuccessfully initialised the dotfiles repo\n"
$dots_cmd checkout

# Use color for pacman and yay
sudo sed -i 's/#Color/Color/' /etc/pacman.conf

# Install pkgs
cd dots-bspwm
yay -S --sudoloop --noconfirm --needed - < pkgs

# Change shell to fish for user and root
chsh -s /bin/fish
sudo chsh -s /bin/fish

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

# Git config
printf "\n\n"
read -rp "Github mail: " -i "github." github_mail
ssh-keygen -t ed25519 -C "$github_mail"

open "https://github.com/settings/keys"
$dots_cmd remote set-url origin git@github.com:maplepy/dots-bspwm
.git

# Auto update mirrors (reflector)
sudo rm /etc/xdg/reflector/reflector.conf
sudo ln ~/.config/etc/reflector.conf /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector.service

# Disable lightdm and use ly
sudo systemctl disable --now lightdm
sudo systemctl enable --now ly

# Reload BSPWM and notify user
bspc wm -r && notify-send Installation "Installation should be complete now"