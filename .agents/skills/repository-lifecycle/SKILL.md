---
name: repository-lifecycle
description: Create and register a GitHub repository for the workspace, add an existing repository, or safely archive a retired repository. Create new repositories as public under totto2727-org by default, and register them in both infra and workspace. Before archiving, check consumers and remove the repository from Pulumi management without deleting its GitHub history.
---

# Add or archive a repository

- **Create a repository.** Use `totto2727-org` and set the visibility to **public**. If a different owner is necessary, explain why and get approval before creation. Do not create a private repository instead. Stop if the content cannot be public.
- **Add an existing repository.** Check its current visibility and protection settings. Do not make an existing private repository public just to register it.
- **Register in both repositories.** Update the owner-specific Pulumi declaration in `infra`. Update the Repository Map in `workspace/AGENTS.md` and the workspace root `.gitignore`. Open a pull request in each repository and link them to each other. Registration is not complete until both sides are updated.
- **Archive a repository.** Check consumers and operational settings first, then remove the repository from both inventories. GitHub archival, transfer between organizations, and removal from Pulumi state are separate operations. Do only the operations that have explicit approval. Do not delete the repository.

Read the [creation, registration, and archival procedures](references/procedures.md) for details. Use [workspace-dependencies](../workspace-dependencies/SKILL.md) to find consumers and update the dependency inventory.
