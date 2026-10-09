# Virtual Monorepo

## Overview

This repository is a virtual monorepo that places multiple independent Git repositories in one workspace.
Each mapped directory keeps its own `.git` directory, history, branches, and release process. The workspace root is not intended to be built or deployed as a single unit.
The workspace intentionally does not use Git submodules or pin child repositories to exact commit hashes.
Repositories are organized by role rather than programming language. Executable applications belong under `app/`, reusable libraries belong under `package/`, and related package families belong under `package/<domain>/`.
Repositories that do not naturally fit under `app/` or `package/`, such as AI agent plugins and marketplaces, may be placed at the workspace root or another role-appropriate path.
Upstream-first forks belong under `fork/`, with role-based paths such as `fork/app/` and `fork/package/`.

## Repository Map

| Repository | Repository URL | Workspace Path |
| --- | --- | --- |
| agent | https://github.com/totto2727-org/agent.git | `agent/` |
| monorepo | https://github.com/totto2727-org/monorepo.git | `monorepo/` |
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
| open-connector | https://github.com/totto2727-org/open-connector.git | `fork/app/open-connector/` |
| jev-lint | https://github.com/mizchi/jev-lint.git | `fork/app/jev-lint/` |
| projektor | https://github.com/totto2727-org/projektor.git | `app/projektor/` |
| projektor-deploy-example | https://github.com/TAJD/projektor-deploy-example.git | `app/projektor-deploy-example/` |
| wt | https://github.com/totto2727-org/wt.git | `app/wt/` |
| admiral | https://github.com/totto2727-org/admiral.git | `package/admiral/` |
| llm-profiles | https://github.com/totto2727-org/llm-profiles.git | `package/llm-profiles/` |
| any-collection | https://github.com/totto2727-org/any-collection.git | `package/any-collection/` |
| oxlint | https://github.com/totto2727-org/oxlint.git | `package/oxlint/` |
| oxlint-docs | https://github.com/totto2727-org/oxlint-docs.git | `app/oxlint-docs/` |
| effront | https://github.com/totto2727-org/effront.git | `package/effront/` |
| e2e | https://github.com/totto2727-org/e2e.git | `package/e2e/` |
| geo | https://github.com/totto2727-org/geo.git | `package/geo/` |
| gitignore-patterns | https://github.com/totto2727-org/gitignore-patterns.git | `package/gitignore-patterns/` |
| lens | https://github.com/totto2727-org/lens.git | `package/lens/` |
| workgraph | https://github.com/totto2727-org/workgraph.git | `package/workgraph/` |
| x | https://github.com/totto2727-org/x.git | `package/x/` |
| template-go-simple | https://github.com/totto2727-org/template-go-simple.git | `template/go-simple/` |
| template-vite-plus-lib | https://github.com/totto2727-org/template-vite-plus-lib.git | `template/vite-plus-lib/` |
| template-vite-plus-app | https://github.com/totto2727-org/template-vite-plus-app.git | `template/vite-plus-app/` |
| template-deno-simple | https://github.com/totto2727-org/template-deno-simple.git | `template/deno-simple/` |
| template-moonbit-simple | https://github.com/totto2727-org/template-moonbit-simple.git | `template/moonbit-simple/` |
| template-rust-simple | https://github.com/totto2727-org/template-rust-simple.git | `template/rust-simple/` |
| moonbit-overlay | https://github.com/totto2727-org/moonbit-overlay.git | `toolchain/moonbit-overlay/` |

## Setup

### Set Up the Workspace

Clone the virtual monorepo repository, then enter the workspace root.

```bash
git clone https://github.com/totto2727-org/workspace.git
cd workspace
```

### Initialize Projects

This repository intentionally does not provide a bulk initialization script such as `setup.sh`.
Choose a repository from the map above, create its parent directory, and clone it into the documented workspace path.
For example, initialize `agent-sdk` as follows:

```bash
mkdir -p package/agent-sdk
git clone https://github.com/totto2727-org/agent-sdk.git package/agent-sdk/agent-sdk
```

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

## Working Guidelines

- At the start of work, run `git pull --ff-only` in each initialized child repository before making changes. Resolve any dirty or diverged state within that child repository first.
- Run Git operations, commits, branches, tags, releases, and pull requests within each independent child repository.
- For cross-repository changes, modify and validate each repository independently and create separate commits in each repository.
- When a child repository contains its own `AGENTS.md`, follow that file for work inside the child repository.
- When adding or moving a repository, update both the repository map in this file and the root `.gitignore` in the same change.
