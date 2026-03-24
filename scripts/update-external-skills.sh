#!/bin/bash
# Update external skills from upstream repositories
# Usage: ./scripts/update-external-skills.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/.github/external-skills.json"
SKILLS_DIR="$PROJECT_DIR/.claude/skills"

echo "=== PM-OS External Skills Updater ==="
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install with: brew install jq"
    exit 1
fi

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

UPDATED_COUNT=0
CHECKED_COUNT=0

# Process each source
for source in $(jq -r '.sources[].repo' "$CONFIG_FILE"); do
    echo "Checking source: $source"

    # Clone the source repo
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 --quiet "https://github.com/$source.git" "$TEMP_DIR" 2>/dev/null

    # Get skills for this source
    SKILLS=$(jq -r --arg repo "$source" '.sources[] | select(.repo == $repo) | .skills[] | "\(.source)|\(.target)"' "$CONFIG_FILE")

    while IFS='|' read -r src_path tgt_name; do
        if [ -n "$src_path" ] && [ -n "$tgt_name" ]; then
            SRC_FULL="$TEMP_DIR/$src_path"
            TGT_FULL="$SKILLS_DIR/$tgt_name"
            CHECKED_COUNT=$((CHECKED_COUNT + 1))

            if [ -d "$SRC_FULL" ]; then
                if [ -d "$TGT_FULL" ]; then
                    # Compare SKILL.md files
                    if ! diff -q "$SRC_FULL/SKILL.md" "$TGT_FULL/SKILL.md" > /dev/null 2>&1; then
                        echo "  ✓ Updating: $tgt_name"
                        rm -rf "$TGT_FULL"
                        cp -r "$SRC_FULL" "$TGT_FULL"
                        UPDATED_COUNT=$((UPDATED_COUNT + 1))
                    else
                        echo "  - Up to date: $tgt_name"
                    fi
                else
                    echo "  + Adding new: $tgt_name"
                    cp -r "$SRC_FULL" "$TGT_FULL"
                    UPDATED_COUNT=$((UPDATED_COUNT + 1))
                fi
            else
                echo "  ! Warning: Source not found: $src_path"
            fi
        fi
    done <<< "$SKILLS"

    # Cleanup
    rm -rf "$TEMP_DIR"
done

# Update lastUpdated in config
jq --arg date "$(date +%Y-%m-%d)" '.lastUpdated = $date' "$CONFIG_FILE" > tmp.json && mv tmp.json "$CONFIG_FILE"

echo ""
echo "=== Summary ==="
echo "Checked: $CHECKED_COUNT skills"
echo "Updated: $UPDATED_COUNT skills"
echo "Last updated: $(date +%Y-%m-%d)"

if [ $UPDATED_COUNT -gt 0 ]; then
    echo ""
    echo "Run 'git diff' to see changes, then commit when ready."
fi
