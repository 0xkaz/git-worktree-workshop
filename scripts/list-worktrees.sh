#!/bin/bash
# Worktree の一覧を見やすく表示するスクリプト

set -e

echo "🌳 Git Worktree 一覧"
echo "===================="
echo ""

# worktree の情報を取得して整形
git worktree list --porcelain | awk '
BEGIN {
    count = 0
}
/^worktree/ {
    if (count > 0) {
        print_worktree()
    }
    path = $2
    count++
}
/^HEAD/ {
    commit = substr($2, 1, 7)
}
/^branch/ {
    branch = $2
    gsub(/^refs\/heads\//, "", branch)
}
/^detached/ {
    branch = "(detached HEAD)"
}
END {
    if (count > 0) {
        print_worktree()
    }
    print "\n合計: " count " worktree(s)"
}

function print_worktree() {
    # パスから相対パスを抽出
    gsub(/.*\/20250604-worktree-test/, ".", path)
    
    # ブランチタイプによって絵文字を設定
    if (branch ~ /^feature\//) {
        emoji = "🚀"
        type = "Feature"
    } else if (branch ~ /^bugfix\//) {
        emoji = "🐛"
        type = "Bugfix"
    } else if (branch ~ /^hotfix\//) {
        emoji = "🔥"
        type = "Hotfix"
    } else if (branch == "main" || branch == "master") {
        emoji = "🏠"
        type = "Main"
    } else {
        emoji = "📁"
        type = "Other"
    }
    
    printf "%s %-10s %s\n", emoji, type, branch
    printf "   📍 パス: %s\n", path
    printf "   🔖 コミット: %s\n", commit
    print ""
}
'

# ディスク使用量を表示
echo ""
echo "💾 ディスク使用量"
echo "=================="
if command -v du &> /dev/null; then
    du -sh worktrees/* 2>/dev/null | awk '{printf "   %s\t%s\n", $1, $2}' || echo "   worktrees ディレクトリが見つかりません"
fi

# 推奨アクション
echo ""
echo "💡 推奨アクション"
echo "=================="
echo "   • 新しい worktree を作成: ./scripts/create-worktree.sh <branch-name> [type]"
echo "   • worktree を削除: git worktree remove <path>"
echo "   • 不要な参照をクリーンアップ: git worktree prune"