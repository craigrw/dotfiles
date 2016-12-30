#!/usr/bin/env bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR='vim'

export PATH="$PATH:$HOME/.bin:/usr/local/share/python"

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"

source "$HOME/.aliases"

test -e /usr/libexec/java_home && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
