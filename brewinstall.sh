#!/bin/zsh -e

dir=$(dirname "$0")

# Désactivation des .DS_Store sur le réseau
if [[ $(defaults read /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores) = 0 ]]; then
  sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool true
fi

# Activation de la commande locate
if [[ $(sudo launchctl list | grep -c "com.apple.locate") -eq 0 ]]; then
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
fi

# Déterminer le chemin de Homebrew selon l'architecture
if [[ $(uname -m) == "arm64" ]]; then
  BREW_PATH="/opt/homebrew/bin/brew"
else
  BREW_PATH="/usr/local/bin/brew"
fi

# Installation de Brew
if [[ ! -f $BREW_PATH ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  grep -q 'brew shellenv' "$HOME/.zprofile" || echo "eval \"\$($BREW_PATH shellenv)\"" >>"$HOME/.zprofile"
  eval "$($BREW_PATH shellenv)"
else
  echo "Brew est déjà installé"
fi

# Installation des applications cli
brew install $(grep -v '#' "$dir/brewinstall.apps.config")

# Installation des applications MacOS
brew install --cask $(grep -v '#' "$dir/brewinstall.cask.config")
