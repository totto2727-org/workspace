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

# Switch clean, fully pushed repositories to their default branch and pull in parallel.
sync:
    #!/usr/bin/env bash
    set -euo pipefail

    repos=$({
        printf '.\n'
        awk -F '`' '/^\| .* \| `[^`]+` \|$/ { sub(/\/$/, "", $2); print $2 }' AGENTS.md
    })
    while IFS= read -r repo; do
        [[ -e "$repo/.git" ]] || continue
        (
            cd "$repo"
            [[ -z "$(git status --porcelain)" ]] || exit 0
            git fetch origin
            git merge-base --is-ancestor HEAD '@{upstream}' || exit 0
            base=$(git symbolic-ref --short refs/remotes/origin/HEAD)
            printf '\n[%s]\n' "$repo"
            git switch "${base#origin/}"
            git pull --ff-only
        ) &
    done <<< "$repos"
    wait
