# ZSH CONFIG STRUCTURE

### The order of calling init is shown as below

```c
zsh
  - init.zsh // init zsh config was called from .zshrc
  - declare.zsh // declare variable, local, global -> Standard: local variable with prefix "__"
  - env.zsh // env like PATH, ...
  - alias.zsh // Alias
  - setting.zsh // load user setting, 3rd setting like completions
  - compleions
    - _* // completions scripts
  - keybinding.zsh // load keybinding
  - func
     - init.zsh // init the function
     *.sh // functions
```
