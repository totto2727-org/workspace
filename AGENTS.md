# Virtual Monorepo

## Overview

This repository is a virtual monorepo that places multiple independent Git repositories in one workspace.
Each mapped directory keeps its own `.git` directory, history, branches, and release process. The workspace root is not intended to be built or deployed as a single unit.
The workspace intentionally does not use Git submodules or pin child repositories to exact commit hashes.
Repositories are organized by role rather than programming language. Executable applications belong under `app/`, reusable libraries belong under `package/`, and related package families belong under `package/<domain>/`.
Repositories that do not naturally fit under `app/` or `package/`, such as AI agent plugins and marketplaces, may be placed at the workspace root or another role-appropriate path.

## Repository Map

| Repository | Repository URL | Workspace Path |
| --- | --- | --- |
| agent | https://github.com/totto2727-org/agent.git | `agent/` |
| agent-core-sdk | https://github.com/totto2727-org/agent-core-sdk.git | `package/agent-sdk/agent-core-sdk/` |
| agent-sdk | https://github.com/totto2727-org/agent-sdk.git | `package/agent-sdk/agent-sdk/` |
| codex-sdk | https://github.com/totto2727-org/codex-sdk.git | `package/agent-sdk/codex-sdk/` |
| opencode-sdk | https://github.com/totto2727-org/opencode-sdk.git | `package/agent-sdk/opencode-sdk/` |
| atlas-to-kysely | https://github.com/totto2727-org/atlas-to-kysely.git | `app/atlas-to-kysely/` |
| bw | https://github.com/totto2727-org/bw.git | `app/bw/` |
| c-plugin | https://github.com/totto2727-org/c-plugin.git | `app/c-plugin/` |
| flowdeck | https://github.com/totto2727-org/flowdeck.git | `app/flowdeck/` |
| glossshift | https://github.com/totto2727-org/glossshift.git | `app/glossshift/` |
| wt | https://github.com/totto2727-org/wt.git | `app/wt/` |
| admiral | https://github.com/totto2727-org/admiral.git | `package/admiral/` |
| any-collection | https://github.com/totto2727-org/any-collection.git | `package/any-collection/` |
| e2e | https://github.com/totto2727-org/e2e.git | `package/e2e/` |
| geo | https://github.com/totto2727-org/geo.git | `package/geo/` |
| lens | https://github.com/totto2727-org/lens.git | `package/lens/` |
| workgraph | https://github.com/totto2727-org/workgraph.git | `package/workgraph/` |
| x | https://github.com/totto2727-org/x.git | `package/x/` |
| template-go-simple | https://github.com/totto2727-org/template-go-simple.git | `template/go-simple/` |
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

## Working Guidelines

- At the start of work, run `git pull --ff-only` in each initialized child repository before making changes. Resolve any dirty or diverged state within that child repository first.
- Run Git operations, commits, branches, tags, releases, and pull requests within each independent child repository.
- For cross-repository changes, modify and validate each repository independently and create separate commits in each repository.
- When a child repository contains its own `AGENTS.md`, follow that file for work inside the child repository.
- When adding or moving a repository, update both the repository map in this file and the root `.gitignore` in the same change.
