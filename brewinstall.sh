#!/bin/zsh

dir=${0:a:h}

# Vérifie que le script est exécuté sur macOS
if [[ $(uname -s) != "Darwin" ]]; then
  echo "Ce script est destiné à macOS uniquement." >&2
  exit 1
fi

# Désactivation des .DS_Store sur le réseau
if [[ $(defaults read /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null) != 1 ]]; then
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
if [[ -f "$dir/brewinstall.apps.cfg" ]]; then
  brew install $(grep -v -E '^\s*#|^\s*$' "$dir/brewinstall.apps.cfg")
fi

# Installe les apps macOS (cask)
if [[ -f "$dir/brewinstall.cask.cfg" ]]; then
  brew install --cask $(grep -v -E '^\s*#|^\s*$' "$dir/brewinstall.cask.cfg")
fi

# Mise à jour et nettoyage
brew update && brew cleanup
