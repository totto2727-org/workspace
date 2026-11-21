# Work in a linked worktree

Use the primary workspace root for the Repository Map, mapped clones, and task worktrees. If you started inside a linked worktree, identify the primary workspace root before you resolve paths. `git rev-parse --show-toplevel` gives the root of your current checkout, not necessarily the primary workspace root.

If a mapped clone is missing, follow the [primary checkout procedure](checkouts.md) to initialize it first.

## Start or resume a task

1. Select each affected repository by its Repository Map ID. Use `workspace` for the root itself. Use the same short lowercase kebab-case task slug across the affected repositories if the work is related. Use `worktree/<repository-id>/<task-slug>/`, for example `worktree/agent-sdk/update-core-sdk/`. Use a task-specific branch such as `fix/update-core-sdk`.
2. Run `git -C <primary-clone> worktree list`. If the task already has a worktree, verify its repository, branch, and status, then resume there. Do not create a second checkout of the same branch, use `--force`, or reuse a path owned by another task. An existing task can keep its original worktree location.
3. Fetch only the repository you need. Select the requested base branch or the remote default branch. Confirm the default branch if `refs/remotes/origin/HEAD` is missing or stale. Use the fully qualified remote-tracking ref as the base, not the primary clone's `HEAD`. For example, after you confirm that the task should start from `origin/main`, run this from the primary workspace root:

   ```sh
   root=$(pwd -P)
   primary="$root/package/agent-sdk/agent-sdk"
   task="$root/worktree/agent-sdk/update-core-sdk"
   git -C "$primary" fetch origin &&
     mkdir -p "$(dirname "$task")" &&
     git -C "$primary" worktree add --no-track -b fix/update-core-sdk "$task" refs/remotes/origin/main
   ```

   To check out an existing local task branch that is not checked out elsewhere, use `git -C "$primary" worktree add "$task" fix/update-core-sdk` instead of creating the branch again.
4. Check `git -C "$task" status --short --branch`. Read the repository's `AGENTS.md` from that worktree if present. Edit, test, commit, and publish from that worktree. Worktrees share refs and remotes with the primary clone, but not working files or the index. If a build uses sibling paths, check those paths and use the child repository's supported workspace or dependency override. Do not edit primary clones to satisfy a test.

Read-only inspection can use `git -C <primary-clone> show <ref>:<path>` or `git grep` against a selected ref, even if the primary clone has unrelated changes. A worktree is not necessary for those reads.

## Finish a task

Keep worktrees with active work, local changes, or needed artifacts. Before removing one that you own, confirm that the work is merged or available on its intended remote branch. Check tracked, untracked, and important ignored files. Move any needed local artifacts to a safe location first. Remove the worktree from the primary clone with `git -C "$primary" worktree remove "$task"`, without `--force`. Do not delete the branch as part of removing the worktree. If Git refuses removal, inspect the reason rather than deleting the directory manually.

See [Git worktree](https://git-scm.com/docs/git-worktree) for the command reference.
