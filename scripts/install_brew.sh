#!/bin/bash
set -euo pipefail

# Install brew packages if Brewfile exists
if [ -f "$HOME/.Brewfile" ]; then
    echo "Installing brew packages..."
    brew bundle --file="$HOME/.Brewfile"
else
    echo "Brewfile not found"
fi