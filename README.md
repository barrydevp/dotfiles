# dotfiles

## INSTALL

```bash
git clone --bare git@github.com:barrydevp/dotfiles.git $HOME/dotfiles
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfile config --local status.showUntrackedFiles no
dotfile checkout
exec zsh
```
