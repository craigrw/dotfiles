#!/usr/bin/env bash

set -o errexit
set -o pipefail

_macos_customizations () {
  # show all hidden files
  defaults write com.apple.finder AppleShowAllFiles YES
  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle YES
  # Always open everything in Finder's list view
  defaults write com.apple.Finder FXPreferredViewStyle Nlsv
  killall Finder

  # autohide dock
  defaults write com.apple.dock autohide -bool true
  # fade hidden apps in dock
  defaults write com.apple.dock showhidden -bool true
  # set dock autohide delay to 0 seconds
  defaults write com.apple.Dock autohide-delay -int 0
  killall Dock

  defaults write com.apple.screensaver askForPassword -bool true
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  defaults -currentHost write com.apple.screensaver moduleDict -dict-add path -string "/Library/Screen Savers/Google Featured Photos.saver"
  defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string "Google Featured Photos"

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

  # flycut 
  defaults write com.generalarcade.flycut loadOnStartup -bool true
  defaults write com.generalarcade.flycut removeDuplicates -bool true
  # Run the screensaver if we're in the bottom-left hot corner.
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0


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
  chmod +x $HOME/.bin/*
}



if [[ "$(uname)" == 'Darwin' ]]; then
  _macos_apps
  _macos_customizations
elif [[ "$(uname)" == 'Linux' ]]; then
  _linux_apps
fi

_general
