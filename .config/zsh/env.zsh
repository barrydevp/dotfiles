### PATH ###
export PATH=$PATH:$MYLOCAL/bin:$HOME/go/bin:$HOME/.fnm

### EDITOR ###
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
