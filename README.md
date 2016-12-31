```bash
alias home="git --work-tree=$HOME --git-dir=$HOME/.files.git"
home init
home remote add origin git@github.com:craigrw/dotfiles.git
home pull origin master
```
