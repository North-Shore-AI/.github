#!/bin/bash
#
# build_readme.sh - North-Shore-AI Organization README Generator
#
# Sources: ONLY North-Shore-AI org repos (ML infrastructure focus)
#
set -e
cd "$(dirname "$0")/.."

echo "=== Building North-Shore-AI README ==="

# Fetch PUBLIC repos ONLY from North-Shore-AI org
REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | \
    jq '[.[] | select(.private == false and .archived == false and .fork == false)]')

# Known topic mappings (display names)
# Format: topic -> display name
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

# Category display order (ML-focused organization)
CATEGORIES=(
    "Crucible Stack"
    "Ingot Stack"
    "AI Infrastructure"
    "AI SDKs"
    "AI Agents"
    "Schema"
    "Research"
    "Observability"
    "Data"
    "Security"
    "Developer Tools"
    "OTP"
    "Testing"
    "Utilities"
)

# Function to convert unknown topic to display name
# nshkr-foo-bar -> "Foo Bar"
topic_to_display() {
    local topic="$1"
    # Remove nshkr- prefix
    local suffix="${topic#nshkr-}"
    # Replace hyphens with spaces and capitalize each word
    echo "$suffix" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
}

# Categorize repos by nshkr-* topics
# Returns JSON with category assignments
CATEGORIZED=$(echo "$REPOS" | jq -r '
    map(select(.topics | index("nshkr-archive") | not)) |
    map({
        name: .name,
        url: .html_url,
        desc: (.description // ""),
        topics: [.topics[] | select(startswith("nshkr-"))]
    })
')

# Calculate stats (excluding archived)
TOTAL=$(echo "$CATEGORIZED" | jq 'length')

echo "Found $TOTAL public repos"

# Build category -> repos mapping using jq
# First pass: get all unique nshkr- topics
ALL_TOPICS=$(echo "$CATEGORIZED" | jq -r '[.[].topics[]] | unique | .[]' | sort)

echo "Topics found: $ALL_TOPICS"

# Generate auto-content by category
AUTO_CONTENT=""

# Track which repos have been categorized
CATEGORIZED_REPOS=""

for cat in "${CATEGORIES[@]}"; do
    # Find the topic that maps to this category
    topic_key=""
    for topic in "${!TOPIC_NAMES[@]}"; do
        if [ "${TOPIC_NAMES[$topic]}" = "$cat" ]; then
            topic_key="$topic"
            break
        fi
    done

    if [ -z "$topic_key" ]; then
        continue
    fi

    # Get repos with this topic
    ITEMS=$(echo "$CATEGORIZED" | jq -r --arg t "$topic_key" '
        [.[] | select(.topics | index($t))] |
        sort_by(.name) |
        .[] |
        "| [\(.name)](\(.url)) | \(.desc | if length > 80 then .[0:77] + "..." else . end) |"
    ')

    if [ -n "$ITEMS" ]; then
        AUTO_CONTENT+="### $cat"$'\n\n'
        AUTO_CONTENT+="| Repository | Description |"$'\n'
        AUTO_CONTENT+="|------------|-------------|"$'\n'
        AUTO_CONTENT+="$ITEMS"$'\n\n'

        # Track categorized repos
        REPO_NAMES=$(echo "$CATEGORIZED" | jq -r --arg t "$topic_key" '[.[] | select(.topics | index($t)) | .name] | .[]')
        CATEGORIZED_REPOS+="$REPO_NAMES"$'\n'
    fi
done

# Handle unknown topics (fallback system)
UNKNOWN_TOPICS=$(echo "$ALL_TOPICS" | while read -r topic; do
    if [ -z "$topic" ]; then continue; fi
    found=false
    for known in "${!TOPIC_NAMES[@]}"; do
        if [ "$topic" = "$known" ]; then
            found=true
            break
        fi
    done
    if [ "$found" = false ]; then
        echo "$topic"
    fi
done)

for topic in $UNKNOWN_TOPICS; do
    if [ -z "$topic" ]; then continue; fi

    display_name=$(topic_to_display "$topic")

    ITEMS=$(echo "$CATEGORIZED" | jq -r --arg t "$topic" '
        [.[] | select(.topics | index($t))] |
        sort_by(.name) |
        .[] |
        "| [\(.name)](\(.url)) | \(.desc | if length > 80 then .[0:77] + "..." else . end) |"
    ')

    if [ -n "$ITEMS" ]; then
        AUTO_CONTENT+="### $display_name"$'\n\n'
        AUTO_CONTENT+="| Repository | Description |"$'\n'
        AUTO_CONTENT+="|------------|-------------|"$'\n'
        AUTO_CONTENT+="$ITEMS"$'\n\n'
    fi
done

# Handle uncategorized repos (no nshkr- topic)
UNCATEGORIZED=$(echo "$CATEGORIZED" | jq -r '
    [.[] | select((.topics | length) == 0)] |
    sort_by(.name) |
    .[] |
    "| [\(.name)](\(.url)) | \(.desc | if length > 80 then .[0:77] + "..." else . end) |"
')

if [ -n "$UNCATEGORIZED" ]; then
    AUTO_CONTENT+="### Other"$'\n\n'
    AUTO_CONTENT+="| Repository | Description |"$'\n'
    AUTO_CONTENT+="|------------|-------------|"$'\n'
    AUTO_CONTENT+="$UNCATEGORIZED"$'\n\n'
fi

# Read template and substitute placeholders
TEMPLATE=$(cat templates/README.template.md)

OUTPUT="${TEMPLATE//\{\{REPO_COUNT\}\}/$TOTAL}"
OUTPUT="${OUTPUT//\{\{UPDATE_DATE\}\}/$(date -u +%Y-%m-%d)}"
OUTPUT="${OUTPUT//\{\{AUTO_GENERATED_CONTENT\}\}/$AUTO_CONTENT}"

echo "$OUTPUT" > profile/README.md

echo "=== Done: $TOTAL repos ==="
