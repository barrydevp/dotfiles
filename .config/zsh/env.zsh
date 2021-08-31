### GOLANG ###
if [[ $__ARCH = 'Darwin' ]]; then
  export GOROOT=/usr/local/go
fi
export GOPATH=$HOME/go # don't forget to change your path correctly!
export PATH=:$PATH

### RustLang ###
export CARGO_PATH="$HOME/.cargo"
export PATH=$CARGO_PATH/bin:$PATH

### FNM PATH ###
export FNM_PATH=$HOME/.fnm

### System ###
export USRLOCAL_PATH=/usr/local/bin

### PATH ###
export PATH=$USRLOCAL_PATH:$MYLOCAL/bin:$GOROOT/bin:$GOPATH/bin:$FNM_PATH:$PATH

### EDITOR ###
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

