# Inspect and maintain primary checkouts

Start from the primary workspace root. For each requested repository, get its ID, URL, and checkout path from the Repository Map in `AGENTS.md`. For a workspace-wide inventory, walk the mapped paths and include `.` if the workspace repository itself is in scope. Task worktrees are not primary checkouts. List them separately with `git -C "$path" worktree list`.

## Inspect or initialize a mapped checkout

Set `path` to the mapped checkout path. Check for `"$path/.git"` as a file or directory before invoking Git, so Git does not fall back to the enclosing workspace. Report a missing checkout without cloning it unless you need it for a task or the user asks you to initialize it. If its directory already contains files, inspect them before proceeding and do not replace them.

```sh
if test -e "$path/.git"; then
  git -C "$path" status --short --branch && git -C "$path" rev-parse --short HEAD
else
  printf 'Not cloned: %s\n' "$path"
fi
```

To initialize a missing checkout, use its mapped URL and path. For example:

```sh
mkdir -p package/agent-sdk &&
  git clone https://github.com/totto2727-org/agent-sdk.git package/agent-sdk/agent-sdk
```

Check `git -C "$path" remote get-url origin` against the mapped URL and inspect the new checkout. For repository changes, continue in a [task worktree](worktrees.md).

## Update a primary checkout only on request

Primary checkouts are for people. A task request does not authorize changing their branches or working files. Use this procedure only when the user explicitly asks to update those checkouts. Apply it separately to each requested checkout. Determine the intended `origin` branch before starting. Use the remote default branch if the request does not name one, and confirm that default if `origin/HEAD` is missing or stale. Do not switch the branch or change its upstream to make the checkout eligible.

Set `path` to the mapped checkout path and `branch` to the confirmed branch name. Verify that `origin` points to the intended repository before running this check and update:

```sh
if test -e "$path/.git" &&
   current=$(git -C "$path" branch --show-current) && test "$current" = "$branch" &&
   upstream=$(git -C "$path" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}') &&
   test "$upstream" = "origin/$branch" &&
   changes=$(git -C "$path" status --porcelain --untracked-files=all) && test -z "$changes"
then
  git -C "$path" fetch origin &&
    git -C "$path" merge-base --is-ancestor HEAD "refs/remotes/origin/$branch" &&
    git -C "$path" merge --ff-only --no-overwrite-ignore "refs/remotes/origin/$branch"
fi
```

Skip missing, detached, dirty, or differently tracked checkouts. If the ancestry check fails because local commits are ahead or the histories diverged, keep the local checkout unchanged. Do not stash, reset, force, or push. After each attempt, inspect the branch and commit again.

Report each repository as updated, already current, skipped, or failed. For a branch mismatch, show the current and intended branches. For a dirty checkout, report that it has local changes, including untracked files if present. Report both reasons if both apply. Inspect skipped checkouts as needed because the command above stops at the first failed precondition.

See [Git status](https://git-scm.com/docs/git-status) and [Git merge](https://git-scm.com/docs/git-merge) for command options.
