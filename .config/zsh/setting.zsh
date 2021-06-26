### 3rd Package ###
eval "$(fnm env)"

### Utilities Func ###
#____________________#
function _load_sh() {
  for _file in $1; do
    source $_file
  done
}

function _add_fpath() {
  for _file in $1; do
    fpath+=$_file 
  done
}
#____________________#

### autocompletions ###
fpath+=$__ZSH_CONFIG_DIR/completions
autoload -Uz compinit
compinit -u
# _add_fpath $ZSHC/completions/*

