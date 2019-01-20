#!/usr/bin/env bash

echo "=================================================="
echo "============= macOS Bootstrap script ============="
echo "=================================================="

### Request sudo password so the script has access to do the things
echo
echo "Requesting sudo password..."
sudo -v
echo

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


echo "----------------------------------------------"
echo "- XCode tools and Software updates"
echo "----------------------------------------------"
echo
echo "* Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

echo "* Running softwareupdate. If this requires a restart, run the script again."
# Install all available updates
sudo softwareupdate -ia
# Install only recommended available updates
#sudo softwareupdate -ir

echo
echo "----------------------------------------------"
echo "- Homebrew"
echo "----------------------------------------------"
echo
echo "* Install/Update Homebrew"
# Check for Homebrew, Install if we don't have it
if [ ! $(which brew) ]; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed ($(which brew))"
fi

echo
# echo "* Running 'brew update' ..."
# brew update

# echo "* Running 'brew upgrade --all' ..."
# brew upgrade --all

echo "* Running 'brew bundle' ..."
echo
brew bundle

# echo "* Running 'brew cleanup' ..."
# brew cleanup

echo
echo "----------------------------------------------"
echo "- macOS defaults"
echo "----------------------------------------------"
echo

# Set OS settings and defaults
echo "* Setting macOS settings and defaults..."

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

# Kill affected applications (for settings to take effect)
for app in "Dock" "Finder"; do
    killall "${app}" > /dev/null 2>&1
done

# echo
# echo "----------------------------------------------"
# echo "- Configure Zsh Shell"
# echo "----------------------------------------------"
# echo

# Set zsh as default shell
echo "* Set zsh as the shell"
# Add zsh path to list of allowable shells
sudo echo "$(which zsh)" >> /etc/shells
# Change shell to zsh
chsh -s $(which zsh)

# Install oh-my-zsh framework
echo "* Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy zsh custom settings
cp aliases.zsh ~/.oh-my-zsh/custom/
cp my-zsh-custom.zsh ~/.oh-my-zsh/custom/

# Copy
# Install Sublime Text settings
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

echo
echo "* Bootstrap finished!"
