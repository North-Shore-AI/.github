#!/bin/bash
#
# generate_architecture.sh
# Generates architecture documentation from repository metadata and dependencies
#
set -e
cd "$(dirname "$0")/.."

echo "=== Generating Architecture Documentation ==="

# Output files
ARCH_DOC="docs/ARCHITECTURE.md"
DEP_JSON="docs/dependencies.json"

# Fetch all repos with topics
echo "Fetching repository metadata..."
REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | \
    jq '[.[] | select(.private == false and .archived == false and .fork == false) | {
        name: .name,
        description: .description,
        topics: .topics,
        url: .html_url
    }]')

# Categories based on nshkr-* topics
echo "Categorizing repositories..."
categorize_repos() {
    echo "$REPOS" | jq -r --arg cat "$1" '.[] | select(.topics | index($cat)) | .name'
}

CRUCIBLE_REPOS=$(categorize_repos "nshkr-crucible")
INGOT_REPOS=$(categorize_repos "nshkr-ingot")
RESEARCH_REPOS=$(categorize_repos "nshkr-research")
INFRA_REPOS=$(categorize_repos "nshkr-ai-infra")
DATA_REPOS=$(categorize_repos "nshkr-data")
UTILITY_REPOS=$(categorize_repos "nshkr-utility")

# Also get crucible_* prefix repos
CRUCIBLE_PREFIX=$(echo "$REPOS" | jq -r '.[] | select(.name | startswith("crucible_")) | .name')

# Combine and dedupe
ALL_CRUCIBLE=$(echo -e "$CRUCIBLE_REPOS\n$CRUCIBLE_PREFIX" | sort -u | grep -v '^$')

echo ""
echo "Repository counts:"
echo "  Crucible stack: $(echo "$ALL_CRUCIBLE" | wc -l | tr -d ' ')"
echo "  Ingot stack: $(echo "$INGOT_REPOS" | wc -l | tr -d ' ')"
echo "  Research: $(echo "$RESEARCH_REPOS" | wc -l | tr -d ' ')"
echo "  Infrastructure: $(echo "$INFRA_REPOS" | wc -l | tr -d ' ')"
echo "  Data: $(echo "$DATA_REPOS" | wc -l | tr -d ' ')"
echo "  Utilities: $(echo "$UTILITY_REPOS" | wc -l | tr -d ' ')"

# Parse mix.exs files to extract dependencies
echo ""
echo "Parsing mix.exs dependencies..."

parse_deps() {
    local repo_path="$1"
    local mix_file="$repo_path/mix.exs"

    if [ -f "$mix_file" ]; then
        # Extract deps block and parse package names
        grep -A 100 "defp deps" "$mix_file" 2>/dev/null | \
            grep -oE '\{:[a-z_]+' | \
            sed 's/{://' | \
            sort -u || true
    fi
}

# Build dependency graph JSON
echo "Building dependency graph..."

DEP_GRAPH='{"nodes":[],"edges":[]}'

# Add nodes for each repo
for repo in $ALL_CRUCIBLE $INGOT_REPOS $RESEARCH_REPOS $INFRA_REPOS $DATA_REPOS $UTILITY_REPOS; do
    # Determine category
    category="other"
    if echo "$ALL_CRUCIBLE" | grep -q "^${repo}$"; then
        category="crucible"
    elif echo "$INGOT_REPOS" | grep -q "^${repo}$"; then
        category="ingot"
    elif echo "$RESEARCH_REPOS" | grep -q "^${repo}$"; then
        category="research"
    elif echo "$INFRA_REPOS" | grep -q "^${repo}$"; then
        category="infra"
    elif echo "$DATA_REPOS" | grep -q "^${repo}$"; then
        category="data"
    elif echo "$UTILITY_REPOS" | grep -q "^${repo}$"; then
        category="utility"
    fi

    # Get description
    desc=$(echo "$REPOS" | jq -r --arg n "$repo" '.[] | select(.name == $n) | .description // ""')

    DEP_GRAPH=$(echo "$DEP_GRAPH" | jq --arg name "$repo" --arg cat "$category" --arg desc "$desc" \
        '.nodes += [{"id": $name, "category": $cat, "description": $desc}]')
done

# Try to find local repos and parse their deps
NSAI_ROOT="${NSAI_ROOT:-/home/home/p/g/North-Shore-AI}"

for repo in $ALL_CRUCIBLE $INGOT_REPOS $RESEARCH_REPOS $INFRA_REPOS $DATA_REPOS $UTILITY_REPOS; do
    repo_path="$NSAI_ROOT/$repo"
    if [ -d "$repo_path" ]; then
        deps=$(parse_deps "$repo_path")
        for dep in $deps; do
            # Only add edge if dep is also in our repos
            if echo "$ALL_CRUCIBLE $INGOT_REPOS $RESEARCH_REPOS $INFRA_REPOS $DATA_REPOS $UTILITY_REPOS" | grep -qw "$dep"; then
                DEP_GRAPH=$(echo "$DEP_GRAPH" | jq --arg from "$repo" --arg to "$dep" \
                    '.edges += [{"source": $from, "target": $to}]')
            fi
        done
    fi
done

# Remove duplicate edges
DEP_GRAPH=$(echo "$DEP_GRAPH" | jq '.edges |= unique')

# Save dependency graph
mkdir -p docs
echo "$DEP_GRAPH" | jq '.' > "$DEP_JSON"
echo "Saved dependency graph to $DEP_JSON"

# Generate Mermaid from dependency graph
echo ""
echo "Generating Mermaid diagrams..."

generate_mermaid() {
    local category="$1"
    local title="$2"

    echo "flowchart TB"

    # Get nodes for this category
    local nodes=$(echo "$DEP_GRAPH" | jq -r --arg cat "$category" '.nodes[] | select(.category == $cat) | .id')

    for node in $nodes; do
        echo "    $node[$node]"
    done

    # Get edges where source is in this category
    for node in $nodes; do
        local targets=$(echo "$DEP_GRAPH" | jq -r --arg src "$node" '.edges[] | select(.source == $src) | .target')
        for target in $targets; do
            echo "    $node --> $target"
        done
    done
}

# Update the date in ARCHITECTURE.md
sed -i "s/{{UPDATE_DATE}}/$(date -u +%Y-%m-%d)/g" "$ARCH_DOC"

echo ""
echo "=== Architecture generation complete ==="
echo "  Documentation: $ARCH_DOC"
echo "  Dependency JSON: $DEP_JSON"
