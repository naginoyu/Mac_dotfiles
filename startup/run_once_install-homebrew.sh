#!/bin/bash

# Homebrewが既にインストールされているか確認
if command -v brew &> /dev/null; then
    echo "Homebrew is already installed."
    exit 0
fi

# Homebrewをインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon Macの場合、PATHを追加
if [[ "$(uname -m)" == "arm64" ]]; then
    if ! grep -q '/opt/homebrew/bin/brew' "$HOME/.zshrc"; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo "Homebrew installed successfully."
