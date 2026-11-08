# Show available workspace recipes.
default:
    @just --list

# List the workspace and mapped repositories with local branches (* marks current).
repos:
    #!/usr/bin/env bash
    set -euo pipefail

    {
        printf '.\n'
        awk -F '`' '/^\| .* \| `[^`]+` \|$/ { sub(/\/$/, "", $2); print $2 }' AGENTS.md
    } | while IFS= read -r repo; do
        printf '\n%s\n' "$repo"
        if [[ ! -d "$repo/.git" && ! -f "$repo/.git" ]]; then
            printf '  (not cloned)\n'
            continue
        fi

        branches=$(git -C "$repo" branch --no-color)
        if [[ -n "$branches" ]]; then
            printf '%s\n' "$branches"
        else
            current=$(git -C "$repo" symbolic-ref --short HEAD)
            printf '* %s (no commits yet)\n' "$current"
        fi
    done
