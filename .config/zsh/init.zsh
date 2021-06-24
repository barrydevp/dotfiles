### GLOBAL ###
export MYCONFIG=$HOME/.config
export MYLOCAL=$HOME/.local

### DECLARE ###
source $MYCONFIG/zsh/declare.zsh

### LOAD LOCAL ENV ###
[[ -n $__ZSH_CONFIG_DIR/local.zsh ]] && source $__ZSH_CONFIG_DIR/local.zsh

### LOAD ENV ###
source $__ZSH_CONFIG_DIR/env.zsh

### LOAD ALIAS ###
source $__ZSH_CONFIG_DIR/alias.zsh

### SETTING ###
source $__ZSH_CONFIG_DIR/setting.zsh

### KEYBINDING ###
source $__ZSH_CONFIG_DIR/keybinding.zsh

### LOAD FUNC ###
source $__ZSH_CONFIG_DIR/func/init.zsh

