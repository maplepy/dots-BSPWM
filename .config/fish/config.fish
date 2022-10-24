# Remove fish greeting
set fish_greeting

#
## Quick aliases
#

alias v='nvim'

# fancy ls
alias ls='lsd --group-dirs first'
alias l='ls -lv'
alias la='ls -A'
alias ll='ls -lA'
alias lt='ls --tree'

alias df='df -h'
alias free='free -m'

alias ..='cd ..'
alias ...='cd ../..'

alias grub-regen='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias yayes='yay -Syu --sudoloop --noconfirm'
alias pacman-orphaned='sudo pacman -Rns (pacman -Qtdq)' # Remove orphaned packages
alias pacman-purge='yay -Sc && yay -c' # Clear cache and unused packages
alias mirror-update='curl -s "https://archlinux.org/mirrorlist/?country=FR&country=GB&country=DE&protocol=https&use_mirror_status=on" | sed -e "s/^#Server/Server/" -e "/^#/d" | rankmirrors -n 5 -'

alias gitpullrecursive='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
alias cleanemptydir='sudo find . -type d -empty -delete' # remove empty directories
alias pastehere='sleep 2; xdotool type "$(xclip -o -selection clipboard)"'

#
## Config files
#
alias modalacritty='v ~/.config/alacritty/alacritty.yml'
alias modbspwm='v ~/.config/bspwm/bspwmrc'
alias moddocker='v /docker/docker-compose.yml'
alias moddunst='v ~/.config/dunst/dunstrc'
alias modfish='v ~/.config/fish/config.fish'
alias modgit='v ~/.gitconfig'
alias modmpv='v ~/.config/mpv/'
alias modpicom='v ~/.config/picom/picom.conf'
alias modpolybar='v ~/.config/polybar'
alias modsxhkd='v ~/.config/sxhkd/sxhkdrc'
alias modvim='v ~/.config/nvim/init.vim'

alias fishreload='source ~/.config/fish/config.fish'

# Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# temporary
alias 1280p='xrandr --output Virtual-1 --mode 1280x720 && bspc wm -r'
alias 1024p='xrandr --output Virtual-1 --mode 1024x768 && bspc wm -r'
alias 1920p='xrandr --output Virtual-1 --mode 1920x1080 && sleep 1 && bspc wm -r'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# export PATH='":$PATH
export EDITOR='nvim'
export SUDO_EDITOR='vim'
export TERMINAL='alacritty'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
