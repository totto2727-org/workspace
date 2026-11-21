---
name: workspace-dependencies
description: Map repository dependencies in ~/proj/workspace, regenerate the dependency diagram, or identify which consumers need to follow a project, package, or shared CI change. Use the JSON inventory and Mermaid diagram to separate update candidates from consumers that only need a check or no action. Do not use this skill for routine updates within a single repository or to update every repository at once.
---

# Workspace dependencies and downstream updates

- Read the [Mermaid diagram and dependency table](references/dependencies.md) for an overview. Use the [JSON inventory](references/dependencies.json) for automation. Arrows point from the provider to the consumer.
- To assess an update, specify the repository ID and, if known, the published package or action. Run this command from a `workspace` checkout that contains this skill:

```sh
skill=.agents/skills/workspace-dependencies
moon run --target wasm --target-dir tmp/workspace-dependencies-build "$skill/scripts/dependencies.mbtx" -- impact "$skill/references/dependencies.json" agent-core-sdk
```

To limit the query to one artifact, replace `agent-core-sdk` with, for example, `monorepo --artifact .github/actions/setup-nix`.

1. Identify the changed artifact, its old and new versions, its release status, and the changes that affect consumers. Distinguish a change in a local checkout from a change in a published artifact.
2. Use `direct` and `candidate_waves` to find consumers. Check each consumer's dependency declaration and the version it uses. Record one decision and its reason for each consumer: **update**, **verify only**, or **skip**. A relationship in the diagram does not by itself require an update.
3. Make only necessary changes that the user asked you to make. Use the [linked worktree procedure](../workspace-repo/references/worktrees.md) for each repository you change. Confirm that the provider has published the artifact before you change consumers' declarations or lockfiles. Follow each repository's verification procedure. If a consumer does not publish a changed artifact, do not propagate a version update to its consumers. For a plan-only request, do not make changes, open pull requests, or deploy.
4. If you confirm that a dependency was added or removed, or that its source or pin changed, follow the [maintenance procedure](references/maintenance.md) to update the evidence and regenerate the diagram. That procedure also gives decision examples and explains the inventory's limits.

The command requires a version of Moon that supports `.mbtx` frontmatter imports. The Wasm command was verified with Moon `0.1.20261117`. It reads only the inventory. Check each repository for its current declarations.
