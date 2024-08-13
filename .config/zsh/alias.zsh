### Shell ###
alias \
  c="clear" \
  e="exit"

### K8s ###
alias \
  k="kubectl" \
  kfwd="sudo kubefwd" \
  kx="kubectl ctx" \
  kn="kubectl ns"

### SSH ###
alias \
  ssh="TERM=xterm-256color ssh"

### ZSH ###
alias \
  zshs="exec zsh"
  # zshc="cd $__ZSH_CONFIG_DIR && $EDITOR $HOME/.zshrc" \
  # zshs="source $ZSHC/init.zsh"

### Dotfiles ###
alias \
  dot='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
  # dotc='cd $MYCONFIG && $EDITOR ../README.md'
  

### Neovim ###
alias \
  n="nvim"
  # nvimc="cd $__NVIM_CONFIG_DIR && $EDITOR init.lua"

### TMUX ###
# alias \
#   tmuxc="cd ~ && $EDITOR .tmux.conf"

### ZOXIDE ###
alias \
  z="zoxide" \
  za="zoxide add" \
  zrm="zoxide remove" \
  zad="/bin/ls -d */ | xargs -I {} zoxide add {}"

### Obsidian ###
# alias \
#   nn="cd  && nvim"

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
  eksqa="eksctl utils write-kubeconfig --cluster=qa-eks --profile=qa-plf" \
  eksplc="eksctl utils write-kubeconfig --cluster=dev-native --profile=qa-plc" \
  eksstag="eksctl utils write-kubeconfig --profile=463318169756_EKS-maintainer" \
  eksprod="eksctl utils write-kubeconfig --profile=575772817895_EKS-maintainer"

### Podman
alias \
  p="sudo podman" \
  po="podman" \
  sp="sudo podman"

### Docker
alias \
  dk="docker" \
  dkc="docker-compose"
