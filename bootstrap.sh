#!/usr/bin/env bash

# Check for Homebrew,
# Install if we don't have it
if [ ! $(which brew) ]; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed ($(which brew))"
fi

# copy brewfile
# brew bundle --global



# macos defaults
defaults write com.apple.finder AppleShowAllFiles YES
# keyboard Key Repeat
# keyboard Delay Until Repeat
# trackpad Secondary Click - Tap with two fingers

