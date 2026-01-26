#!/bin/bash

# macOS System Preferences Configuration
# This script applies macOS system defaults settings

set -e

echo "Configuring Finder settings..."

# 隠しファイルを常に表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# ファイル表示を常にリスト表示
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finderを再起動して設定を反映
killall Finder

echo "Finder settings applied successfully!"
