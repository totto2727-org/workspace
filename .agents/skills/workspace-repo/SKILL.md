---
name: workspace-repo
description: Initialize, list, inspect, or update mapped workspace checkouts with Git. Create, resume, or remove a linked worktree for a task without disturbing active work. Use repository-lifecycle instead to register or archive a repository on GitHub.
---

# Work with local workspace repositories

| Task | Use |
| --- | --- |
| Select, initialize, inspect, or update a primary clone | [Primary checkout procedure](references/checkouts.md) |
| Start, resume, or remove a task worktree | [Linked worktree procedure](references/worktrees.md) |
| Register or archive a repository | [repository-lifecycle](../repository-lifecycle/SKILL.md) |
| Decide which projects should adopt a changed artifact | [workspace-dependencies](../workspace-dependencies/SKILL.md) |

Start from the primary workspace root, the directory with the mapped clones and the top-level `AGENTS.md`. For repository changes, work in `worktree/<repository-id>/<task-slug>/`. Use the primary clones to read existing files, fetch refs, and manage linked worktrees. Do not switch or pull a primary clone just to start a task.

Use `git -C <primary-clone> worktree list` to find a task worktree. Update primary clones only for an explicit checkout maintenance request. For a new task, fetch the selected base and create a worktree without changing the primary clone's branch or working files.
