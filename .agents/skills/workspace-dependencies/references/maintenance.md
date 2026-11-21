# Maintain the dependency inventory and plan downstream updates

## Regenerate the diagram and table

1. In the primary workspace root, compare the Repository Map with the mapped clones. Select the Git revisions to inspect. For example, run `git -C package/workgraph show HEAD:package/workgraph-agent-cli/moon.mod` to read a committed declaration. Use a selected task worktree or commit when the change under review is not at the mapped clone's `HEAD`. Do not switch branches or update primary clones for this inspection.
2. Search consumers' declarations for the changed artifact's published name or GitHub path. For example, run `git -C package/workgraph grep -nF 'totto2727/agent-sdk@' HEAD -- ':(glob)**/moon.mod'`. A missing checkout or an unverified artifact name does not show that the dependency was removed or never existed.
3. In the `workspace` task worktree, update `repositories` and `edges` in the [JSON inventory](dependencies.json). Store mapped clone paths in `repositories`, not task worktree paths. Use `provider` for the source of an artifact and `consumer` for the repository that uses it. Group `evidence` by provider and consumer. Set `file` to the path relative to the consumer repository. Set `kind` to the reference type, such as `mooncakes`. Set `artifact` to the published name, input name, or action path. Use the declared value for `reference` and the table below for `mode`. Set `scope` to `ci` for shared CI. Otherwise, you can omit `scope`. Record ambiguous references with evidence in `unmapped`. Do not record uncommitted test references or secrets.
4. Run these commands from the root of the `workspace` task worktree to regenerate and check the diagram and table. Do not edit the generated Markdown by hand.

```sh
skill=.agents/skills/workspace-dependencies
graph="$skill/references/dependencies.json"
view="$skill/references/dependencies.md"
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- render "$graph" "$view"
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- check "$graph" "$view"
git diff -- "$graph" "$view"
```

5. Compare the diff with the source declarations. Run `impact` for a changed artifact and check that the result identifies the expected consumers. Review the inventory and generated diagram together in `workspace`.

The script uses [Admiral](https://mooncakes.io/docs/totto2727/admiral) for commands, arguments, and help. Pass `--help` after the script's `--`, or use `impact --help` there to show the arguments for `impact`.

The script validates the inventory and uses [moonmd](https://github.com/moonbitstack/moonmd) to write the GFM tables and the Mermaid code block. It does not discover child repositories or run Git commands. `check` confirms that the output matches the inventory. It does not confirm that the inventory is current.

Use a version of [MoonBit script mode](https://docs.moonbitlang.com/en/stable/toolchain/moon/script-mode.html) that accepts imports between `---` delimiters at the start of an `.mbtx` file. The Wasm commands were verified with `moon 0.1.20261117`.

## Decide which consumers need action

| Relationship | Default action |
| --- | --- |
| `pin`: pinned Mooncakes, npm, Go, Cargo, or Nix reference | Update the relevant declarations, lockfiles, and hashes only when there is a reason to adopt the new release. If a version range already permits the new release, you may only need to update the lockfile. |
| `verify`: a GitHub Action at `@main` or a local path | Keep the reference. Check the affected inputs, outputs, or CI workflows. A GitHub Action fixed to a SHA or tag is a `pin`. Consider updating it only when that action changes. |
| `review`: a configuration format, API, or documentation contract | Compare the changed contract with the consumer's assumptions. Do not update the consumer if the contract did not change. |
| Skip | Record the reason. For example, the artifact is not published, the consumer is out of scope, compatibility is unverified, the release is too recent under the release-age policy, or there is no benefit. |

`candidate_waves` shows a possible order based on `pin` relationships. It is not an execution plan. `--artifact` applies an exact match only to relationships from the starting repository. If an intermediate consumer publishes a changed artifact, run `impact` again for that artifact. Development, test, or CI changes alone do not normally require a new release. If `blocked_by_cycle` is not empty, consider whether to coordinate the changes or publish a compatible intermediate release.

- **`agent-core-sdk`:** First assess whether `codex-sdk` and `opencode-sdk` need the new release. Check `agent-sdk` and `workgraph` only for SDKs that adopt the release and publish a changed artifact.
- **`monorepo` `setup-nix`:** Run a representative CI workflow for consumers that use `@main`. For consumers that use a fixed SHA, change the pin only if their workflow needs the fix. Do not update these consumers for an unrelated application change in `monorepo`.
- **`flowdeck`:** To adopt a FlakeHub release, check the input in `nix/share/my/flake.lock` and where it is used. If only the `glossshift` configuration format changes, check how `flowdeck` reads the configuration separately.

Report `Consumer | Artifact and reference | Update, verify only, or skip | Reason and verification result`. Do not report a skipped consumer as verified. State what you checked or what remains unverified.

## Inventory scope and limits

The inventory covers tracked `package.json`, `moon.mod`, `moon.mod.json`, `moon.work`, `.mbtx` import declarations, `go.mod`, `Cargo.toml`, `cabal.project`, direct inputs in `flake.lock`, active GitHub Actions, `skills-lock.json`, and confirmed operational references.

The first inventory used the Repository Map on `main` and committed declarations from local checkouts. Repositories outside the map are marked `local`. Record a rename from another branch only after it reaches `main`.

Link repositories only when the artifact identity is confirmed, for example, by matching the npm package or MoonBit module name. The diagram excludes dependencies within a repository, test fixtures, vendored code, submodules, disabled workflows, and transitive dependencies that only an external registry can resolve.

The inventory shows declared values. It does not resolve ordinary lockfiles or catalogs. For Nix, it records only direct inputs. Check the actual files for nested lockfile updates or effects on other host configurations.

Do not treat a fork URL as an upstream URL. For example, updating `fork/package/moon-nix` does not change the `moonbit-community/moon-nix` input in `app/c-plugin`. Treat a `mizchi/syntree` registry reference and a `moon.work` reference to a sibling checkout as separate relationships. Check `unmapped` in the JSON for unresolved historical names and upstream references. Do not add a relationship based on a similar name alone.

The diagram cannot prove that a dependency does not exist. When dynamic dependencies, aliases, cross-service deployments, or environment settings change, also use `git grep` to look for the URL, package name, action name, or configuration key. Check the `infra` definitions when a repository, ruleset, or deployment name changes and those definitions can be affected.
