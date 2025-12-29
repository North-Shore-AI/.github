#!/bin/bash
set -e
cd "$(dirname "$0")/.."

# Fetch all PUBLIC repos from North-Shore-AI
REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | jq '[.[] | select(.private == false and .archived == false and .fork == false)]')

# Stats (excluding archived)
TOTAL=$(echo "$REPOS" | jq '[.[] | select(.topics | index("nshkr-archive") | not)] | length')
STARS=$(echo "$REPOS" | jq '[.[] | select(.topics | index("nshkr-archive") | not) | .stargazers_count] | add // 0')

# Helper function to generate repo table rows
gen_rows() {
  local filter="$1"
  echo "$REPOS" | jq -r "$filter"' | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"'
}

# Crucible core repos (crucible_* prefix OR nshkr-crucible topic)
CRUCIBLE_REPOS=$(gen_rows '[.[] | select((.name | startswith("crucible_")) or (.topics | index("nshkr-crucible")))]')

# Ingot labeling stack (nshkr-ingot topic)
INGOT_REPOS=$(gen_rows '[.[] | select(.topics | index("nshkr-ingot"))]')

# Research repos (nshkr-research topic)
RESEARCH_REPOS=$(gen_rows '[.[] | select(.topics | index("nshkr-research"))]')

# Safety repos (nshkr-crucible but not crucible_* and not cns_crucible)
SAFETY_REPOS=$(echo "$REPOS" | jq -r '[.[] | select((.topics | index("nshkr-crucible")) and (.name | startswith("crucible_") | not) and (.name != "cns_crucible"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

# Infrastructure (nshkr-ai-infra topic)
INFRA_REPOS=$(gen_rows '[.[] | select(.topics | index("nshkr-ai-infra"))]')

# Data & Utilities (nshkr-data OR nshkr-utility topic)
DATA_REPOS=$(gen_rows '[.[] | select((.topics | index("nshkr-data")) or (.topics | index("nshkr-utility")))]')

# Read template
TEMPLATE=$(cat templates/README.template.md)

# Substitute placeholders
OUTPUT="${TEMPLATE//\{\{REPO_COUNT\}\}/$TOTAL}"
OUTPUT="${OUTPUT//\{\{STAR_COUNT\}\}/$STARS}"
OUTPUT="${OUTPUT//\{\{UPDATE_DATE\}\}/$(date -u +%Y-%m-%d)}"

# Substitute repo tables (handle multiline content)
OUTPUT=$(echo "$OUTPUT" | awk -v crucible="$CRUCIBLE_REPOS" '{gsub(/\{\{CRUCIBLE_REPOS\}\}/, crucible)}1')
OUTPUT=$(echo "$OUTPUT" | awk -v ingot="$INGOT_REPOS" '{gsub(/\{\{INGOT_REPOS\}\}/, ingot)}1')
OUTPUT=$(echo "$OUTPUT" | awk -v research="$RESEARCH_REPOS" '{gsub(/\{\{RESEARCH_REPOS\}\}/, research)}1')
OUTPUT=$(echo "$OUTPUT" | awk -v safety="$SAFETY_REPOS" '{gsub(/\{\{SAFETY_REPOS\}\}/, safety)}1')
OUTPUT=$(echo "$OUTPUT" | awk -v infra="$INFRA_REPOS" '{gsub(/\{\{INFRA_REPOS\}\}/, infra)}1')
OUTPUT=$(echo "$OUTPUT" | awk -v data="$DATA_REPOS" '{gsub(/\{\{DATA_REPOS\}\}/, data)}1')

echo "$OUTPUT" > profile/README.md

echo "Done: $TOTAL repos, $STARS stars"
