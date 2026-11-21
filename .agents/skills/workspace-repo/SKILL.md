---
name: workspace-repo
description: Create, resume, or remove AI task worktrees without disturbing human checkouts. Initialize, list, or inspect primary workspace checkouts, or update them when explicitly requested. Use repository-lifecycle instead to register or archive a repository on GitHub.
---

# Work with local workspace repositories

| Task | Use |
| --- | --- |
| Start, resume, or remove a task worktree | [Linked worktree procedure](references/worktrees.md) |
| Select, initialize, inspect, or explicitly update a primary checkout | [Primary checkout procedure](references/checkouts.md) |
| Register or archive a repository | [repository-lifecycle](../repository-lifecycle/SKILL.md) |
| Decide which projects should adopt a changed artifact | [workspace-dependencies](../workspace-dependencies/SKILL.md) |

Start from the primary workspace root, the directory with the mapped clones and the top-level `AGENTS.md`. Follow its checkout ownership policy. Do AI work in your own task worktrees under `worktree/`. Treat the primary checkouts as human workspaces, not as staging areas for AI tasks.
