---
name: workspace-repo
description: List managed Git checkouts and their branches or sync the workspace to remote default branches with just repo. Identify missing and detached checkouts, protect active work, and verify which repositories actually updated. Use repository-lifecycle instead to register or archive a repository.
---

# Inspect and sync workspace repositories

Run these recipes from the workspace root. They use the Repository Map in `AGENTS.md` and include the workspace root (`.`). Local clones outside the map are not included. Run `just --list --list-submodules` to see available recipes and read [repo.just](../../../repo.just) for their implementation.

| Command | Use it to |
| --- | --- |
| `just repo list` | Inspect checkout paths and their current branches. A missing checkout appears as `(not cloned)`. A detached checkout shows a short commit ID. The command does not fetch or change Git state. |
| `just repo sync` | Switch eligible checkouts to the default branch of `origin` and pull with `--ff-only`. It runs across managed checkouts in parallel and can switch the workspace root too. It does not create missing clones. |

## Before a sync

1. Run `just repo list` first. Run `git -C <path> status --short --branch` for each checkout you need to preserve. The list does not show whether a branch has local changes or unpushed commits.
2. Run `just repo sync` only when the task calls for syncing the managed checkout set and switching eligible branches. For one project, use `git -C <path> pull --ff-only` after you check its branch, working tree, and upstream. Do not bulk sync to inspect dependencies or to apply a downstream update plan.
3. Do not stash, discard, reset, or push work to make it eligible for sync. Do not assume that a clean, pushed topic branch stays checked out. Include the workspace root when you check for active work.

## After a sync

The recipe skips missing and dirty checkouts. For the other checkouts it fetches `origin`, checks that `HEAD` is an ancestor of the current branch's upstream, then switches to the branch in `refs/remotes/origin/HEAD` and pulls. A detached checkout, missing upstream or default-branch reference, diverged branch, or failed fetch or pull can prevent a checkout from updating.

Run `just repo list` again. Check `git -C <path> status --short --branch` and compare `HEAD` with the expected remote default branch for each checkout that matters. Inspect the output for errors. The top-level command can exit successfully even if a background job failed. Report repositories you verified, skipped, or could not update separately.

To initialize a missing clone, follow the workspace setup instructions in `AGENTS.md`. To change which repositories are managed, use [repository-lifecycle](../repository-lifecycle/SKILL.md). To decide which projects should adopt a changed artifact, use [workspace-dependencies](../workspace-dependencies/SKILL.md).
