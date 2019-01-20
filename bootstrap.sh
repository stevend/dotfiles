#!/usr/bin/env bash

echo "Requesting sudo password..."
sudo -v
echo

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### OS Prep
# Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating macOS.  If this requires a restart, run the script again."
# Install all available updates
sudo softwareupdate -ia
# Install only recommended available updates
#sudo softwareupdate -ir

echo "------------------------------"
echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

### Brew
# Check for Homebrew,
# Install if we don't have it
if [ ! $(which brew) ]; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed ($(which brew))"
fi

# brew update
# brew upgrade --all

echo
echo "Running brew bundle..."
echo
brew bundle

# brew cleanup

# Set OS settings and defaults
echo "Setting macOS settings and defaults..."

# Finder
defaults write com.apple.finder AppleShowAllFiles YES
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Dock" "Finder"; do
    killall "${app}" > /dev/null 2>&1
done

###############################################################################
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

echo
echo "Bootstrap finished!"
