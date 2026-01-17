#!/bin/bash

# Homebrewが既にインストールされているか確認
if command -v brew &> /dev/null; then
    echo "Homebrew is already installed."
    exit 0
fi

# Homebrewをインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon Macの場合、現在のシェルセッションでPATHを通す
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Homebrew installed successfully."
