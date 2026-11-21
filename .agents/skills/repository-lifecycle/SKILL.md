---
name: repository-lifecycle
description: workspace の新規 GitHub リポジトリを作成・登録し、既存リポジトリを取り込むか、引退したリポジトリを安全にアーカイブする。新規は原則 totto2727-org の public とし、infra と workspace の両方への登録を確認する。アーカイブ時は利用先と Pulumi 管理からの切り離しを確認し、GitHub の履歴を削除しない。
---

# リポジトリの追加とアーカイブ

- **新規作成する。** 原則として `totto2727-org` に **public** で作る。別の owner が必要なら作成前に理由を示し、承認を得る。代わりに private で作らない。公開できない内容がある場合は作成を止める。
- **既存リポジトリを追加する。** 新規作成と区別する。現在の公開範囲と保護設定を確認し、登録を理由に既存 private リポジトリを公開しない。
- **両方に登録する。** `infra` の所有者別 Pulumi 宣言と、`workspace` の `AGENTS.md` の Repository Map および `.gitignore` を変更する。別 PR にして相互リンクする。片側だけでは完了にしない。
- **アーカイブする。** 利用側と運用設定を先に確認し、両方の管理対象から外す。GitHub のアーカイブ、組織間移管、Pulumi state の切り離しは別の操作。明示的に承認された操作だけを行い、リポジトリは削除しない。

詳細は [作成・登録・アーカイブの手順](references/procedures.md) を読む。依存調査と図表更新は [workspace-dependencies](../workspace-dependencies/SKILL.md) を使う。
