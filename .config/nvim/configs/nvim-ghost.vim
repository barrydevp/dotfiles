" Multiple autocommands can be specified like so -
augroup nvim_ghost_user_autocommands
  au User www.reddit.com,www.stackoverflow.com setfiletype markdown
  au User www.reddit.com,www.github.com setfiletype markdown
  au User *github.com setfiletype markdown
  au User *overleaf.com setfiletype tex
augroup END
