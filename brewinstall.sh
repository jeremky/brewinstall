#!/bin/zsh -e

dir=${0:a:h}

# Désactivation des .DS_Store sur le réseau
if [[ $(defaults read /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores) = 0 ]]; then
  sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool true
fi

# Déterminer le chemin de Homebrew selon l'architecture
if [[ $(uname -m) == "arm64" ]]; then
  BREW_PATH="/opt/homebrew/bin/brew"
else
  BREW_PATH="/usr/local/bin/brew"
fi

# Installation de Brew
if ! command -v "$BREW_PATH" >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  grep -qF 'brew shellenv' "$HOME/.zprofile" || echo "eval \"\$($BREW_PATH shellenv)\"" >> "$HOME/.zprofile"
  eval "$($BREW_PATH shellenv)"
fi

# Installe les apps CLI
if [[ -f "$SCRIPT_DIR/brewinstall.apps.cfg" ]]; then
  brew install $(grep -v -E '^\s*#|^\s*$' "$SCRIPT_DIR/brewinstall.apps.cfg")
fi

# Installe les apps macOS (cask)
if [[ -f "$SCRIPT_DIR/brewinstall.cask.cfg" ]]; then
  brew install --cask $(grep -v -E '^\s*#|^\s*$' "$SCRIPT_DIR/brewinstall.cask.cfg")
fi

# Mise à jour et nettoyage
brew update && brew cleanup
