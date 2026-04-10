#!/bin/bash

NSHKR_ARCHIVE_SLUG="nshkr-archive"
NSHKR_UNCATEGORIZED_SLUG="uncategorized"
NSHKR_UNCATEGORIZED_NAME="Other Projects"

declare -ag NSHKR_PINNED_CATEGORY_ORDER=()
declare -Ag NSHKR_CATEGORY_NAMES=()
declare -Ag NSHKR_WORD_OVERRIDES=()

nshkr_valid_category_slug() {
    [[ "$1" =~ ^nshkr-[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

nshkr_normalize_topic_slug() {
    local raw="$1"
    local normalized

    normalized=$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')
    normalized="${normalized#nshkr-}"
    normalized=$(printf '%s' "$normalized" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')

    if [[ -n "$normalized" ]]; then
        printf 'nshkr-%s\n' "$normalized"
    fi
}

nshkr_load_category_config() {
    local config_path="$1"
    local slug
    local name
    local key
    local value
    local archive_slug
    local uncategorized_slug
    local uncategorized_name
    local -A seen_slugs=()

    if [[ ! -f "$config_path" ]]; then
        echo "Missing category config: $config_path" >&2
        return 1
    fi

    if ! jq -e '
        (.categories | type == "array" and length > 0) and
        all(.categories[]; (
            (.slug | type == "string") and
            (.name | type == "string") and
            (.slug | test("^nshkr-[a-z0-9]+(-[a-z0-9]+)*$"))
        ))
    ' "$config_path" > /dev/null; then
        echo "Invalid category config: $config_path" >&2
        return 1
    fi

    NSHKR_ARCHIVE_SLUG="nshkr-archive"
    NSHKR_UNCATEGORIZED_SLUG="uncategorized"
    NSHKR_UNCATEGORIZED_NAME="Other Projects"
    NSHKR_PINNED_CATEGORY_ORDER=()
    NSHKR_CATEGORY_NAMES=()
    NSHKR_WORD_OVERRIDES=()

    while IFS=$'\t' read -r slug name; do
        if [[ -n "${seen_slugs[$slug]+x}" ]]; then
            echo "Duplicate category slug in $config_path: $slug" >&2
            return 1
        fi

        seen_slugs["$slug"]=1
        NSHKR_PINNED_CATEGORY_ORDER+=("$slug")
        NSHKR_CATEGORY_NAMES["$slug"]="$name"
    done < <(jq -r '.categories[] | [.slug, .name] | @tsv' "$config_path")

    while IFS=$'\t' read -r key value; do
        NSHKR_WORD_OVERRIDES["$key"]="$value"
    done < <(jq -r '(.word_overrides // {}) | to_entries[] | [.key, (.value | tostring)] | @tsv' "$config_path")

    archive_slug=$(jq -r '.special.archive_slug // "nshkr-archive"' "$config_path")
    if ! nshkr_valid_category_slug "$archive_slug"; then
        echo "Invalid archive slug in $config_path: $archive_slug" >&2
        return 1
    fi
    NSHKR_ARCHIVE_SLUG="$archive_slug"

    uncategorized_slug=$(jq -r '.special.uncategorized_slug // "uncategorized"' "$config_path")
    uncategorized_name=$(jq -r '.special.uncategorized_name // "Other Projects"' "$config_path")

    if [[ -z "$uncategorized_slug" || -z "$uncategorized_name" ]]; then
        echo "Invalid uncategorized settings in $config_path" >&2
        return 1
    fi

    NSHKR_UNCATEGORIZED_SLUG="$uncategorized_slug"
    NSHKR_UNCATEGORIZED_NAME="$uncategorized_name"
}

nshkr_topic_to_display() {
    local topic="$1"
    local suffix="$topic"
    local normalized
    local word
    local lower
    local display=""

    if [[ "$suffix" == nshkr-* ]]; then
        suffix="${suffix#nshkr-}"
    fi

    normalized=$(printf '%s' "$suffix" | tr '_-' '  ')

    for word in $normalized; do
        lower=$(printf '%s' "$word" | tr '[:upper:]' '[:lower:]')
        if [[ -n "${NSHKR_WORD_OVERRIDES[$lower]+x}" ]]; then
            display+="${NSHKR_WORD_OVERRIDES[$lower]} "
        else
            display+="$(printf '%s' "$lower" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}') "
        fi
    done

    printf '%s\n' "${display% }"
}

nshkr_display_name_for_topic() {
    local topic="$1"

    if [[ "$topic" == "$NSHKR_UNCATEGORIZED_SLUG" ]]; then
        printf '%s\n' "$NSHKR_UNCATEGORIZED_NAME"
    elif [[ "$topic" == "$NSHKR_ARCHIVE_SLUG" ]]; then
        printf 'Archive\n'
    elif [[ -n "${NSHKR_CATEGORY_NAMES[$topic]+x}" ]]; then
        printf '%s\n' "${NSHKR_CATEGORY_NAMES[$topic]}"
    else
        nshkr_topic_to_display "$topic"
    fi
}

nshkr_sort_topics_by_display() {
    local topic

    if [[ "$#" -eq 0 ]]; then
        return 0
    fi

    for topic in "$@"; do
        printf '%s\t%s\n' "$(nshkr_display_name_for_topic "$topic" | tr '[:upper:]' '[:lower:]')" "$topic"
    done | sort -t $'\t' -k1,1 -k2,2 | cut -f2
}

nshkr_build_ordered_topics() {
    local -a ordered=("${NSHKR_PINNED_CATEGORY_ORDER[@]}")
    local -a dynamic_topics=()
    local -A seen_topics=()
    local topic

    for topic in "${NSHKR_PINNED_CATEGORY_ORDER[@]}"; do
        seen_topics["$topic"]=1
    done

    while IFS= read -r topic; do
        [[ -z "$topic" || "$topic" == "$NSHKR_UNCATEGORIZED_SLUG" || "$topic" == "$NSHKR_ARCHIVE_SLUG" ]] && continue
        if [[ -z "${seen_topics[$topic]+x}" ]]; then
            dynamic_topics+=("$topic")
            seen_topics["$topic"]=1
        fi
    done

    if ((${#dynamic_topics[@]} > 0)); then
        mapfile -t dynamic_topics < <(nshkr_sort_topics_by_display "${dynamic_topics[@]}")
        ordered+=("${dynamic_topics[@]}")
    fi

    printf '%s\n' "${ordered[@]}"
}
