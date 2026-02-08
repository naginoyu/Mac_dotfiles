#!/bin/bash

# Machine type change script for chezmoi
# Usage: ./scripts/change-machine-type.sh

set -euo pipefail

CONFIG_FILE="$HOME/.config/chezmoi/chezmoi.toml"
AVAILABLE_TYPES=("desktop" "laptop")

# 設定ファイルが存在するか確認
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    echo "Please initialize chezmoi first."
    exit 1
fi

# 現在のマシンタイプを取得
CURRENT_TYPE=$(grep -A1 '^\[data\]' "$CONFIG_FILE" | grep 'machineType' | awk -F'"' '{print $2}' || echo "unknown")

echo "Current machine type: $CURRENT_TYPE"
echo ""

echo "Select machine type:"
echo "  1) desktop"
echo "  2) laptop"
echo ""
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        NEW_TYPE="desktop"
        ;;
    2)
        NEW_TYPE="laptop"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

if [ "$CURRENT_TYPE" = "$NEW_TYPE" ]; then
    echo "Machine type is already set to $NEW_TYPE"
    exit 0
fi

# マシンタイプを更新
echo ""
echo "Changing machine type from $CURRENT_TYPE to $NEW_TYPE..."

# 設定ファイルを更新
cat > "$CONFIG_FILE" <<EOF
[data]
    machineType = "$NEW_TYPE"
EOF

echo "✓ Machine type changed to $NEW_TYPE"
echo ""
echo "Run 'chezmoi apply' to update your packages"
