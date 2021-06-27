# export EDITOR=/usr/bin/vim
# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT4_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus
ibus-daemon -drx
setxkbmap -option ctrl:nocaps
. "$HOME/.cargo/env"
