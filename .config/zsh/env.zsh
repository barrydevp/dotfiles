### GOLANG ###
# export GOROOT= # the goroot path is setup in the local.zsh file due to different machines
export GOPATH=$HOME/go # don't forget to change your path correctly!
export PATH=$GOPATH/bin:$PATH

### RustLang ###
export CARGO_PATH="$HOME/.cargo"
export PATH=$CARGO_PATH/bin:$PATH

# ### FNM PATH ###
# export FNM_LEGACY_PATH=$HOME/.fnm
# export FNM_PATH=$HOME/.local/share/fnm

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end


### System ###
export USRLOCAL_PATH=/usr/local/bin

### PATH ###
export PATH=$USRLOCAL_PATH:$MYCONFIG/bin:$MYLOCAL/bin:$PATH

### EDITOR ###
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

### Kubernetes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

