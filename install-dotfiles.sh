#!/bin/bash

REPO_NAME = dotfiles
REPO_URL = git@github.com:zann1x/$REPO_NAME.git

function config {
   $(which git) --git-dir=$HOME/$REPO_NAME/ --work-tree=$HOME $@
}

cd $HOME

$(which git) clone --bare $REPO_URL $HOME/$REPO_NAME

mkdir -p $REPO_NAME-backup

config checkout

if [ $? = 0 ]; then
  echo "Checked out dot files.";
else
  echo "Backing up pre-existing dot files.";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $REPO_NAME-backup/{}
fi

config checkout
config config status.showUntrackedFiles no
