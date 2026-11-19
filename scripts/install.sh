#!/usr/bin/env bash
# Cosmic Forge installer (macOS / Linux / Git Bash)
#   ./scripts/install.sh            → install skills for Claude Code globally (~/.claude/skills)
#   ./scripts/install.sh --project  → install into ./.claude/skills of the current directory
#   ./scripts/install.sh --template <dir> → also copy the Event Horizon template into <dir>
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"; TEMPLATE_DIR=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project) DEST="$(pwd)/.claude/skills" ;;
    --template) TEMPLATE_DIR="$2"; shift ;;
  esac; shift
done
mkdir -p "$DEST"
for s in "$HERE"/skills/*/; do cp -R "$s" "$DEST/"; echo "  ✓ $(basename "$s")"; done
echo "Skills installed to $DEST"
if [ -n "$TEMPLATE_DIR" ]; then mkdir -p "$TEMPLATE_DIR"; cp -R "$HERE/templates/event-horizon/." "$TEMPLATE_DIR/"; echo "Template copied to $TEMPLATE_DIR"; fi
echo "Other AIs: give them AGENTS.md (coding agents) or MASTER_PROMPT.md (chat AIs)."
