Pack up dot-files on one machine and deploy to another.

DONE:
- dotfiles packup
    - vim_handler
      - .vimrc
      - .vim/
    - bash_handler
      - .bashrc
      - .bash_config
    - tmux_handler
      - .tmux.conf
    - git_handler
      - .gitconfig
    - ssh_handler
      - .ssh/config & .ssh/ Keys
    - zsh_handler
      - .zshrc

TODO:
- user-specific scripts utils
- system-wide package installation



NOT-DONE

layout
```
build-from-source
.gdbinit
gdb
.config/nvim/...
.local
```

app-image
build-from-source
.local/bin/
.local/lib/
.local/share/
.local/include/

/usr/local/bin/
/usr/local/lib/
/usr/local/share/
/usr/local/include/
