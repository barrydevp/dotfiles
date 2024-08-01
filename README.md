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

# install tmux first and using tmux for futher installing (cargo is very slow :()

# oh my tmux
# git clone https://github.com/gpakosz/.tmux.git
# ln -s -f .tmux/.tmux.conf
# cp .tmux/.tmux.conf.local .

# rust and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# exa & fd
cargo install exa
cargo install fd-find

# ripgrep
brew install ripgrep

# fzf
brew install fzf

# starship
# curl -sS https://starship.rs/install.sh | sh
brew install starship

# fnm
curl -fsSL https://fnm.vercel.app/install | bash

# clone dotfiles and setup alias
git clone --bare git@github.com:barrydevp/dotfiles.git $HOME/dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot checkout

# install font
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font

# install nvim
brew install neovim --HEAD

# icloud link
ln -s "/Users/$USER/Library/Mobile Documents/com~apple~CloudDocs" iCloud
## books
ln -s "/Users/$USER/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents" Books

```
