# Remove fish greeting
set fish_greeting

#
## Quick aliases
#

alias v="nvim"

# fancy ls
alias ls="lsd --group-dirs first"
alias ll="ls -lv"
alias la="ls -A"
alias lla="ls -lA"
alias lt="ls --tree"

alias df="df -h"
alias free="free -m"

alias ..="cd .."
alias ...="cd ../.."

alias grub-regen='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias pacman-orphaned="sudo pacman -Rns (pacman -Qtdq)" # Remove orphaned packages
alias pacman-purge="yay -Sc && yay -c" # Clear cache and unused packages


#
## Config files
#
alias modfish="v ~/.config/fish/config.fish"
alias modalacritty="v ~/.config/alacritty/alacritty.yml"
alias modvim="v ~/.config/nvim/init.vim"
alias modbspwm="v ~/.config/bspwm/bspwmrc"
alias modsxhkd="v .config/sxhkd/sxhkdrc"
alias modpolybar="v ~/.config/polybar"
alias modeww="v ~/.config/eww"

alias fishreload="source ~/.config/fish/config.fish"

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# temporary
alias 1280p='xrandr --output Virtual-1 --mode 1280x720 && bspc wm -r'
alias 1024p='xrandr --output Virtual-1 --mode 1024x768 && bspc wm -r'
alias 1920p='xrandr --output Virtual-1 --mode 1920x1080 && sleep 1 && bspc wm -r'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

export EDITOR="nvim"
export TERMINAL="alacritty"
export MANPAGER="nvim +Man!"
export MANWIDTH=999
