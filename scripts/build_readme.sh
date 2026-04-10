#!/bin/bash
#
# build_readme.sh - North-Shore-AI Organization README Generator
#
# Sources: ONLY North-Shore-AI org repos (ML infrastructure focus)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CATEGORY_CONFIG="$PROJECT_DIR/config/nshkr_categories.json"
README_UNCATEGORIZED_HEADING="Other"

source "$PROJECT_DIR/scripts/lib/nshkr_categories.sh"
nshkr_load_category_config "$CATEGORY_CONFIG"

cd "$PROJECT_DIR"

echo "=== Building North-Shore-AI README ==="

REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | \
    jq '[.[] | select(.private == false and .archived == false and .fork == false)]')

CATEGORIZED=$(printf '%s\n' "$REPOS" | jq --arg archive "$NSHKR_ARCHIVE_SLUG" --arg uncategorized "$NSHKR_UNCATEGORIZED_SLUG" '
    map(select((.topics // []) | index($archive) | not)) |
    map({
        name: .name,
        url: .html_url,
        desc: (.description // ""),
        category: (
            ((.topics // []) | map(select(startswith("nshkr-") and . != $archive)) | sort | first) //
            $uncategorized
        )
    }) |
    sort_by(.name)
')

TOTAL=$(printf '%s\n' "$CATEGORIZED" | jq 'length')

echo "Found $TOTAL public repos"
echo "Topics found:"
printf '%s\n' "$CATEGORIZED" | jq -r --arg uncategorized "$NSHKR_UNCATEGORIZED_SLUG" '
    [.[].category] | map(select(. != $uncategorized)) | unique | .[]?
'

mapfile -t DISCOVERED_TOPICS < <(printf '%s\n' "$CATEGORIZED" | jq -r '.[] | .category' | sort -u)
mapfile -t ORDERED_TOPICS < <(printf '%s\n' "${DISCOVERED_TOPICS[@]}" | nshkr_build_ordered_topics)

AUTO_CONTENT=""

for topic in "${ORDERED_TOPICS[@]}"; do
    display_name=$(nshkr_display_name_for_topic "$topic")

    ITEMS=$(printf '%s\n' "$CATEGORIZED" | jq -r --arg topic "$topic" '
        [.[] | select(.category == $topic)] |
        sort_by(.name) |
        .[] |
        "| [\(.name)](\(.url)) | \(.desc | if length > 80 then .[0:77] + "..." else . end) |"
    ')

    if [[ -n "$ITEMS" ]]; then
        AUTO_CONTENT+="### $display_name"$'\n\n'
        AUTO_CONTENT+="| Repository | Description |"$'\n'
        AUTO_CONTENT+="|------------|-------------|"$'\n'
        AUTO_CONTENT+="$ITEMS"$'\n\n'
    fi
done

UNCATEGORIZED=$(printf '%s\n' "$CATEGORIZED" | jq -r --arg uncategorized "$NSHKR_UNCATEGORIZED_SLUG" '
    [.[] | select(.category == $uncategorized)] |
    sort_by(.name) |
    .[] |
    "| [\(.name)](\(.url)) | \(.desc | if length > 80 then .[0:77] + "..." else . end) |"
')

if [[ -n "$UNCATEGORIZED" ]]; then
    AUTO_CONTENT+="### $README_UNCATEGORIZED_HEADING"$'\n\n'
    AUTO_CONTENT+="| Repository | Description |"$'\n'
    AUTO_CONTENT+="|------------|-------------|"$'\n'
    AUTO_CONTENT+="$UNCATEGORIZED"$'\n\n'
fi

TEMPLATE=$(cat templates/README.template.md)
AUTO_CONTENT_ESCAPED="${AUTO_CONTENT//&/\\&}"

OUTPUT="${TEMPLATE//\{\{REPO_COUNT\}\}/$TOTAL}"
OUTPUT="${OUTPUT//\{\{UPDATE_DATE\}\}/$(date -u +%Y-%m-%d)}"
OUTPUT="${OUTPUT//\{\{AUTO_GENERATED_CONTENT\}\}/$AUTO_CONTENT_ESCAPED}"

echo "$OUTPUT" > profile/README.md

echo "=== Done: $TOTAL repos ==="
