#!/bin/bash
# Git Worktree を作成して Cursor で開くスクリプト

set -e

# 使用方法を表示
usage() {
    echo "使用方法: $0 <branch-name> [branch-type]"
    echo "  branch-name: 作成するブランチ名"
    echo "  branch-type: feature, bugfix, hotfix のいずれか (デフォルト: feature)"
    echo ""
    echo "例:"
    echo "  $0 user-authentication feature"
    echo "  $0 fix-login-error bugfix"
    exit 1
}

# 引数チェック
if [ $# -lt 1 ]; then
    usage
fi

BRANCH_NAME=$1
BRANCH_TYPE=${2:-feature}

# ブランチタイプに応じたプレフィックスを設定
case $BRANCH_TYPE in
    feature)
        BRANCH_PREFIX="feature/"
        COLOR_THEME="GitHub Dark Default"
        ACTIVITY_BAR_COLOR="#2a4e2a"
        WINDOW_TITLE="🚀 Feature"
        ;;
    bugfix)
        BRANCH_PREFIX="bugfix/"
        COLOR_THEME="GitHub Light Default"
        ACTIVITY_BAR_COLOR="#4e2a2a"
        WINDOW_TITLE="🐛 Bugfix"
        ;;
    hotfix)
        BRANCH_PREFIX="hotfix/"
        COLOR_THEME="One Dark Pro"
        ACTIVITY_BAR_COLOR="#4e4e2a"
        WINDOW_TITLE="🔥 Hotfix"
        ;;
    *)
        echo "エラー: 不明なブランチタイプ '$BRANCH_TYPE'"
        usage
        ;;
esac

FULL_BRANCH_NAME="${BRANCH_PREFIX}${BRANCH_NAME}"
WORKTREE_PATH="worktrees/$BRANCH_NAME"

echo "🌳 Worktree を作成中..."
echo "  ブランチ: $FULL_BRANCH_NAME"
echo "  パス: $WORKTREE_PATH"

# Worktree を作成
if git worktree add "$WORKTREE_PATH" -b "$FULL_BRANCH_NAME" 2>/dev/null; then
    echo "✅ Worktree を作成しました"
else
    # 既存のブランチの場合
    echo "⚠️  ブランチが既に存在します。既存のブランチを使用します..."
    git worktree add "$WORKTREE_PATH" "$FULL_BRANCH_NAME"
fi

# .vscode ディレクトリを作成
mkdir -p "$WORKTREE_PATH/.vscode"

# VSCode 設定を作成
cat > "$WORKTREE_PATH/.vscode/settings.json" << EOF
{
  "window.title": "$WINDOW_TITLE $BRANCH_NAME - \${activeEditorShort}",
  "workbench.colorTheme": "$COLOR_THEME",
  "workbench.colorCustomizations": {
    "activityBar.background": "$ACTIVITY_BAR_COLOR",
    "statusBar.background": "$ACTIVITY_BAR_COLOR"
  }
}
EOF

# .cursorrules ファイルを作成
case $BRANCH_TYPE in
    feature)
        cat > "$WORKTREE_PATH/.cursorrules" << EOF
このプロジェクトは新機能「$BRANCH_NAME」の開発ブランチです。

重要な指針：
- 新しい機能の実装に集中する
- 既存の機能との互換性を保つ
- コードの可読性と保守性を重視する
- 適切なテストを追加する
- パフォーマンスへの影響を考慮する
EOF
        ;;
    bugfix)
        cat > "$WORKTREE_PATH/.cursorrules" << EOF
このプロジェクトはバグ修正ブランチ「$BRANCH_NAME」です。

重要な指針：
- 問題の根本原因を特定して修正する
- 最小限の変更で問題を解決する
- 回帰テストを必ず追加する
- 既存の動作を変更しない
- 修正の影響範囲を明確にする
EOF
        ;;
    hotfix)
        cat > "$WORKTREE_PATH/.cursorrules" << EOF
このプロジェクトは緊急修正ブランチ「$BRANCH_NAME」です。

重要な指針：
- 即座にデプロイ可能な修正を行う
- リスクを最小限に抑える
- 十分なテストを行う
- ロールバック計画を準備する
- 修正内容を詳細に文書化する
EOF
        ;;
esac

# Git commit message template を作成
case $BRANCH_TYPE in
    feature)
        cat > "$WORKTREE_PATH/.gitmessage" << EOF
feat: 

# 新機能の説明をここに記載
# - 何を追加したか
# - なぜ必要か
# - どのように動作するか
EOF
        ;;
    bugfix)
        cat > "$WORKTREE_PATH/.gitmessage" << EOF
fix: 

# 修正内容の説明をここに記載
# - 何が問題だったか
# - どのように修正したか
# - 影響範囲

Fixes #
EOF
        ;;
    hotfix)
        cat > "$WORKTREE_PATH/.gitmessage" << EOF
hotfix: 

# 緊急修正の説明をここに記載
# - 問題の深刻度
# - 修正内容
# - テスト結果

Critical: Yes/No
EOF
        ;;
esac

# git config でメッセージテンプレートを設定
cd "$WORKTREE_PATH"
git config commit.template .gitmessage

echo "📁 以下のファイルを作成しました:"
echo "  - .vscode/settings.json"
echo "  - .cursorrules"
echo "  - .gitmessage"

# Cursor で開く
if command -v cursor &> /dev/null; then
    echo "🚀 Cursor でプロジェクトを開いています..."
    cursor .
else
    echo "⚠️  Cursor コマンドが見つかりません"
    echo "手動で以下のディレクトリを開いてください:"
    echo "  $(pwd)"
fi

echo ""
echo "✨ セットアップ完了！"
echo "次のステップ:"
echo "  1. cd $WORKTREE_PATH"
echo "  2. 依存関係をインストール (npm install など)"
echo "  3. 開発を開始"