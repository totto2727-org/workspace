# 依存図表の更新と追従の判断

## 図表を再生成する

1. workspace の `AGENTS.md` にある Repository Map と子リポジトリを照合する。基準リビジョンを決め、たとえば `git -C package/workgraph show HEAD:package/workgraph-agent-cli/moon.mod` で宣言を読む。作業中の別プロジェクトを切り替えたり、`just repo sync` で一括更新したりしない。
2. 更新した成果物の公開名や GitHub パスを、依存の宣言元から探す。たとえば `git -C package/workgraph grep -nF 'totto2727/agent-sdk@' HEAD -- ':(glob)**/moon.mod'` を使う。見つからないチェックアウトや未確認の名前は、削除・依存なしと判断しない。
3. [JSON 台帳](dependencies.json) の `repositories` と `edges` を更新する。`provider` は提供元、`consumer` は利用側。組ごとに `evidence` をまとめる。`file` は利用側からの相対パス、`kind` は参照の種類（例: `mooncakes`）、`artifact` は公開名・入力名・アクションパス、`reference` は宣言値、`mode` は下表の判定。共通 CI は `scope: "ci"` とする。それ以外の `scope` は省略できる。曖昧な参照は根拠を添えて `unmapped` に置く。未コミットの試験用参照や秘密は台帳に足さない。
4. workspace ルートで図表を再生成し、検証する。生成物の Markdown は手で直さない。

```sh
skill=.agents/skills/workspace-dependencies
graph="$skill/references/dependencies.json"
view="$skill/references/dependencies.md"
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- render "$graph" "$view"
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- check "$graph" "$view"
git diff -- "$graph" "$view"
```

5. 差分を宣言元と照合し、実例の `impact` に意図した利用側が出ることを確認する。台帳と図表を workspace 側でまとめてレビューする。

このスクリプトは台帳を検証して図表に変換する。子リポジトリの自動探索や Git 操作は行わない。`check` は台帳と図表の一致を確かめるもので、依存の鮮度は保証しない。
`.mbtx` の先頭に `---` で囲んだ import を書ける [MoonBit スクリプトモード](https://docs.moonbitlang.com/ja/stable/toolchain/moon/script-mode.html) が必要。Wasm は `moon 0.1.20261117` で確認した。

## 追従するかを決める

| 観測した関係 | 既定の判断 |
| --- | --- |
| `pin`: Mooncakes、npm、Go、Cargo、Nix の固定参照など | 採用する理由がある場合だけ、該当する宣言、ロック、必要なハッシュを更新する。範囲指定で新しい版を解決できるなら、宣言を書き換えずロックの更新で足りることもある。 |
| `verify`: `@main` の GitHub Actions やローカルパス | 参照を変更せず、変わる入出力や該当する CI を検証する。固定 SHA・タグの Actions は `pin` だが、そのアクションに変更がある場合だけ追従を検討する。 |
| `review`: 設定形式、API、ドキュメントなどの関係 | 変わった契約と利用側の前提を比較する。契約が変わっていなければ更新しない。 |
| 見送り | 非公開、変更範囲外、互換性が未確認、最低リリース経過日数を満たさない、または更新による便益がない場合は理由を残す。 |

`candidate_waves` は `pin` をたどる候補順であり、実行計画ではない。`--artifact` は起点から出る辺だけを完全一致で絞る。途中のパッケージを再公開する場合に限り、その公開名で再度 `impact` を実行する。開発・テスト・CI の変更だけなら通常は再公開しない。`blocked_by_cycle` が空でなければ、同時変更の要否や前後互換の中間版を検討する。

- **`agent-core-sdk`** の公開更新では `codex-sdk` と `opencode-sdk` の採用可否を先に調べる。採用して再公開した SDK のみ、`agent-sdk` と `workgraph` の追従判断につなげる。
- **`monorepo` の `setup-nix`** を更新したら、`@main` の利用側では代表 CI を検証する。SHA 固定の利用側は、対象のワークフローが必要とする修正か確認してからピンを変える。`monorepo` の無関係なアプリ変更ではこれらを更新しない。
- **`flowdeck`** の FlakeHub 公開版を採用するなら、`nix/share/my/flake.lock` の該当入力とその利用先を確認する。`glossshift` の設定形式だけが変わるなら、`flowdeck` の設定読み取りを別に検証する。

報告には `利用側 | 成果物・参照 | 更新／検証／見送り | 根拠・確認結果` を含める。見送りは成功扱いにせず、何を確認したかか、何が未確認かを書く。

## 抽出範囲と限界

Git 管理下の `package.json`、`moon.mod`、`moon.mod.json`、`moon.work`、`go.mod`、`Cargo.toml`、`cabal.project`、直下入力の `flake.lock`、有効な GitHub Actions、`skills-lock.json` と、確認済みの運用参照を対象にする。
初版は `main` の Repository Map とローカルチェックアウトのコミット済み宣言を基にした。マップにないチェックアウトは `local` として区別する。別ブランチの改名は `main` に反映されてから台帳に取り込む。
npm 名や MoonBit モジュール名などが一致した関係だけを結ぶ。同じリポジトリ内の依存、テストフィクスチャ、ベンダーやサブモジュール、無効化されたワークフロー、外部レジストリでしか解決できない推移的依存は図に含めない。
通常の lockfile とカタログは再解決せず、参照欄は宣言値を表示する。Nix はロックの直下入力だけを読み、入れ子のロック更新や別のホスト設定への伝播は現物を確認する。

fork の URL と upstream の URL を同一視しない。たとえば `app/c-plugin` の `moonbit-community/moon-nix` は、workspace の `fork/package/moon-nix` を更新しても追従しない。`mizchi/syntree` のレジストリ参照と sibling checkout を指定した場合の `moon.work` の関係も別に扱う。不明な過去の公開名や upstream 参照は JSON の `unmapped` を確認する。名前が似ているだけでは辺を足さない。

ないことを証明する図ではない。動的な依存、別名の公開物、サービス間のデプロイや環境設定が変わる場合は、対象の URL、パッケージ名、アクション名、設定キーを `git grep` でも検索する。新しいリポジトリ、ルールセット、デプロイ名の変更では、必要に応じて `infra` の定義も個別に確認する。
