### PATH ###
export PATH=/usr/local/bin:$MYLOCAL/bin:$HOME/go/bin:$HOME/.fnm:$PATH

### GOLANG ###
# export GOPATH=$HOME/Desktop/Dev/go # don't forget to change your path correctly!
# export GOROOT=/usr/local/go
# export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

### RustLang ###
export CARGO_PATH="$HOME/.cargo"
export PATH=$CARGO_PATH/bin:$PATH

### EDITOR ###
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

### Your.rentals #
export COMPOSE_PROJECT_NAME=yr

