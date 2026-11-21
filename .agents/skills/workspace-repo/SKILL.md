---
name: workspace-repo
description: Set up local workspace repositories, create or resume a linked worktree for a task, and inspect or sync primary checkouts with just repo. Keep active work isolated and verify which repositories changed. Use repository-lifecycle instead to register or archive a repository on GitHub.
---

# Work with local workspace repositories

| Task | Use |
| --- | --- |
| Initialize a mapped clone or start, resume, or remove a task worktree | [Linked worktree procedure](references/worktrees.md) |
| List mapped checkouts or intentionally sync their default branches | [`just repo` reference](references/just-repo.md) |
| Register or archive a repository | [repository-lifecycle](../repository-lifecycle/SKILL.md) |
| Decide which projects should adopt a changed artifact | [workspace-dependencies](../workspace-dependencies/SKILL.md) |

Start from the primary workspace root, the directory with the mapped clones and the top-level `AGENTS.md`. For repository changes, work in `worktree/<repository-id>/<task-slug>/`. Use the primary clones to read existing files, fetch refs, and manage linked worktrees. Do not switch or pull a primary clone just to start a task.

Use `git -C <primary-clone> worktree list` to find a task worktree. `just repo list` reports mapped checkout paths, not task worktrees. `just repo sync` is a separate bulk maintenance operation, not a worktree setup or update command.
