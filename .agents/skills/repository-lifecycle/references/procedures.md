# リポジトリの作成・登録・アーカイブ手順

## 作成・登録

1. リポジトリ名、用途、owner、配置先、空リポジトリ・テンプレート・fork・既存取り込みの別を確定する。GitHub 上の同名リポジトリと workspace 内の同名パスを確認する。`app/`、`package/`、`template/`、`fork/` は `AGENTS.md` の役割区分に従う。
2. 新規に公開する内容と履歴に秘密や非公開データがないことを確認する。既存の取り込みでは、GitHub で現状の visibility、デフォルトブランチ、ルールセットを確認する。既存 private の公開は別途承認が必要。
3. `infra/github/README.md` に従い、通常は `infra/github/src/totto2727-org.ts` に `createRepository` の宣言を足す。新規は既定の `public` を使い、必要な設定だけ指定する。既存は実際の visibility と import 設定を指定し、重複作成や置換を避ける。fork では upstream、テンプレート利用ではテンプレート元を記録する。required checks は実際の CI 名に合わせる。
4. 必要な個別出力を `infra/github/index.ts` に追加し、所有者別・リソース件数のテストを更新する。`infra` で `vp run ci` を実行する。`just github-preview` で作成または import が想定どおりか確認し、無関係な置換・削除・公開範囲変更があれば止める。Pulumi の適用は infra の運用に従ってプレビューをレビューしてから手動で行う。
5. `workspace/AGENTS.md` の Repository Map に正しい URL とパスを追加し、同じ変更でルート `.gitignore` にパスを追加する。`just repo list` に行が出ることと、`git check-ignore -v <path>/` が意図した規則を返すことを確認する。子リポジトリは独立した Git リポジトリとして配置し、workspace のサブモジュールにはしない。fork なら `origin` と `upstream` を区別する。
6. `infra` と `workspace` に別々の PR を出し、両方の本文から相互にリンクする。適用後は GitHub で owner、visibility、デフォルトブランチを確認する。両側の PR や適用が未完了ならその状態を明示する。依存が増える場合は workspace の依存台帳と図も更新する。

## アーカイブ

1. 対象を `owner/repo` で一つに絞る。現在の visibility、アーカイブ状態、履歴や未マージの変更、引継ぎ先を確認する。通常は現在の owner のまま read-only にする。`totto2727-archive` への移管を希望された場合は、移管先、権限、URL、リダイレクトやパッケージ公開への影響を別に確認する。アーカイブだけを頼まれた場合は移管しない。
2. 依存スキルで直接・間接の利用先を確認する。図表に載らない CI、deploy、公開パッケージ、Nix、ドキュメント参照も検索する。継続利用、代替先への移行、廃止のいずれかを利用先ごとに判断する。既存の pin を一律に変更したり、公開パッケージを削除したりしない。
3. `infra` の所有者別宣言、個別出力、テストから対象を外す PR と、`workspace` の Repository Map と `.gitignore` から対象を外す PR を用意して相互リンクする。依存台帳から管理終了したノードと辺を外す。外部依存として残る参照は移行記録で扱う。ローカルの clone や未コミット作業を削除しない。管理パスに残る clone は承認を得て別の場所に保管し、workspace に誤って追加しない。
4. Pulumi の production stack に対象があるか確認する。repository、ruleset、vulnerability alerts は `protect` と `retainOnDelete` を持ち、宣言の削除だけでは管理を安全に解除できない場合がある。`infra/github/README.md` の手順で refresh 付きプレビューを取り、GitHub 側のリソースを削除しないことを確認する。state 操作が必要なら、対象 stack と正確な URN、保持するリソース、復旧手段を示して別途承認を得る。全体の保護を解除しない。予期しない削除・置換が残る状態で適用しない。
5. 管理解除と利用先への対応を確認する。対象が明示的に承認されている場合のみ GitHub でアーカイブする。必要なら事前に後継先や read-only 化を案内する。GitHub の URL と `archived` 状態、Pulumi の対象不在、workspace のマップと ignore の対象不在をそれぞれ再確認する。リポジトリ、Git 履歴、既存リリースは削除しない。

確認例は [any-collection の workspace 側 PR](https://github.com/totto2727-org/workspace/pull/28) と [infra 側 PR](https://github.com/totto2727-org/infra/pull/24)。これは宣言を外す差分の例で、GitHub のアーカイブや Pulumi の適用が完了した証拠には使わない。

### `totto2727-archive` にも移管する場合

承認された対象について、移管先に同名リポジトリがないことと実行権限を確認する。移管前に Repository ID、visibility、アーカイブ状態、デフォルトブランチと Git refs、必要な Issue・PR・Release を記録する。移管後に新しい owner で同一 ID と状態を照合し、旧 URL と新 URL の読み取りも確認する。移管要求の受付や旧 URL の転送だけでは完了扱いにしない。リダイレクトを維持したい場合は旧パスに同名リポジトリを作らない。保管先を `infra` の現役リポジトリ管理には再登録しない。

GitHub 仕様: [アーカイブ](https://docs.github.com/ja/repositories/archiving-a-github-repository/archiving-repositories)、[移管](https://docs.github.com/ja/repositories/creating-and-managing-repositories/transferring-a-repository)。
