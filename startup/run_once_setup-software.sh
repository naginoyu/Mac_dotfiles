#!/bin/bash

set -e

# Apple Silicon Macの場合、HomebrewのPATHを通す
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Setting up software configurations and Tailscale..."

# ============================================
# Claude Code CLI
# ============================================
echo "Checking Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "Claude Code CLI is already installed."
fi

# ============================================
# mise - Node.js
# ============================================
echo "Checking mise..."
if ! command -v mise &> /dev/null; then
    echo "mise is not installed. It should be installed via Brewfile."
    exit 1
fi

echo "Installing latest Node.js via mise..."
mise use -g node@latest

# ============================================
# Tailscale
# ============================================
echo "Checking Tailscale..."
if ! command -v tailscale &> /dev/null; then
    echo "Tailscale is not installed. It should be installed via Brewfile."
    exit 1
fi

# Apple Silicon vs Intelでパスが異なる
if [[ "$(uname -m)" == "arm64" ]]; then
    TAILSCALE_DAEMON="/opt/homebrew/opt/tailscale/bin/tailscaled"
else
    TAILSCALE_DAEMON="/usr/local/opt/tailscale/bin/tailscaled"
fi

# システムデーモンをインストール（まだの場合）
if ! sudo launchctl list | grep -q "com.tailscale.tailscaled"; then
    echo "Installing Tailscale system daemon..."
    sudo "$TAILSCALE_DAEMON" install-system-daemon
fi

# Tailscaleサービスが実行中か確認
if ! sudo launchctl list | grep -q "com.tailscale.tailscaled"; then
    echo "Starting Tailscale service..."
    sudo brew services start tailscale
fi

# Tailscaleが既に接続されているか確認
if tailscale status &> /dev/null; then
    echo "Tailscale is already connected."
    tailscale status
else
    echo "Tailscale is not connected. Please run: sudo tailscale up --ssh"
    echo "This will open a browser for authentication."
fi

echo "Software configurations and Tailscale setup completed!"
