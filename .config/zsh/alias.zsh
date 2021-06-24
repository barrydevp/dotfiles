### K8s ###
alias \
  k="kubectl" \
  kfwd="sudo kubefwd" \
  kx="kubectx" \
  kn="kubens"

### SSH ###
alias \
  ssh="TERM=xterm-256color ssh"

### ZSH ###
alias \
  zshc="cd $__ZSH_CONFIG_DIR && $EDITOR $HOME/.zshrc" \
  zshs="exec zsh"
  # zshs="source $ZSHC/init.zsh"

### Dotfiles ###
alias \
  dotfile='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

### Neovim ###
alias \
  nvimc="cd $__NVIM_CONFIG_DIR && $EDITOR init.lua"
