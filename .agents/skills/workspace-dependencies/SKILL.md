---
name: workspace-dependencies
description: ~/proj/workspace のリポジトリ間依存を図表で確認・再生成し、特定プロジェクト、ライブラリ、共通 CI の更新でどこに追従が必要か調べる。依存の更新候補、互換性検証のみ、見送りを区別して、必要な順序と判断根拠を示す。単一リポジトリだけの一般的な依存更新や、全リポジトリの一括更新には使わない。
---

# Workspace の依存関係と更新追従

- 全体を見るときは [Mermaid 図と依存表](references/dependencies.md) を読む。集計や連携には [JSON](references/dependencies.json) を使う。矢印は **提供元 → 利用側**。
- 特定の更新を調べるときは、リポジトリ名と、分かれば公開パッケージ名やアクション名を指定する。workspace ルートで次のコマンドを実行する。

```sh
skill=.agents/skills/workspace-dependencies
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- impact "$skill/references/dependencies.json" agent-core-sdk
```

成果物を限定するときは、たとえば最後を `monorepo --artifact .github/actions/setup-nix` に置き換える。

1. 更新した成果物、旧版と新版、公開状況、利用側に関係する変更を特定する。ワークスペース内のソース変更と、配布済み成果物の変更を区別する。
2. 出力の `direct` と `candidate_waves` を起点に、依存先ごとに根拠ファイルと実際の採用バージョンを確認する。下流の各リポジトリを **更新する・検証だけする・見送る** に分け、理由を記録する。図に載っていることだけでは更新しない。
3. 追従が必要で、かつ実行を依頼されているものだけ変更する。提供元の配布を確認してから利用側の宣言やロックを変更し、各リポジトリの手順で検証する。途中の利用側が新しい成果物を公開しないなら、その先のバージョン更新を連鎖させない。計画だけの依頼では変更、PR、デプロイを行わない。
4. 依存の追加、削除、参照先やピンの変更を確認したら、[図表の更新手順](references/maintenance.md) に沿って根拠と生成結果を更新する。判断例と抽出範囲も同じ手順にある。

実行には `.mbtx` の frontmatter import をサポートする Moon が必要。Moon `0.1.20261117` の Wasm で検証済み。照会は台帳だけを読む。最新の宣言は各リポジトリで確認する。
