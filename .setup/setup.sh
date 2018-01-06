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

  # Tap to click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  # Tap with two fingers to emulate right click
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
  # Enable three finger tap (look up)
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2
  # Enable three finger drag
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  # Zoom in or out
  defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
  # Smart zoom, double-tap with two fingers
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true
  # Rotate
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
  # Notification Center
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
  # Swipe between pages with two fingers
  defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
  # Swipe between full-screen apps
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
  # Enable other multi-finger gestures
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2

  defaults write com.apple.dock showMissionControlGestureEnabled -bool true
  defaults write com.apple.dock showAppExposeGestureEnabled -bool true
  defaults write com.apple.dock showDesktopGestureEnabled -bool true
  defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

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

_powerline_fonts () {
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts
}

_macos_apps () {
  xcode-select --install
  brew bundle --global
}

_linux_apps () {
  echo ''
}

_general () {
  _powerline_fonts

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
