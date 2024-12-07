### GLOBAL ###
export MYCONFIG=$HOME/.config
export MYLOCAL=$HOME/.local
export __ARCH=$(uname)
export XDG_CONFIG_HOME=$HOME/.config

### DECLARE ###
source $MYCONFIG/zsh/declare.zsh

### UTILS ###
source $MYCONFIG/zsh/utils.zsh

### LOAD LOCAL ENV ###
[[ -f $__ZSH_CONFIG_DIR/local.zsh ]] && source $__ZSH_CONFIG_DIR/local.zsh

### LOAD PRIVATE ENV ###
[[ -f $__ZSH_CONFIG_DIR/_pri_env.zsh ]] && source $__ZSH_CONFIG_DIR/_pri_env.zsh

### LOAD ENV ###
source $__ZSH_CONFIG_DIR/env.zsh

### LOAD ALIAS ###
source $__ZSH_CONFIG_DIR/alias.zsh

### SETTING ###
source $__ZSH_CONFIG_DIR/setting.zsh

### AUTOCOMPLETE ###
source $__ZSH_CONFIG_DIR/completion.zsh

### KEYBINDING ###
source $__ZSH_CONFIG_DIR/keybinding.zsh

### LOAD FUNC ###
source $__ZSH_CONFIG_DIR/func/init.zsh

