### 3rd Package ###
# fnm bootstrap
eval "$(_exec_safe fnm env)"
# starship bootstrap
eval "$(_exec_safe starship init zsh)"

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

