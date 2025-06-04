# Claude Code 並行稼働実験ガイド

このガイドでは、git worktree を使って Claude Code を並行稼働させる実験手順を説明します。

## 実験 1: 基本的な並行稼働

### 手順

1. **2つのターミナルウィンドウを開く**

2. **ターミナル 1 で feature-a の開発**
   ```bash
   cd worktrees/feature-a
   claude
   ```
   Claude Code に以下を指示：
   - 新しい機能ファイル `feature_a.py` を作成
   - 簡単な関数を実装

3. **ターミナル 2 で bugfix-123 の修正**
   ```bash
   cd worktrees/bugfix-123
   claude
   ```
   Claude Code に以下を指示：
   - バグ修正用のファイル `bugfix.py` を作成
   - エラーハンドリングを実装

### 期待される結果

- 両方の Claude インスタンスが独立して動作
- それぞれの worktree で異なるファイルを編集可能
- お互いの作業に干渉しない

## 実験 2: 同じファイルの異なるバージョン

### 手順

1. **メインブランチで共通ファイルを作成**
   ```bash
   # ルートディレクトリで
   echo "# Common Module\nversion = '1.0.0'" > common.py
   git add common.py
   git commit -m "Add common module"
   ```

2. **各 worktree で異なる変更を加える**
   - feature-a: バージョンを 2.0.0 に更新
   - bugfix-123: バージョンを 1.0.1 に更新

### 検証ポイント

- 各 worktree で独立した変更が可能か
- コンフリクトの発生と解決方法

## 実験 3: 並行開発のワークフロー

### シナリオ

プロジェクトに新機能を追加しながら、緊急のバグ修正を行う必要がある場合

### 手順

1. **feature-a で新機能の開発を開始**
   - データ処理モジュールを作成
   - テストコードを追加

2. **緊急バグが報告される**
   - bugfix-123 worktree に切り替え
   - バグを修正してテスト

3. **バグ修正をメインブランチにマージ**
   ```bash
   cd worktrees/bugfix-123
   git add .
   git commit -m "Fix critical bug"
   git push origin bugfix-123
   # PR を作成してマージ
   ```

4. **feature-a の開発を継続**
   - メインブランチの変更を取り込む
   - 開発を完了

## 実験 4: パフォーマンスとリソース使用

### 測定項目

- 各 Claude インスタンスのメモリ使用量
- ファイルシステムのパフォーマンス
- Git 操作の速度

### 手順

1. **システムモニターを起動**
   ```bash
   # macOS
   open -a "Activity Monitor"
   
   # Linux
   htop
   ```

2. **複数の Claude インスタンスを起動**

3. **大きなファイルの編集を同時実行**

## トラブルシューティング

### よくある問題

1. **worktree が作成できない**
   - ブランチが既に存在する場合は `-b` オプションを外す
   - ディレクトリが既に存在する場合は別の名前を使用

2. **Claude Code が起動しない**
   - 各 worktree ディレクトリに移動してから起動
   - `claude` コマンドがパスに含まれているか確認

3. **変更が他の worktree に影響する**
   - `git status` で現在の worktree を確認
   - 正しいディレクトリで作業しているか確認

## ベストプラクティス

1. **わかりやすいディレクトリ名を使用**
   - `worktrees/feature-<機能名>`
   - `worktrees/bugfix-<チケット番号>`

2. **定期的な整理**
   ```bash
   # 使用していない worktree を確認
   git worktree list
   
   # 不要な worktree を削除
   git worktree remove <path>
   ```

3. **各 worktree での環境初期化**
   - 必要な依存関係のインストール
   - 設定ファイルの確認

## まとめ

Git worktree を使った Claude Code の並行稼働により、効率的な開発が可能になります。各実験を通じて、この機能の利点と注意点を理解し、実際の開発に活用してください。