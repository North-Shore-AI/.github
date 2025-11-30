#!/bin/bash
set -e
cd "$(dirname "$0")/.."

# Fetch all PUBLIC repos from North-Shore-AI
REPOS=$(gh api --paginate "orgs/North-Shore-AI/repos?per_page=100&type=public" | jq '[.[] | select(.private == false and .archived == false and .fork == false)]')

# Categorize repos
categorize() {
  echo "$REPOS" | jq -r --arg cat "$1" '[.[] | select(
    (.topics | index($cat)) or
    (if $cat == "crucible" then (.name | startswith("crucible_")) else false end)
  )] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"'
}

# Stats
TOTAL=$(echo "$REPOS" | jq '[.[] | select(.topics | index("nshkr-archive") | not)] | length')
STARS=$(echo "$REPOS" | jq '[.[] | select(.topics | index("nshkr-archive") | not) | .stargazers_count] | add // 0')

# Crucible core repos (crucible_*)
CRUCIBLE_CORE=$(echo "$REPOS" | jq -r '[.[] | select(.name | startswith("crucible_"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

# ML Safety repos (tagged nshkr-crucible but not crucible_*)
SAFETY=$(echo "$REPOS" | jq -r '[.[] | select((.topics | index("nshkr-crucible")) and (.name | startswith("crucible_") | not) and (.name != "cns_crucible"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

# Infrastructure
INFRA=$(echo "$REPOS" | jq -r '[.[] | select(.topics | index("nshkr-ai-infra"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

# Research
RESEARCH=$(echo "$REPOS" | jq -r '[.[] | select(.topics | index("nshkr-research"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

# Data
DATA=$(echo "$REPOS" | jq -r '[.[] | select(.topics | index("nshkr-data"))] | sort_by(.name) | .[] | "| [\(.name)](https://github.com/North-Shore-AI/\(.name)) | \(.description // "" | if length > 70 then .[0:67] + "..." else . end) |"')

cat > profile/README.md << EOF
# North Shore AI

Reliability-first AI infrastructure on Elixir/BEAM. We build systems that make LLMs behave predictably in production.

**$TOTAL public repos** · **$STARS stars**

---

## Crucible Reliability Stack

Open research platform targeting 99%+ LLM reliability through ensembles, hedging, and statistical testing.

| Repository | Description |
|------------|-------------|
$CRUCIBLE_CORE

EOF

if [ -n "$SAFETY" ]; then
cat >> profile/README.md << EOF
## ML Safety & Quality

| Repository | Description |
|------------|-------------|
$SAFETY

EOF
fi

if [ -n "$INFRA" ]; then
cat >> profile/README.md << EOF
## Infrastructure

| Repository | Description |
|------------|-------------|
$INFRA

EOF
fi

if [ -n "$RESEARCH" ]; then
cat >> profile/README.md << EOF
## Research

| Repository | Description |
|------------|-------------|
$RESEARCH

EOF
fi

if [ -n "$DATA" ]; then
cat >> profile/README.md << EOF
## Data & Tooling

| Repository | Description |
|------------|-------------|
$DATA

EOF
fi

cat >> profile/README.md << EOF
---

**BEAM Native** · OTP supervision, telemetry, distributed resilience
**Research Backed** · Every feature tied to reliability research
**Production Ready** · Hex packages, docs, test suites

[@nshkrdotcom](https://github.com/nshkrdotcom)

_Updated $(date -u +%Y-%m-%d)_
EOF

echo "Done: $TOTAL repos, $STARS stars"
