# Make sure to always use gpg2
alias gpg=gpg2

# One neovim to rule them all
alias vim=nvim

# Allow easier dotfiles management with git in $HOME
alias config='$(which git) --git-dir=$HOME/dotfiles --work-tree=$HOME'
