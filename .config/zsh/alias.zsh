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

### Webstorm ###
alias webstorm="open -na "WebStorm.app" --args ."
alias w="webstorm ."

### fnm ###

### exa, the Change Directory (cd) alternative ###
alias \
  ls="exa --icons --group-directories-first" \
  ll="exa -lgh --icons --group-directories-first" \
  la="exa -lgha --icons --group-directories-first"

### lazygit ###
alias \
  lg="lazygit"

### Your.rentals
alias \
  cdyr="cd $HOME/yr" \

### AWS - EKS
alias \
  awscre="nvim ~/.aws/credentials" \
  eksqa="eksctl utils write-kubeconfig --cluster=qa-ce --profile=qa-plf" \
  eksstag="eksctl utils write-kubeconfig --profile=463318169756_EKS-maintainer" \
  eksprod="eksctl utils write-kubeconfig --profile=575772817895_EKS-pods-viewer"

