# Inspect or sync mapped checkouts with just

Run these recipes from the primary workspace root to inspect or update its checkouts. They read the Repository Map in the current workspace checkout and include that checkout as `.`. They do not search `worktree/` or local clones outside the map. Use `just repo list` in a `workspace` task worktree only to check a proposed map. Run `just --list --list-submodules` to see all recipes. See [repo.just](../../../../repo.just) for the implementation.

| Command | Use it to |
| --- | --- |
| `just repo list` | See mapped paths and their current branches. A missing checkout appears as `(not cloned)`. A detached checkout shows a short commit ID. The command does not fetch or change Git state. |
| `just repo sync` | Switch eligible mapped checkouts to the default branch of `origin` and pull with `--ff-only`. It runs in parallel, can switch the primary workspace root, and does not create missing clones. |

## Before a sync

1. Run `just repo list`. Use `git -C <path> status --short --branch` to check local changes and branch status. `just repo list` does not show local changes or unpushed commits.
2. Use `just repo sync` only for an intentional bulk update of primary checkouts. A clean topic branch that is fully pushed can still be switched. Include the workspace root when you check for active work. Do not stash, discard, reset, or push work to make a checkout eligible.
3. To start a task, follow the [linked worktree procedure](worktrees.md) instead. To update a task branch, act in its worktree and follow that repository's instructions. A bulk sync does not update task branches, although its fetches update shared remote-tracking refs.

## After a sync

The recipe skips missing and dirty checkouts. For other checkouts, it fetches `origin`, checks whether `HEAD` is an ancestor of the current branch's upstream, then switches to the branch named by `refs/remotes/origin/HEAD` and pulls. A detached checkout, missing upstream, missing default-branch ref, or Git failure can prevent a checkout from updating. A switch can also fail if another worktree already has the default branch checked out.

Run `just repo list` again. For each checkout that matters, use `git -C <path> status --short --branch` and compare `HEAD` with the expected remote default branch. Inspect the output for errors. The top-level command can exit successfully even if a background job failed. Report updated, skipped, and failed checkouts separately.
