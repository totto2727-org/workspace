# Virtual Monorepo

## 概要

本リポジトリは、複数の独立したGitリポジトリを一つの作業空間へ配置するvirtual monorepoです。
各配置先は固有の`.git`、履歴、ブランチ、リリース手順を維持し、このルート自体を一括ビルドまたはデプロイすることは想定しません。
リポジトリは使用言語では分割せず、実行可能なアプリケーションを`app/`、汎用ライブラリを`package/`、関連するパッケージ群を`package/<領域>/`へ配置します。
AI向けpluginやmarketplaceなど、`app`や`package`へ分類することが不自然なリポジトリは、ルート直下など役割に合う場所へ配置します。

## リポジトリ一覧

| リポジトリ名 | リポジトリURL | 配置パス |
| --- | --- | --- |
| agent | https://github.com/totto2727-org/agent.git | `agent/` |
| agent-core-sdk | https://github.com/totto2727-org/agent-core-sdk.git | `package/agent-sdk/agent-core-sdk/` |
| agent-sdk | https://github.com/totto2727-org/agent-sdk.git | `package/agent-sdk/agent-sdk/` |
| codex-sdk | https://github.com/totto2727-org/codex-sdk.git | `package/agent-sdk/codex-sdk/` |
| opencode-sdk | https://github.com/totto2727-org/opencode-sdk.git | `package/agent-sdk/opencode-sdk/` |
| atlas-to-kysely | https://github.com/totto2727-org/atlas-to-kysely.git | `app/atlas-to-kysely/` |
| bw | https://github.com/totto2727-org/bw.git | `app/bw/` |
| flowdeck | https://github.com/totto2727-org/flowdeck.git | `app/flowdeck/` |
| glossshift | https://github.com/totto2727-org/glossshift.git | `app/glossshift/` |
| wt | https://github.com/totto2727-org/wt.git | `app/wt/` |
| admiral | https://github.com/totto2727-org/admiral.git | `package/admiral/` |
| any-collection | https://github.com/totto2727-org/any-collection.git | `package/any-collection/` |
| e2e | https://github.com/totto2727-org/e2e.git | `package/e2e/` |
| geo | https://github.com/totto2727-org/geo.git | `package/geo/` |
| lens | https://github.com/totto2727-org/lens.git | `package/lens/` |
| tui.mbt | https://github.com/totto2727/tui.mbt.git | `package/tui.mbt/` |
| workgraph | https://github.com/totto2727-org/workgraph.git | `package/workgraph/` |
| x | https://github.com/totto2727-org/x.git | `package/x/` |
| template-go-simple | https://github.com/totto2727-org/template-go-simple.git | `template/go-simple/` |
| template-moonbit-simple | https://github.com/totto2727-org/template-moonbit-simple.git | `template/moonbit-simple/` |
| template-rust-simple | https://github.com/totto2727-org/template-rust-simple.git | `template/rust-simple/` |
| moonbit-overlay | https://github.com/totto2727-org/moonbit-overlay.git | `toolchain/moonbit-overlay/` |

## セットアップ

### ワークスペースのセットアップ

最初にvirtual monorepo本体をcloneし、ワークスペースのルートへ移動します。

```bash
git clone https://github.com/totto2727-org/workspace.git
cd workspace
```

### 各プロジェクトの初期化

`setup.sh`などの一括初期化スクリプトは用意しません。
必要なリポジトリを上の一覧から選び、親ディレクトリを作成して配置パスへcloneします。
例えば`agent-sdk`は次のように初期化します。

```bash
mkdir -p package/agent-sdk
git clone https://github.com/totto2727-org/agent-sdk.git package/agent-sdk/agent-sdk
```

## 作業上の注意

- Git操作、コミット、ブランチ、タグ、リリース、Pull Requestは各配下リポジトリ単位で扱ってください。
- 複数リポジトリを変更する場合も、変更と検証は各リポジトリで行い、コミットを分けてください。
- 配下リポジトリに`AGENTS.md`がある場合、そのリポジトリ内部の作業では配下の指示を優先してください。
- リポジトリを追加または移動するときは、この一覧とルート`.gitignore`を同時に更新してください。
