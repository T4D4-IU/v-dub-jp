# プロジェクト再開用プロンプト

別の環境で本プロジェクトの開発を再開する際は、以下の内容を Antigravity に入力してください。

---

## 開発コンテキストの引き継ぎ

以下のプロジェクトの開発を再開します。

### 1. プロジェクト概要
- **目的**: 多様な動画・音声サイトから日本語吹き替え版を自動生成するプラットフォーム。
- **技術スタック**: Rust (Axum), Tokio, yt-dlp, FFmpeg.
- **開発原則**: TDD (Red/Green/Refactor), ROP (Railway Oriented Programming), Observability (tracing), `jj` (Jujutsu) によるバージョン管理。

### 2. 現在の状況
- **リポジトリ**: GitHub `T4D4-IU/v-dub-jp` に初期設計、ドキュメント、および `.gitignore` がプッシュ済み。
- **完了済み**: ステップ1（プロジェクト初期化、アーキテクチャ設計）。
- **進行中**: ステップ2（URLバリデーション機能の実装）。
- **最新ブランチ**: `feat/url-validation` (このブランチにプラン、`.gitignore`、`devenv.nix` が含まれています)

### 3. 次に行うべき作業
「ステップ2: URLバリデーション機能の実装」の **フェーズ0（環境構築）** から再開してください。

1. **環境のクローンと初期化**:
   ```bash
   git clone https://github.com/T4D4-IU/v-dub-jp.git
   cd v-dub-jp
   git checkout feat/url-validation
   jj git init  # jjリポジトリとして認識させる
   ```
2. **Devenv環境の構築**:
   - `devenv.nix` と `.envrc` は作成済み。
   - `devenv inputs add rust-overlay github:oxalica/rust-overlay --follows nixpkgs` の実行が必要。
   - `direnv allow` で環境をロード。
3. **Rustプロジェクトの初期化と実装**:
   - `docs/plan.md` に従い、`cargo init --lib` から TDD サイクルを開始する。

### 4. 特記事項
- バージョン管理には必ず `jj` を使用してください。
- 変更ログは `docs/changed_log.md` に記録してください。
- エラー発生時は `docs/error_report_XXX.md` を作成して承認を得てください。

---
この内容で、ステップ2の環境構築から作業を再開してください。
