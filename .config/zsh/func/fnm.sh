fnmu() {
  fnm use $(fnm list | fzf | awk '{print $2}')
}

fnmi() {
  fnm install $(fnm list-remote | fzf | awk '${print $1}')
}

