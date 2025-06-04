# Git Worktree を使った Claude Code の並行稼働

このリポジトリは、git worktree を使用して複数の Claude Code インスタンスを並行稼働させる実験環境です。

## 概要

Git worktree を使用することで、同じリポジトリから複数のブランチを異なるディレクトリにチェックアウトし、それぞれで独立した Claude Code セッションを実行できます。これにより、複数の機能開発やバグ修正を同時に進めることが可能になります。

## メリット

- 各 worktree は独立したファイル状態を持つ
- Claude インスタンス間での干渉を防ぐ
- 異なるブランチでの並行開発が可能
- 同じ Git 履歴とリモート接続を共有

## セットアップ方法

### 1. 新しい worktree を作成

```bash
# 新しいブランチと共に worktree を作成
git worktree add worktrees/feature-a -b feature-a

# 既存のブランチで worktree を作成
git worktree add worktrees/bugfix-123 bugfix-123
```

### 2. 各 worktree で Claude Code を実行

```bash
# ターミナル 1
cd worktrees/feature-a
claude

# ターミナル 2  
cd worktrees/bugfix-123
claude
```

## 実験環境の構成

このリポジトリには以下の worktree が設定されています：

- `main` - メインブランチ（ルートディレクトリ）
- `worktrees/feature-a` - feature-a ブランチ用
- `worktrees/bugfix-123` - bugfix-123 ブランチ用

## 使用例

1. **機能開発と並行してバグ修正を行う**
   - `feature-a` worktree で新機能を開発
   - 同時に `bugfix-123` worktree で緊急のバグ修正

2. **異なるアプローチの検証**
   - 複数の worktree で異なる実装アプローチを試す
   - 最適な解決策を選択してマージ

## 注意事項

- 各 worktree は独立していますが、同じ Git リポジトリを共有しています
- worktree を削除する場合は `git worktree remove <path>` を使用してください
- 使用しなくなった worktree は定期的に整理することを推奨します

## worktree の管理

```bash
# 全ての worktree を確認
git worktree list

# worktree を削除
git worktree remove worktrees/feature-a

# 使用されていない worktree を整理
git worktree prune
```

## 便利なスクリプト

このリポジトリには worktree 管理を簡単にするスクリプトが含まれています：

```bash
# 新しい worktree を作成して Cursor で開く
./scripts/create-worktree.sh user-auth feature

# worktree の一覧を見やすく表示
./scripts/list-worktrees.sh
```

## 関連ドキュメント

- [Git Worktree とは何か？](./WHAT_IS_GIT_WORKTREE.md) - Git worktree の基本概念
- [Cursor での Worktree 管理](./CURSOR_WORKTREE_MANAGEMENT.md) - Cursor エディタでの効率的な管理方法
- [実験ガイド](./EXPERIMENT_GUIDE.md) - 実践的な実験手順
- [Worktree と gitignore](./WORKTREE_GITIGNORE_GUIDE.md) - worktree ディレクトリの gitignore 設定について

## 参考資料

- [Anthropic Claude Code ドキュメント](https://docs.anthropic.com/en/docs/claude-code/tutorials)
- [Git Worktree 公式ドキュメント](https://git-scm.com/docs/git-worktree)