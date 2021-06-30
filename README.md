# dotfiles

## INSTALL

```bash
git clone --bare git@github.com:barrydevp/dotfiles.git $HOME/dotfiles
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfile config --local status.showUntrackedFiles no
dotfile checkout

npm install --global typescript typescript-language-server prettier vscode-html-languageserver-bin vscode-css-languageserver-bin bash-language-server

exec zsh
```
