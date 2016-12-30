#!/usr/bin/env bash

set -o errexit
set -o pipefail

_macos_customizations () {
  # show all hidden files
  defaults write com.apple.finder AppleShowAllFiles YES
  killall Finder

  # autohide dock
  defaults write com.apple.dock autohide -bool true
  # fade hidden apps in dock
  defaults write com.apple.dock showhidden -bool true
  # set dock autohide delay to 0 seconds
  defaults write com.apple.Dock autohide-delay -int 0
  killall Dock

  # enable safari developer menu
  defaults write com.apple.Safari IncludeDebugMenu 1

  # set default screen capture image format to png
  defaults write com.apple.screencapture type png

  defaults write com.apple.finder QLEnableTextSelection -bool true

  # set save dialog to column view
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'

  # update system settings
  killall SystemUIServer
}

_macos_apps () {
  xcode-select --install
  brew bundle --global
}

_linux_apps () {
  echo ''
}

_general () {
  chsh -s $(grep /zsh$ /etc/shells | tail -1)
}



if [[ "$(uname)" == 'Darwin' ]]; then
  _macos_apps
  _macos_customizations
elif [[ "$(uname)" == 'Linux' ]]; then
  _linux_apps
fi

_general