#!/usr/bin/env bash

export DEFAULT_USER=`whoami`

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR='vim'

export PATH="$PATH:$HOME/.bin"

if [[ -e $HOME/.nvm ]]; then
  export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"
fi

export DOCKER_HOST=tcp://10.11.12.13:2375

source "$HOME/.aliases"

test -e /usr/libexec/java_home && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
