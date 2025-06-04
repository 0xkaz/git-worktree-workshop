# Worktree ディレクトリを gitignore すべきか？

## 結論：はい、gitignore すべきです

Git worktree ディレクトリは **必ず `.gitignore` に追加すべき**です。

## 理由

### 1. ローカル環境に依存する

worktree は各開発者が独自に作成・管理するもので：
- 開発者ごとに異なるブランチ構成
- 個人の作業スタイルに応じた配置
- ローカルでの実験的な変更

### 2. Git の循環参照を防ぐ

worktree ディレクトリには `.git` ファイルが含まれており、これをコミットすると：
- Git リポジトリ内に Git リポジトリが存在する状態になる
- 予期しない動作やエラーの原因となる
- リポジトリのサイズが不必要に大きくなる

### 3. セキュリティとプライバシー

- ローカルの設定ファイル
- 未コミットの実験的なコード
- 個人的なメモやTODO

## 推奨される .gitignore 設定

```gitignore
# Git Worktree ディレクトリ
/worktrees/
```

### より包括的な設定

プロジェクトによっては、以下のような命名パターンも考慮：

```gitignore
# Git Worktree の一般的なパターン
/worktrees/
/wt-*/
*-worktree/
*.worktree/
```

## 例外的なケース

### gitignore しない方が良い場合

以下のような特殊なケースでは、worktree 関連ファイルをリポジトリに含める場合があります：

1. **worktree 設定スクリプト**
   ```
   scripts/create-worktree.sh    # ✅ コミットする
   worktrees/feature-a/          # ❌ コミットしない
   ```

2. **worktree テンプレート**
   ```
   .worktree-template/           # ✅ コミットする
   worktrees/                    # ❌ コミットしない
   ```

3. **ドキュメント**
   ```
   docs/worktree-guide.md        # ✅ コミットする
   WORKTREE_SETUP.md            # ✅ コミットする
   ```

## ベストプラクティス

### 1. チーム全体で統一

`.gitignore` ファイルをリポジトリに含めることで：
- チーム全体で同じルールを適用
- 新しいメンバーも自動的に正しい設定を取得
- 誤ってコミットするリスクを防ぐ

### 2. README で説明

```markdown
## 開発環境のセットアップ

このプロジェクトでは Git worktree を使用しています。
`worktrees/` ディレクトリは `.gitignore` に含まれているため、
自由に worktree を作成できます。

例:
\`\`\`bash
git worktree add worktrees/feature-x feature/x
\`\`\`
```

### 3. グローバル gitignore の活用

個人的な設定は、グローバル gitignore に追加：

```bash
# ~/.gitignore_global に追加
my-worktrees/
personal-wt-*/

# Git に設定
git config --global core.excludesfile ~/.gitignore_global
```

## まとめ

✅ **worktree ディレクトリは必ず gitignore する**
- ローカル環境依存のファイルだから
- Git の循環参照を防ぐため
- チームメンバー間での競合を避けるため

✅ **例外は明確に区別する**
- スクリプトやテンプレートはコミット可能
- ドキュメントは積極的に共有

✅ **チーム全体で認識を共有**
- `.gitignore` をリポジトリに含める
- README で使い方を説明
- 命名規則を統一