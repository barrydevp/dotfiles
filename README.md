# dotfiles

## INSTALL

```bash
echo ".cfg" >> .gitignore
git clone --bare git@github.com:barrydevp/dotfiles.git $HOME/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout"
exec zsh
```
