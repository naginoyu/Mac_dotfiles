# 別のマシンへの移行ガイド

このガイドは、既存のdotfilesがあるマシンに、このchezmoiリポジトリを適用する手順を説明します。

## 前提条件

- macOS環境
- 既存のdotfilesやHomebrewパッケージがある可能性がある
- データを失いたくない

## 移行手順

### ステップ1: 既存dotfilesのバックアップ

既存の設定ファイルをバックアップします。

```bash
# バックアップディレクトリを作成
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 主要なdotfilesをバックアップ
for file in .zshrc .zprofile .gitconfig .Brewfile; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/"
        echo "Backed up: $file"
    fi
done

# .configディレクトリもバックアップ
if [ -d "$HOME/.config" ]; then
    cp -r "$HOME/.config" "$BACKUP_DIR/"
    echo "Backed up: .config/"
fi

echo "Backup completed at: $BACKUP_DIR"
```

### ステップ2: Homebrewパッケージのリストを保存

現在インストールされているパッケージをリストアップします（後で必要に応じて復元可能）。

```bash
# インストール済みパッケージをリスト化
brew list --formula > ~/brew_formula_backup.txt
brew list --cask > ~/brew_cask_backup.txt

echo "Homebrew package lists saved:"
echo "  - ~/brew_formula_backup.txt"
echo "  - ~/brew_cask_backup.txt"
```

### ステップ3: chezmoiのインストール

Homebrewが既にインストールされている場合:

```bash
brew install chezmoi
```

Homebrewがない場合は、ステップ4で自動的にインストールされます。

### ステップ4: chezmoiリポジトリから初期化

```bash
# GitHubリポジトリから初期化（URLは自分のリポジトリに変更してください）
chezmoi init https://github.com/naginoyu/Mac_dotfiles.git

# 変更内容を確認（実際にファイルを変更する前に確認）
chezmoi diff
```

### ステップ5: 変更を適用

```bash
# 変更を適用（既存ファイルは上書きされます）
chezmoi apply -v
```

このコマンドで以下が自動的に実行されます:

1. **Homebrewのインストール** (未インストールの場合)
2. **Brewfileからパッケージインストール**
3. **mise経由でNode.js、Pythonをインストール**
4. **Tailscaleのセットアップ**
5. **macOS設定の適用** (Finder設定など)

### ステップ6: 手動設定

以下は手動で設定する必要があります:

#### Tailscaleの認証

```bash
sudo tailscale up --ssh
```

ブラウザが開くので、アカウントで認証してください。

#### VSCode拡張機能

VSCode拡張機能は自動的にインストールされますが、VSCodeを再起動する必要があります。

```bash
code --list-extensions  # インストール確認
```

## トラブルシューティング

### `chezmoi apply`でエラーが出る

```bash
# 強制的に上書き
chezmoi apply --force

# 個別ファイルのみ適用
chezmoi apply ~/.zshrc
```

### Homebrewパッケージの競合

```bash
# Brewfileと現在のインストール状況の差分を確認
brew bundle check --file="$HOME/.Brewfile"

# 不要なパッケージを削除（慎重に！）
brew bundle cleanup --file="$HOME/.Brewfile"
```

### 既存設定との統合

バックアップした設定ファイルから、必要な部分を手動でマージします。

```bash
# バックアップと現在の設定を比較
diff "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
```

## Brewfileの更新

新しいパッケージをインストールした後は、Brewfileを更新してください。

```bash
cd $(chezmoi source-path)
brew bundle dump --force --describe --file=dot_Brewfile
chezmoi add ~/.Brewfile
chezmoi cd
git add dot_Brewfile
git commit -m "Update Brewfile"
git push
```

## 参考リンク

- [chezmoi公式ドキュメント](https://www.chezmoi.io/)
- [Homebrew Bundler](https://github.com/Homebrew/homebrew-bundle)
