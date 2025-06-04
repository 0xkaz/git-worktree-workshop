# Git Worktree とは何か？

## 概要

Git worktree は、一つの Git リポジトリから複数の作業ディレクトリ（ワーキングツリー）を作成できる機能です。これにより、複数のブランチを同時に異なるディレクトリでチェックアウトし、並行して作業することが可能になります。

## なぜ Git Worktree が必要なのか？

### 従来の問題点

通常の Git では、一度に一つのブランチしかチェックアウトできません。以下のような状況で不便が生じます：

1. **緊急のバグ修正が必要な時**
   - 新機能開発中に緊急バグが発生
   - 作業中の変更を stash または commit する必要がある
   - ブランチを切り替えて修正後、元の作業に戻る手間

2. **複数の機能を並行開発したい時**
   - ブランチAの作業中にブランチBの確認が必要
   - 頻繁なブランチ切り替えによる時間のロス

3. **異なるバージョンを同時に確認したい時**
   - 本番環境と開発環境のコードを比較
   - 複数のバージョンでのテスト実行

### Git Worktree による解決

Git worktree を使用すると：
- **複数のブランチを同時に開く**: 各ブランチが独立したディレクトリに存在
- **コンテキストスイッチが不要**: ディレクトリを移動するだけで作業を切り替え
- **作業の中断なし**: stash や一時的な commit が不要

## 基本的な仕組み

```
repository/
├── .git/                    # メインの Git ディレクトリ（共有）
├── main-branch-files/       # メインワーキングツリー
└── worktrees/
    ├── feature-a/          # feature-a ブランチのワーキングツリー
    └── bugfix-123/         # bugfix-123 ブランチのワーキングツリー
```

### 重要なポイント

1. **Git 履歴は共有**: すべての worktree が同じ `.git` ディレクトリを参照
2. **ファイルは独立**: 各 worktree は独自のファイルシステムを持つ
3. **ブランチは排他的**: 同じブランチを複数の worktree でチェックアウトすることはできない

## 基本的なコマンド

### Worktree の作成

```bash
# 新しいブランチと共に worktree を作成
git worktree add <path> -b <new-branch>

# 既存のブランチで worktree を作成
git worktree add <path> <existing-branch>

# 例
git worktree add ../project-feature feature-branch
git worktree add ./worktrees/bugfix bugfix-123
```

### Worktree の管理

```bash
# すべての worktree を表示
git worktree list

# 出力例:
# /Users/name/project              abc1234 [main]
# /Users/name/project-feature      def5678 [feature-branch]
# /Users/name/project/worktrees/bugfix  ghi9012 [bugfix-123]
```

### Worktree の削除

```bash
# worktree を削除
git worktree remove <path>

# 使用されていない worktree の参照をクリーンアップ
git worktree prune
```

## 実践的な使用例

### 例1: 緊急バグ修正

```bash
# 機能開発中...
$ pwd
/Users/name/my-project  # feature-xyz ブランチで作業中

# 緊急のバグが報告される
$ git worktree add ../my-project-hotfix -b hotfix-001

# バグ修正用のディレクトリに移動
$ cd ../my-project-hotfix

# バグを修正してコミット
$ vim src/critical-file.js
$ git add .
$ git commit -m "Fix critical bug"
$ git push origin hotfix-001

# 元の作業に戻る（作業状態はそのまま保持）
$ cd ../my-project
```

### 例2: 複数バージョンの同時テスト

```bash
# v1.0 と v2.0 を同時にテスト
$ git worktree add ./test-v1 v1.0
$ git worktree add ./test-v2 v2.0

# 各バージョンでテストを実行
$ cd test-v1 && npm test
$ cd ../test-v2 && npm test
```

## メリットとデメリット

### メリット
- ✅ 複数ブランチの同時作業が可能
- ✅ コンテキストスイッチのオーバーヘッドを削減
- ✅ stash や一時的な commit が不要
- ✅ 異なるバージョンの比較が容易
- ✅ CI/CD パイプラインでの並列ビルドに有用

### デメリット
- ❌ ディスク容量を追加で消費
- ❌ 各 worktree で依存関係の再インストールが必要な場合がある
- ❌ 同じブランチを複数の worktree で使用できない
- ❌ worktree の管理を忘れると散らかりやすい

## ベストプラクティス

1. **命名規則を統一する**
   ```bash
   git worktree add ./wt-feature-<name> feature/<name>
   git worktree add ./wt-bugfix-<id> bugfix/<id>
   ```

2. **定期的にクリーンアップ**
   ```bash
   # 不要な worktree を確認
   git worktree list
   
   # 削除
   git worktree remove <path>
   ```

3. **専用ディレクトリで管理**
   ```
   project/
   ├── main/           # メインの作業ディレクトリ
   └── worktrees/      # worktree 専用ディレクトリ
       ├── feature-a/
       └── bugfix-123/
   ```

4. **README で worktree を文書化**
   - チームメンバーが現在の worktree 構成を把握できるように
   - 各 worktree の目的を明記

## まとめ

Git worktree は、モダンな開発ワークフローにおいて非常に有用な機能です。特に以下のような場面で威力を発揮します：

- 🚀 アジャイル開発での迅速なコンテキストスイッチ
- 🐛 緊急バグ修正への即座の対応
- 🔄 継続的インテグレーションでの並列処理
- 📊 複数バージョンの比較検証

適切に使用することで、開発効率を大幅に向上させることができます。