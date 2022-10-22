# dotfiles

## INSTALL

```bash

# install zsh first

# oh my zsh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
# omz plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# starship
curl -sS https://starship.rs/install.sh | sh

# fnm

# clone dotfiles and setup alias
git clone --bare git@github.com:barrydevp/dotfiles.git $HOME/dotfiles
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfile config --local status.showUntrackedFiles no
dotfile checkout

npm install --global typescript typescript-language-server prettier vscode-html-languageserver-bin vscode-css-languageserver-bin bash-language-server

exec zsh
```
