# Workspace

## Overview

This repository coordinates independent Git repositories. Each repository keeps its own history, branches, checks, and releases. The root does not build or deploy them as a unit, use Git submodules, or pin child checkouts to particular commits.

## Layout and work policy

- **Primary checkouts are for people.** This includes the workspace root and the mapped child checkouts. Agents may inspect them, initialize a missing clone when needed, and fetch refs or manage linked worktrees without changing the primary branch or working files. Do not edit, switch, pull, stash, or reset a primary checkout without an explicit request for that checkout operation.
- **`worktree/<repository-id>/<task-slug>/` is for AI tasks.** Agents may create, use, and clean up their own linked worktrees without asking. Use one worktree per affected repository, its ID from the Repository Map, and a short lowercase kebab-case task slug. Use `workspace` as the ID for this repository. Leave other tasks' worktrees and shared branches alone. An existing task can keep its current linked worktree. Read-only inspection does not need a new worktree.
- **Mapped child checkout paths** reflect the repository's role. Use `app/` for applications, `package/` for libraries, `package/<domain>/` for package families, `template/` for templates, and `fork/<role>/` for upstream-first forks. Use other paths when they better describe the repository's role.
- **`tmp/`** is for temporary artifacts, not new task worktrees. The root ignores `worktree/` and does not register worktree paths in the Repository Map.

Follow the child repository's `AGENTS.md` and run its checks, commits, and release steps in its own repository. For a change that spans multiple repositories, validate and commit each repository separately.

## Skills

Write workspace-owned skills, their references, and user-facing script output in English.

- [workspace-repo](.agents/skills/workspace-repo/SKILL.md): Initialize, inspect, or update a mapped clone. Create, resume, or remove a linked worktree.
- [repository-lifecycle](.agents/skills/repository-lifecycle/SKILL.md): Create, register, or archive a repository. Update both the Repository Map and root `.gitignore` when you add or move a repository. Register new managed GitHub repositories in both `infra` and `workspace`.
- [visual-explainer-ja](.agents/skills/visual-explainer-ja/SKILL.md): Present visual HTML reports in Japanese with a fixed dark theme based on the Digital Agency Design System.
- [workspace-dependencies](.agents/skills/workspace-dependencies/SKILL.md): Inspect or refresh the dependency inventory, then decide which consumers need to update, verify only, or take no action.

### Visual reports

- Use the appropriate pstack skill for analysis, evidence, and drafting. Keep its normal output unless the user requests an HTML deliverable or a visual report needs a standalone page.
- For those pages, use `visual-explainer` for the layout, figures, and rendering. Load `visual-explainer-ja` for Japanese text and the shared dark theme. Carry over findings, sources, and caveats from the draft.
- For a TLA+ state model, keep pstack `statechart` as the source of the verified statechart and counterexamples. Visual Explainer only presents the results.
- Use Visual Explainer's built-in figures by default. Consider [Diagram Design](https://github.com/cathrynlavery/diagram-design) only for specialized standalone diagrams, redraws of existing diagram files, or standalone SVG or PNG export. If you use it for these reports, [onboard from local tokens](https://github.com/cathrynlavery/diagram-design/blob/main/skills/diagram-design/references/onboarding.md) and match the shared theme instead of using its default skin.

Install both skills at user scope if you need this workflow in other repositories:

```sh
vpx skills add https://github.com/nicobailon/visual-explainer --skill visual-explainer --global --agent codex claude-code --yes
vpx skills add ./.agents/skills/visual-explainer-ja --skill visual-explainer-ja --global --agent codex claude-code --yes
```

Run the second command from the workspace checkout that contains the theme. Re-run it after updating the workspace to refresh the global copy in `~/.agents/skills/`.

## Repository Map

| Repository | Repository URL | Workspace Path |
| --- | --- | --- |
| agent | https://github.com/totto2727-org/agent.git | `agent/` |
| monorepo | https://github.com/totto2727-org/monorepo.git | `monorepo/` |
| infra | https://github.com/totto2727-org/infra.git | `infra/` |
| nix | https://github.com/totto2727-dotfiles/nix.git | `nix/` |
| agent-core-sdk | https://github.com/totto2727-org/agent-core-sdk.git | `package/agent-sdk/agent-core-sdk/` |
| agent-sdk | https://github.com/totto2727-org/agent-sdk.git | `package/agent-sdk/agent-sdk/` |
| codex-sdk | https://github.com/totto2727-org/codex-sdk.git | `package/agent-sdk/codex-sdk/` |
| opencode-sdk | https://github.com/totto2727-org/opencode-sdk.git | `package/agent-sdk/opencode-sdk/` |
| atlas-to-kysely | https://github.com/totto2727-org/atlas-to-kysely.git | `app/atlas-to-kysely/` |
| c-plugin | https://github.com/totto2727-org/c-plugin.git | `app/c-plugin/` |
| cloudflare-os-starter | https://github.com/totto2727-org/cloudflare-os-starter.git | `fork/app/cloudflare-os-starter/` |
| flowdeck | https://github.com/totto2727-org/flowdeck.git | `app/flowdeck/` |
| glossshift | https://github.com/totto2727-org/glossshift.git | `app/glossshift/` |
| mdts | https://github.com/totto2727-org/mdts.git | `app/mdts/` |
| nix-cache | https://github.com/totto2727-org/nix-cache.git | `app/nix-cache/` |
| open-connector | https://github.com/totto2727-org/open-connector.git | `fork/app/open-connector/` |
| projektor | https://github.com/totto2727-org/projektor.git | `app/projektor/` |
| llm | https://github.com/totto2727-org/llm.git | `fork/package/llm/` |
| moon-nix | https://github.com/totto2727-org/moon-nix.git | `fork/package/moon-nix/` |
| reylo | https://github.com/totto2727-org/reylo.git | `fork/package/reylo/` |
| syntree.mbt | https://github.com/totto2727-org/syntree.mbt.git | `fork/package/syntree.mbt/` |
| tui.mbt | https://github.com/totto2727-org/tui.mbt.git | `fork/package/tui.mbt/` |
| admiral | https://github.com/totto2727-org/admiral.git | `package/admiral/` |
| llm-profiles | https://github.com/totto2727-org/llm-profiles.git | `package/llm-profiles/` |
| oxlint | https://github.com/totto2727-org/oxlint.git | `package/oxlint/` |
| oxlint-docs | https://github.com/totto2727-org/oxlint-docs.git | `app/oxlint-docs/` |
| effront | https://github.com/totto2727-org/effront.git | `package/effront/` |
| effect-http | https://github.com/totto2727-org/effect-http.git | `package/effect-http/` |
| effect-identify | https://github.com/totto2727-org/effect-identify.git | `package/effect-identify/` |
| e2e | https://github.com/totto2727-org/e2e.git | `package/e2e/` |
| geo | https://github.com/totto2727-org/geo.git | `package/geo/` |
| gitignore-patterns | https://github.com/totto2727-org/gitignore-patterns.git | `package/gitignore-patterns/` |
| lens | https://github.com/totto2727-org/lens.git | `package/lens/` |
| model | https://github.com/totto2727-org/model.git | `package/model/` |
| workgraph | https://github.com/totto2727-org/workgraph.git | `package/workgraph/` |
| x | https://github.com/totto2727-org/x.git | `package/x/` |
| template-go-simple | https://github.com/totto2727-org/template-go-simple.git | `template/go-simple/` |
| template-vite-plus-lib | https://github.com/totto2727-org/template-vite-plus-lib.git | `template/vite-plus-lib/` |
| template-vite-plus-app | https://github.com/totto2727-org/template-vite-plus-app.git | `template/vite-plus-app/` |
| template-moonbit-simple | https://github.com/totto2727-org/template-moonbit-simple.git | `template/moonbit-simple/` |
| template-rust-simple | https://github.com/totto2727-org/template-rust-simple.git | `template/rust-simple/` |
| template-haskell-simple | https://github.com/totto2727-org/template-haskell-simple.git | `template/haskell-simple/` |
| moonbit-overlay | https://github.com/totto2727-org/moonbit-overlay.git | `toolchain/moonbit-overlay/` |

## Setup

Clone the virtual monorepo repository, then enter the workspace root.

```bash
git clone https://github.com/totto2727-org/workspace.git
cd workspace
```

Use [workspace-repo](.agents/skills/workspace-repo/SKILL.md) to initialize only the mapped checkouts you need.

## Upstream-first Fork Policy

- Keep repositories under `fork/` as close to upstream as possible. Prefer upstream implementations, dependency declarations, and toolchains over workspace-wide preferences.
- Limit fork-specific changes to required deployment configuration or demonstrated compatibility, security, or operational fixes. Explain why each retained change is necessary in the repository's maintained divergence record.
- Do not introduce optional refactors, toolchain migrations, dependency-policy rewrites, or runtime changes merely to support a local tooling preference.
- Review custom changes when updating upstream. Remove obsolete divergence and prefer submitting generally useful fixes upstream.
- Keep `origin` pointed at the user's fork and `upstream` pointed at the original repository. Open workspace pull requests against the user's fork, not the upstream repository.
- Maintain `docs/upstream-differences.md` inside each fork, recording the upstream comparison revision, purpose, affected areas, and operational impact of retained differences. Do not use this document as a progress log.
- `fork/app/cloudflare-os-starter/` contains the `cloudflare-os-starter` repository, forked from `cloudflare/cloudflare-os-starter`. Its checkout directory matches the repository name. Its nested runtime source remains unchanged.
- `fork/app/open-connector/` is forked from `oomol-lab/open-connector`. Target its fork pull requests at `origin/main`.
- Moving additional repositories into `fork/` requires the user's approval. Present candidates and evidence before changing their placement.

## Workspace generation scripts

- Use [MoonBit script mode](https://docs.moonbitlang.com/en/stable/toolchain/moon/script-mode.html) for new generators at the workspace root. Prefer Wasm. Use native or JavaScript if Wasm cannot meet a verified requirement.
- Prefer MoonBit core, `moonbitlang/x`, `totto2727/*`, or `moonbitstack/*` packages. `mizchi/*` packages are also allowed. Use Bit for Git operations implemented in MoonBit.
- Use [Admiral](https://mooncakes.io/docs/totto2727/admiral) for commands and arguments in workspace MoonBit scripts.
