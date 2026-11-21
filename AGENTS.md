# Workspace

## Overview

This repository coordinates independent Git repositories. Each repository keeps its own history, branches, checks, and releases. The root does not build or deploy them as a unit, use Git submodules, or pin child checkouts to particular commits.

## Layout and work policy

- **Mapped checkouts** are the primary clones of child repositories. Use `app/` for applications, `package/` for libraries, `package/<domain>/` for package families, `template/` for templates, and `fork/<role>/` for upstream-first forks. Use other paths when they better describe the repository's role.
- **`worktree/<repository-id>/<task-slug>/`** is the default location for changes to a child repository. Use its ID from the Repository Map and a short lowercase kebab-case task slug. Make one linked worktree per affected repository. Fetch and select a base for those repositories only. Do not switch, pull, or edit a primary clone as a prerequisite for work.
- **`worktree/workspace/<task-slug>/`** is the corresponding location for isolated changes to this repository. A task already using an appropriate linked worktree can continue there. Read-only inspection does not need a new worktree.
- **`tmp/`** is for temporary artifacts, not new task worktrees. The root ignores `worktree/` and does not register worktree paths in the Repository Map.

Follow the child repository's `AGENTS.md` and run its checks, commits, and release steps in its own repository. For a change that spans multiple repositories, validate and commit each repository separately.

## Skills

Write workspace-owned skills, their references, and user-facing script output in English.

- [workspace-repo](.agents/skills/workspace-repo/SKILL.md): Initialize, inspect, or update a mapped clone. Create, resume, or remove a linked worktree.
- [repository-lifecycle](.agents/skills/repository-lifecycle/SKILL.md): Create, register, or archive a repository. Update both the Repository Map and root `.gitignore` when you add or move a repository. Register new managed GitHub repositories in both `infra` and `workspace`.
- [workspace-dependencies](.agents/skills/workspace-dependencies/SKILL.md): Inspect or refresh the dependency inventory, then decide which consumers need to update, verify only, or take no action.

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
