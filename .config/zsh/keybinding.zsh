### vi mode ###
# bindkey -rp ''
# bindkey -v
# bindkey "^F" vi-cmd-mode
bindkey "^[" vi-cmd-mode

# default binding
# unbind fuckin idiot map
# bindkey -r "^[h"
# bindkey -r "^[i"
# bindkey -r "^[j"
# bindkey -r "^[l"

# Standard and additional keybindings
#
# Find the key with: showkey -a
#
#   ctrl + u     : clear line
#   ctrl + w     : delete word backward
#   alt  + d     : delete word ctrl + a     : move to beginning of line
#   ctrl + e     : move to end of line (e for end)
#   alt/ctrl + f : move to next word (f for forward)
#   alt/ctrl + b : move to previous word (b for backward)
#   ctrl + d     : delete char at current position (d for delete)
#   ctrl + k     : delete from character to end of line
#   alt  + .     : cycle through previous args

### KEY MAP ###
# bindkey "^A" beginning-of-line
# bindkey "^E" end-of-line
# bindkey "^K" kill-line
# bindkey "^R" history-incremental-search-backward
# bindkey "^S" history-incremental-search-forward
# # bindkey "^Y" accept-and-hold
# # bindkey "^N" insert-last-word
# bindkey "^Q" push-line-or-edit

# # ctrl+b/f or ctrl+left/right: move word by word (backward/forward)
# bindkey '^b' backward-word
# bindkey '^f' forward-word
# bindkey '^[[1;5D' backward-word
# bindkey '^[[1;5C' forward-word
# bindkey "^H" backward-char
# bindkey "^L" forward-char
#
# # ctrl+backspace: delete word before
# bindkey '^H' backward-kill-word
# # ctrl+delete: delete word after
# bindkey "\e[3;5~" kill-word
#

# search and also insert the result
bindkey "^N" down-line-or-beginning-search # Down
bindkey "^P" up-line-or-beginning-search # Up
# # not insert the result 
# bindkey "^P" history-beginning-search-backward
# bindkey "^N" history-beginning-search-forward
