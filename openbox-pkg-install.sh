yay -S lightdm lightdm-gtk-greeter xorg-server xorg-apps xorg-xinit

yay -S rsync python psmisc xorg-xprop xorg-xwininfo imagemagick ffmpeg wireless_tools openbox \
pulseaudio pulseaudio-alsa alsa-utils brightnessctl nitrogen dunst tint2 gsimplecal rofi \
qt5-styleplugins lxsession xautolock rxvt-unicode xclip scrot thunar thunar-archive-plugin \
thunar-volman ffmpegthumbnailer tumbler viewnior pavucontrol parcellite \
neofetch w3m htop picom-git obmenu-generator gtk2-perl playerctl xsettingsd

sudo pacman -S zsh &&
chsh -s $(command -v zsh) &&
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &&
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

cd ~/Documents/ && git clone https://github.com/owl4ce/dotfiles.git
rsync -avxHAXP --exclude '.git*' --exclude 'LICENSE' --exclude '*.md' dotfiles/ ~/

pushd ~/.icons/ &&
    tar -Jxvf Papirus-Custom.tar.xz && tar -Jxvf Papirus-Dark-Custom.tar.xz &&
    sudo ln -vs ~/.icons/Papirus-Custom /usr/share/icons/Papirus-Custom &&
    sudo ln -vs ~/.icons/Papirus-Dark-Custom /usr/share/icons/Papirus-Dark-Custom &&
popd

fc-cache -rv

sudo chmod u+s $(command -v brightnessctl)

[ "$(readlink /bin/sh)" != "bash" ] && sudo ln -vfs bash /bin/sh

