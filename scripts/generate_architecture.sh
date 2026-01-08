#!/bin/bash
#
# generate_architecture.sh
# Generates architecture documentation from repository metadata and dependencies
#
# Sources: ONLY North-Shore-AI org repos
#
set -e
cd "$(dirname "$0")/.."

echo "=== Generating Architecture Documentation ==="

# Output files
ARCH_DOC="docs/ARCHITECTURE.md"
DEP_JSON="docs/dependencies.json"

# Fetch all repos with topics (ONLY from North-Shore-AI)
echo "Fetching repository metadata..."
REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | \
    jq '[.[] | select(.private == false and .archived == false and .fork == false) | {
        name: .name,
        description: .description,
        topics: .topics,
        url: .html_url
    }]')

# Known topic mappings
declare -A TOPIC_NAMES=(
    ["nshkr-ai-agents"]="AI Agents"
    ["nshkr-ai-infra"]="AI Infrastructure"
    ["nshkr-ai-sdk"]="AI SDKs"
    ["nshkr-crucible"]="Crucible Stack"
    ["nshkr-data"]="Data"
    ["nshkr-devtools"]="Developer Tools"
    ["nshkr-ingot"]="Ingot Stack"
    ["nshkr-observability"]="Observability"
    ["nshkr-otp"]="OTP"
    ["nshkr-research"]="Research"
    ["nshkr-schema"]="Schema"
    ["nshkr-security"]="Security"
    ["nshkr-testing"]="Testing"
    ["nshkr-utility"]="Utilities"
)

# Function to convert unknown topic to display name
topic_to_display() {
    local topic="$1"
    local suffix="${topic#nshkr-}"
    echo "$suffix" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Categories based on nshkr-* topics
echo "Categorizing repositories..."

categorize_repos() {
    echo "$REPOS" | jq -r --arg cat "$1" '.[] | select(.topics | index($cat)) | .name'
}

# Get repos for each known topic
declare -A CATEGORY_REPOS
for topic in "${!TOPIC_NAMES[@]}"; do
    CATEGORY_REPOS["$topic"]=$(categorize_repos "$topic")
done

# Also get crucible_* prefix repos for crucible category
CRUCIBLE_PREFIX=$(echo "$REPOS" | jq -r '.[] | select(.name | startswith("crucible_")) | .name')

# Combine crucible repos
ALL_CRUCIBLE=$(echo -e "${CATEGORY_REPOS[nshkr-crucible]}\n$CRUCIBLE_PREFIX" | sort -u | grep -v '^$' || true)

echo ""
echo "Repository counts by category:"
for topic in "${!TOPIC_NAMES[@]}"; do
    count=$(echo "${CATEGORY_REPOS[$topic]}" | grep -c . || echo "0")
    echo "  ${TOPIC_NAMES[$topic]}: $count"
done

# Parse mix.exs files to extract dependencies
echo ""
echo "Parsing mix.exs dependencies..."

parse_deps() {
    local repo_path="$1"
    local mix_file="$repo_path/mix.exs"

    if [ -f "$mix_file" ]; then
        grep -A 100 "defp deps" "$mix_file" 2>/dev/null | \
            grep -oE '\{:[a-z_]+' | \
            sed 's/{://' | \
            sort -u || true
    fi
}

# Build dependency graph JSON
echo "Building dependency graph..."

DEP_GRAPH='{"nodes":[],"edges":[]}'

# Collect all categorized repos
ALL_REPOS=""
for topic in "${!TOPIC_NAMES[@]}"; do
    ALL_REPOS+="${CATEGORY_REPOS[$topic]}"$'\n'
done
ALL_REPOS=$(echo "$ALL_REPOS" | sort -u | grep -v '^$' || true)

# Add nodes for each repo
for repo in $ALL_REPOS; do
    # Determine category
    category="other"
    for topic in "${!TOPIC_NAMES[@]}"; do
        if echo "${CATEGORY_REPOS[$topic]}" | grep -q "^${repo}$"; then
            category="${TOPIC_NAMES[$topic]}"
            break
        fi
    done

    # Get description
    desc=$(echo "$REPOS" | jq -r --arg n "$repo" '.[] | select(.name == $n) | .description // ""')

    DEP_GRAPH=$(echo "$DEP_GRAPH" | jq --arg name "$repo" --arg cat "$category" --arg desc "$desc" \
        '.nodes += [{"id": $name, "category": $cat, "description": $desc}]')
done

# Try to find local repos and parse their deps
NSAI_ROOT="${NSAI_ROOT:-/home/home/p/g/North-Shore-AI}"

for repo in $ALL_REPOS; do
    repo_path="$NSAI_ROOT/$repo"
    if [ -d "$repo_path" ]; then
        deps=$(parse_deps "$repo_path")
        for dep in $deps; do
            # Only add edge if dep is also in our repos
            if echo "$ALL_REPOS" | grep -qw "$dep"; then
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

# Update the date in ARCHITECTURE.md if it exists
if [ -f "$ARCH_DOC" ]; then
    sed -i "s/{{UPDATE_DATE}}/$(date -u +%Y-%m-%d)/g" "$ARCH_DOC"
fi

echo ""
echo "=== Architecture generation complete ==="
echo "  Documentation: $ARCH_DOC"
echo "  Dependency JSON: $DEP_JSON"
