#!/bin/bash
#
# generate_architecture.sh
# Generates architecture documentation from repository metadata and dependencies
#
# Sources: ONLY North-Shore-AI org repos
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CATEGORY_CONFIG="$PROJECT_DIR/config/nshkr_categories.json"
ARCH_DOC="$PROJECT_DIR/docs/ARCHITECTURE.md"
DEP_JSON="$PROJECT_DIR/docs/dependencies.json"

source "$PROJECT_DIR/scripts/lib/nshkr_categories.sh"
nshkr_load_category_config "$CATEGORY_CONFIG"

cd "$PROJECT_DIR"

echo "=== Generating Architecture Documentation ==="
echo "Fetching repository metadata..."

REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | \
    jq '[.[] | select(.private == false and .archived == false and .fork == false) | {
        name: .name,
        description: (.description // ""),
        topics: (.topics // []),
        url: .html_url
    }]')

echo "Categorizing repositories..."

CATEGORIZED=$(printf '%s\n' "$REPOS" | jq --arg archive "$NSHKR_ARCHIVE_SLUG" --arg uncategorized "$NSHKR_UNCATEGORIZED_SLUG" '
    map(select((.topics // []) | index($archive) | not)) |
    map(. + {
        category: (
            ((.topics // []) | map(select(startswith("nshkr-") and . != $archive)) | sort | first) //
            (if (.name | startswith("crucible_")) then "nshkr-crucible" else $uncategorized end)
        )
    }) |
    sort_by(.name)
')

echo ""
echo "Repository counts by category:"
mapfile -t DISCOVERED_TOPICS < <(printf '%s\n' "$CATEGORIZED" | jq -r '.[] | .category' | sort -u)
mapfile -t ORDERED_TOPICS < <(printf '%s\n' "${DISCOVERED_TOPICS[@]}" | nshkr_build_ordered_topics)

for topic in "${ORDERED_TOPICS[@]}"; do
    count=$(printf '%s\n' "$CATEGORIZED" | jq --arg topic "$topic" '[.[] | select(.category == $topic)] | length')
    if [[ "$count" -gt 0 ]]; then
        echo "  $(nshkr_display_name_for_topic "$topic"): $count"
    fi
done

uncategorized_count=$(printf '%s\n' "$CATEGORIZED" | jq --arg uncategorized "$NSHKR_UNCATEGORIZED_SLUG" '
    [.[] | select(.category == $uncategorized)] | length
')
if [[ "$uncategorized_count" -gt 0 ]]; then
    echo "  $NSHKR_UNCATEGORIZED_NAME: $uncategorized_count"
fi

echo ""
echo "Parsing mix.exs dependencies..."

parse_deps() {
    local repo_path="$1"
    local mix_file="$repo_path/mix.exs"

    if [[ -f "$mix_file" ]]; then
        grep -A 100 "defp deps" "$mix_file" 2>/dev/null | \
            grep -oE '\{:[a-z_]+' | \
            sed 's/{://' | \
            sort -u || true
    fi
}

echo "Building dependency graph..."

DEP_GRAPH='{"nodes":[],"edges":[]}'
ALL_REPOS=$(printf '%s\n' "$CATEGORIZED" | jq -r '.[].name')
NSAI_ROOT="${NSAI_ROOT:-/home/home/p/g/North-Shore-AI}"

for repo in $ALL_REPOS; do
    category_slug=$(printf '%s\n' "$CATEGORIZED" | jq -r --arg repo "$repo" '.[] | select(.name == $repo) | .category')
    description=$(printf '%s\n' "$CATEGORIZED" | jq -r --arg repo "$repo" '.[] | select(.name == $repo) | .description')
    category_name=$(nshkr_display_name_for_topic "$category_slug")

    DEP_GRAPH=$(printf '%s\n' "$DEP_GRAPH" | jq --arg name "$repo" --arg cat "$category_name" --arg desc "$description" '
        .nodes += [{"id": $name, "category": $cat, "description": $desc}]
    ')
done

for repo in $ALL_REPOS; do
    repo_path="$NSAI_ROOT/$repo"
    if [[ -d "$repo_path" ]]; then
        deps=$(parse_deps "$repo_path")
        for dep in $deps; do
            if printf '%s\n' "$ALL_REPOS" | grep -qw "$dep"; then
                DEP_GRAPH=$(printf '%s\n' "$DEP_GRAPH" | jq --arg from "$repo" --arg to "$dep" '
                    .edges += [{"source": $from, "target": $to}]
                ')
            fi
        done
    fi
done

DEP_GRAPH=$(printf '%s\n' "$DEP_GRAPH" | jq '.nodes |= sort_by(.id) | .edges |= unique | .edges |= sort_by(.source, .target)')

mkdir -p "$PROJECT_DIR/docs"
printf '%s\n' "$DEP_GRAPH" | jq '.' > "$DEP_JSON"
echo "Saved dependency graph to $DEP_JSON"

if [[ -f "$ARCH_DOC" ]]; then
    sed -i "s/_Last updated: .*/_Last updated: $(date -u +%Y-%m-%d)_/" "$ARCH_DOC"
fi

echo ""
echo "=== Architecture generation complete ==="
echo "  Documentation: $ARCH_DOC"
echo "  Dependency JSON: $DEP_JSON"
