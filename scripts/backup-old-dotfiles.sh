#!/bin/bash

# 既存dotfilesバックアップスクリプト
# 新しいマシンでchezmoiを適用する前に実行してください

set -e

# バックアップディレクトリを作成
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "🔄 Starting backup of existing dotfiles..."
echo "Backup directory: $BACKUP_DIR"
echo ""

# バックアップ対象のファイル
FILES=(
    ".zshrc"
    ".zprofile"
    ".gitconfig"
    ".Brewfile"
)

# 個別ファイルをバックアップ
BACKED_UP=0
for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/"
        echo "✅ Backed up: $file"
        BACKED_UP=$((BACKED_UP + 1))
    fi
done

# .configディレクトリをバックアップ
if [ -d "$HOME/.config" ]; then
    cp -r "$HOME/.config" "$BACKUP_DIR/"
    echo "✅ Backed up: .config/"
    BACKED_UP=$((BACKED_UP + 1))
fi

# Homebrewパッケージリストを保存
if command -v brew &> /dev/null; then
    echo ""
    echo "📦 Saving Homebrew package lists..."
    brew list --formula > "$BACKUP_DIR/brew_formula_list.txt"
    brew list --cask > "$BACKUP_DIR/brew_cask_list.txt"
    echo "✅ Saved: brew_formula_list.txt"
    echo "✅ Saved: brew_cask_list.txt"
fi

echo ""
echo "✨ Backup completed!"
echo "📁 Location: $BACKUP_DIR"
echo "📊 Backed up $BACKED_UP items"
echo ""
echo "Next steps:"
echo "  1. Review the backed up files"
echo "  2. Run: chezmoi init https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "  3. Run: chezmoi diff (to preview changes)"
echo "  4. Run: chezmoi apply (to apply changes)"
