# ### autocompletions ###
fpath=($__ZSH_CONFIG_DIR/completions $fpath)
autoload -U compinit && compinit
# autoload -Uz compinit
# compinit -u
# _add_fpath $ZSHC/completions/*


# kubectl stern
# source <(kubectl stern --completion zsh)
# complete -o default -F _stern kubectl stern
