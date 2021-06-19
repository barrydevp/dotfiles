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
  zshc="$EDITOR $HOME/.zshrc" \
  zshs="exec zsh"
  # zshs="source $ZSHC/init.zsh"

### Dotfiles ###
alias \
  dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
