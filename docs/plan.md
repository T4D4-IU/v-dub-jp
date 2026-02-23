# URLパース・バリデーション機能 実装計画

## 現状分析
- [x] 現在の実装の詳細調査完了: 新規プロジェクトのため、ベースとなるコードはなし。
- [x] 問題点・改善点の特定完了: メディア処理のパイプライン（yt-dlp等）に渡す前に、無効なURLや未対応のドメインを弾く必要がある。
- [x] 依存関係の洗い出し完了: `thiserror`, `url`, `validator`.

## 目標
### 機能要件
- [ ] 指定されたURLが正しい形式であるか検証する。
- [ ] yt-dlpがサポートしているドメイン（YouTube, 他メディアサイト）であるかを簡易チェック、またはバリデーションの枠組みを作成する。
- [ ] 独自のエラー型を返し、何が失敗したかを明確にする。

### 非機能要件
- [ ] パフォーマンス: 高速な文字列解析。
- [ ] 型安全性: `Result` 型を用いた ROP (Railway Oriented Programming) の徹底。

## TDD実装ステップ

### フェーズ0: 環境構築 (devenv/direnv)
- [ ] `devenv.nix` を作成し、Rust (Cargo, Clippy, Fmt) および `yt-dlp`, `ffmpeg` を定義する。
- [ ] `.envrc` を作成し、`direnv allow` で環境を有効化する。
- [ ] `cargo init` を実行してプロジェクトを初期化する。

### フェーズ1: 基本的なURL形式チェック
#### テスト1: 有効なURLのパース
- [ ] **Red**: 文字列を受け取り `Result<Url, UrlError>` を返す関数のテストを書く。
- [ ] **Green**: `url` クレートを使用して最小実装。
- [ ] **Refactor**: 内部的なエラーを `UrlError` に変換。
- [ ] **Commit**: "test: add test for valid URL parsing"

#### テスト2: 無効な形式のURL
- [ ] **Red**: "invalid-url" などの文字列を入力した際に `UrlError::InvalidFormat` が返ることを確認するテスト。
- [ ] **Green**: `Url::parse` のエラーを `UrlError::InvalidFormat` にマップする。
- [ ] **Commit**: "feat: handle invalid URL format"

### フェーズ2: エラーハンドリングの強化 (thiserror)
#### テスト3: 未サポートのスキーム (非 https など)
- [ ] **Red**: `ftp://...` などのURLを拒否するテスト。
- [ ] **Green**: スキームが `http` または `https` であることをチェックし、`UrlError::UnsupportedScheme` を返す。
- [ ] **Refactor**: エラーメッセージの定義を `thiserror` のマクロで整理。
- [ ] **Commit**: "feat: support only http and https schemes"

### フェーズ3: ROPパターンの適用
#### 構造的変更1: パイプライン化
- [ ] **Before**: 既存テストがパス。
- [ ] **Change**: `parse_url` -> `validate_scheme` -> `check_domain` のような処理を `and_then` チェーンで接続。
- [ ] **After**: 全テストパス。
- [ ] **Commit**: "refactor: apply ROP pattern using and_then chain"

## ROPパターン適用計画

### エラー型設計
```rust
use thiserror::Error;

#[derive(Error, Debug, PartialEq)]
pub enum UrlError {
    #[error("Invalid URL format: {0}")]
    InvalidFormat(#[from] url::ParseError),
    
    #[error("Unsupported scheme: {0}. Only http and https are supported.")]
    UnsupportedScheme(String),
    
    #[error("Empty URL input")]
    Empty,
}
```

### 主要な関数シグネチャ
```rust
pub fn validate_url(input: &str) -> Result<url::Url, UrlError>
```

## 実装詳細

### 新規作成ファイル
- [ ] `src/lib.rs` - ライブラリの入り口。
- [ ] `src/media/url.rs` - URLバリデーションの実装ロジック。
- [ ] `tests/url_validation_test.rs` - 統合テスト。

### 依存関係
```toml
[dependencies]
thiserror = "2.0"
url = "2.5"

[dev-dependencies]
# 追加のテストツールが必要になれば追記
```

## 品質担保
- [ ] `cargo test` - 全テストパス
- [ ] `cargo clippy` - 警告なし
- [ ] `cargo fmt` - フォーマット適用

## 完了条件
- [ ] `validate_url` 関数が期待通り動作し、全てのテストがパスしている。
- [ ] `thiserror` を用いた適切なエラーメッセージが表示される。
- [ ] ROPの原則に従い、例外（panic）を使用していない。
