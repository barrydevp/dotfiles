### 3rd Package ###
# fnm bootstrap
eval "$(_exec_safe fnm env)"
# starship bootstrap
# eval "$(_exec_safe starship init zsh)"
# fzf bootstrap
eval "$(_exec_safe fzf --zsh)"
export FZF_DEFAULT_OPTS="\
--reverse \
--border rounded \
--no-info \
--pointer='👉' \
--marker=' ' \
--ansi \
--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic'"
export FZF_TMUX_OPTS="-p 55%,60%"
export FZF_CTRL_R_OPTS="--border-label=' history ' \
--prompt='  '"
# zoxide(alternative cd for frequently used path) bootstrap
eval "$(_exec_safe zoxide init zsh)"
# atuin(history search) bootstrap
eval "$(_exec_safe atuin init zsh --disable-up-arrow)"
# GH copilot CLI
eval "$(_exec_safe gh copilot alias -- zsh)"

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

