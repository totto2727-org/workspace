# List managed repositories and their current branches in a compact table.
list:
    #!/usr/bin/env bash
    set -euo pipefail

    repos=$({
        printf '.\n'
        awk -F '`' '/^\| .* \| `[^`]+` \|$/ { sub(/\/$/, "", $2); print $2 }' AGENTS.md
    })
    width=$(printf '%s\n' "$repos" | awk 'BEGIN { width = length("REPOSITORY") } length > width { width = length } END { print width }')
    printf '%-*s  %s\n' "$width" REPOSITORY BRANCH

    while IFS= read -r repo; do
        if [[ ! -d "$repo/.git" && ! -f "$repo/.git" ]]; then
            branch='(not cloned)'
        else
            branch=$(git -C "$repo" branch --show-current)
            if [[ -z "$branch" ]]; then
                branch="(detached: $(git -C "$repo" rev-parse --short HEAD))"
            fi
        fi
        printf '%-*s  %s\n' "$width" "$repo" "$branch"
    done <<< "$repos"
