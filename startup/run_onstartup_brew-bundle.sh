#!/bin/bash

# Apple Silicon Macの場合、HomebrewのPATHを通す
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrewがインストールされているか確認
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please run install-homebrew first."
    exit 1
fi

# Brewfileの場所
BREWFILE="$HOME/.Brewfile"

# Brewfileが存在するか確認
if [ ! -f "$BREWFILE" ]; then
    echo "Brewfile not found at $BREWFILE"
    exit 1
fi

# brew bundleを実行
echo "Installing packages from Brewfile..."
brew bundle --file="$BREWFILE"

echo "Brew bundle completed successfully."
