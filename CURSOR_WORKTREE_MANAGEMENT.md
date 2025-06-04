# Cursor エディタで Git Worktree を効率的に管理する方法

## 概要

Cursor エディタは AI 機能を搭載した VSCode ベースのエディタです。Git worktree と組み合わせることで、複数のブランチでの並行開発をより効率的に行うことができます。

## Cursor での Worktree 管理の基本

### 1. マルチウィンドウでの作業

Cursor では各 worktree を別々のウィンドウで開くことで、視覚的に分離された開発環境を構築できます。

```bash
# 各 worktree を Cursor で開く
cursor worktrees/feature-a
cursor worktrees/bugfix-123
```

### 2. ワークスペース設定

各 worktree に独自の `.vscode/settings.json` を配置することで、ブランチごとに異なる設定を適用できます。

```json
// worktrees/feature-a/.vscode/settings.json
{
  "window.title": "🚀 Feature A - ${activeEditorShort}",
  "workbench.colorTheme": "GitHub Dark Default",
  "workbench.colorCustomizations": {
    "activityBar.background": "#2a4e2a",
    "statusBar.background": "#2a4e2a"
  }
}
```

```json
// worktrees/bugfix-123/.vscode/settings.json
{
  "window.title": "🐛 Bugfix 123 - ${activeEditorShort}",
  "workbench.colorTheme": "GitHub Light Default",
  "workbench.colorCustomizations": {
    "activityBar.background": "#4e2a2a",
    "statusBar.background": "#4e2a2a"
  }
}
```

## 推奨する拡張機能

### 1. Git Graph
worktree 間の関係を視覚的に確認できます。

**インストール:**
```bash
cursor --install-extension mhutchie.git-graph
```

**使い方:**
- サイドバーの Git Graph アイコンをクリック
- 各 worktree のブランチが視覚的に表示される

### 2. GitLens
各 worktree での変更履歴を詳細に追跡できます。

**インストール:**
```bash
cursor --install-extension eamodio.gitlens
```

**Worktree 向け設定:**
```json
{
  "gitlens.views.repositories.showWorktrees": true,
  "gitlens.views.worktrees.showBranchComparison": true
}
```

### 3. Project Manager
複数の worktree を簡単に切り替えられます。

**インストール:**
```bash
cursor --install-extension alefragnani.project-manager
```

**プロジェクト設定:**
```json
// ~/Library/Application Support/Code/User/projects.json
[
  {
    "name": "MyProject - Main",
    "rootPath": "/path/to/project",
    "tags": ["main"],
    "enabled": true
  },
  {
    "name": "MyProject - Feature A",
    "rootPath": "/path/to/project/worktrees/feature-a",
    "tags": ["feature"],
    "enabled": true
  },
  {
    "name": "MyProject - Bugfix 123",
    "rootPath": "/path/to/project/worktrees/bugfix-123",
    "tags": ["bugfix"],
    "enabled": true
  }
]
```

## Cursor AI 機能との連携

### 1. コンテキストの分離

各 worktree で Cursor AI に異なるコンテキストを提供：

```markdown
<!-- worktrees/feature-a/.cursorrules -->
このプロジェクトは新機能 A の開発ブランチです。
以下の点に注意してください：
- 新しい API エンドポイントの追加
- 既存コードとの互換性維持
- パフォーマンスの最適化
```

```markdown
<!-- worktrees/bugfix-123/.cursorrules -->
このプロジェクトはバグ修正ブランチです。
以下の点に注意してください：
- 最小限の変更で問題を解決
- 回帰テストの追加
- 既存の動作を変更しない
```

### 2. AI による自動コミットメッセージ

各 worktree で適切なコミットメッセージのテンプレートを設定：

```bash
# worktrees/feature-a/.gitmessage
feat: 

# 新機能の説明をここに記載
```

```bash
# worktrees/bugfix-123/.gitmessage
fix: 

# 修正内容とバグの影響をここに記載
Fixes #123
```

## 効率的なワークフロー

### 1. タスクランナーの設定

各 worktree に `.vscode/tasks.json` を配置：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Switch to Main",
      "type": "shell",
      "command": "cursor ${workspaceFolder}/../../",
      "problemMatcher": []
    },
    {
      "label": "Run Tests",
      "type": "shell",
      "command": "npm test",
      "group": "test"
    },
    {
      "label": "Create PR",
      "type": "shell",
      "command": "gh pr create --fill",
      "problemMatcher": []
    }
  ]
}
```

### 2. キーボードショートカット

`.vscode/keybindings.json` で worktree 操作を効率化：

```json
[
  {
    "key": "cmd+shift+w",
    "command": "workbench.action.tasks.runTask",
    "args": "Switch to Main"
  },
  {
    "key": "cmd+shift+t",
    "command": "workbench.action.tasks.runTask",
    "args": "Run Tests"
  }
]
```

### 3. ステータスバーのカスタマイズ

現在の worktree を常に確認できるように設定：

```json
{
  "window.title": "${dirty}${activeEditorShort}${separator}${rootName}${separator}[${rootPath}]"
}
```

## トラブルシューティング

### 1. Cursor が worktree を認識しない

```bash
# .git ファイルを確認
cat worktrees/feature-a/.git

# 正しいパスが設定されているか確認
# gitdir: /path/to/main/.git/worktrees/feature-a
```

### 2. 拡張機能が正しく動作しない

```bash
# 各 worktree で拡張機能を再インストール
cd worktrees/feature-a
cursor --install-extension <extension-id>
```

### 3. Git 操作でエラーが発生

```bash
# worktree の整合性を確認
git worktree repair
```

## ベストプラクティス

### 1. ワークスペースの整理

```
project/
├── .vscode/               # 共通設定
│   └── extensions.json    # 推奨拡張機能リスト
├── main/                  # メインブランチ
└── worktrees/
    ├── .cursor-workspace  # Cursor ワークスペース設定
    ├── feature-a/
    │   └── .vscode/       # Feature A 専用設定
    └── bugfix-123/
        └── .vscode/       # Bugfix 123 専用設定
```

### 2. 自動化スクリプト

```bash
#!/bin/bash
# create-worktree.sh

BRANCH_NAME=$1
WORKTREE_PATH="worktrees/$BRANCH_NAME"

# Worktree を作成
git worktree add $WORKTREE_PATH -b $BRANCH_NAME

# VSCode 設定をコピー
cp -r .vscode $WORKTREE_PATH/

# Cursor で開く
cursor $WORKTREE_PATH
```

### 3. 定期的なメンテナンス

```bash
# 使用していない worktree をリストアップ
for wt in $(git worktree list --porcelain | grep "worktree" | cut -d' ' -f2); do
  if [ ! -d "$wt/.vscode" ]; then
    echo "Unused worktree: $wt"
  fi
done
```

## まとめ

Cursor エディタと Git worktree を組み合わせることで：

- 🎯 **視覚的な分離**: 各ブランチを色分けして識別
- 🚀 **効率的な切り替え**: Project Manager で瞬時に移動
- 🤖 **AI の活用**: ブランチごとに最適化されたコンテキスト
- 📊 **統合的な管理**: Git Graph で全体像を把握

これらの機能を活用することで、複雑なプロジェクトでも効率的に開発を進めることができます。