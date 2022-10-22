source ./utils.zsh

_exec_safe echo "hello world"

_exec_safe fnm env

_exec_safe fnmm env

eval "$(_exec_safe fnm env)"
