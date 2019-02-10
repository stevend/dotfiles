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
  echo "Installing homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed ($(which brew))"
fi

echo
echo "* Running 'brew update' ..."
brew update

echo "* Running 'brew upgrade --all' ..."
brew upgrade --all

echo
echo "* Running 'brew bundle' ..."
brew bundle

echo
echo "* Running 'brew cleanup' ..."
brew cleanup

echo
echo "* Starting services"
brew services start redis
brew services start postgresql

# extra setup needed for postgres...
# create db for your user
# > createdb `whoami`
# create postres user
# > createuser -s postgres

echo
echo "----------------------------------------------"
echo "- macOS defaults"
echo "----------------------------------------------"
echo

# Set OS settings and defaults
echo "* Setting macOS settings and defaults ..."

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

# Fix macOS Mojave Font Rendering Issue - https://ahmadawais.com/fix-macos-mojave-font-rendering-issue/
defaults write -g CGFontRenderingFontSmoothingDisabled -bool FALSE

# Kill affected applications (for settings to take effect)
for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

echo
echo "----------------------------------------------"
echo "- Configure Zsh Shell"
echo "----------------------------------------------"
echo

# Set zsh as default shell
echo "* Set zsh as the shell ..."
# Add zsh path to list of allowable shells
sudo sh -c "echo $(which zsh) >> /etc/shells"
# Change shell to zsh
chsh -s $(which zsh)

# Install oh-my-zsh framework
echo "* Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# copy zsh custom settings
cp aliases.zsh ~/.oh-my-zsh/custom/
cp my-zsh-custom.zsh ~/.oh-my-zsh/custom/
cp rbenv.zsh ~/.oh-my-zsh/custom/

# Display notice about installing additional iterm2 color schemes
# echo "* You should install the Solarized color schemes for iterm2 so zsh looks better"
# echo "Color schemes have been included in solarized-dark.itermcolors and solarized-light.itermcolors"
# echo "See - https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized#installation for installation instructions"

# Copy
# Install Sublime Text settings
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

# rbenv
# initialize
eval "$(rbenv init -)"

# copy default gems file to rbenv root
cp rbenv-default-gems "$(rbenv root)/default-gems"


echo
echo "* Bootstrap finished!"
