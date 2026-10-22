#!/bin/bash
# Auto-commits and pushes index.html if the weekly Cowork task changed it.
# Runs after the it-audit-guidance-agent-accounting-weekly Cowork task (Mondays ~8:35-8:50 AM).
set -uo pipefail

cd "/Users/leondupree/it-audit-compliance-dashboard-accounting" || exit 1

LOG="auto_push.log"

# Safety check 1: index.html must exist and be non-empty.
if [ ! -s index.html ]; then
  echo "$(date): ABORTED - index.html is missing or empty. Not committing/pushing." >> "$LOG"
  exit 1
fi

# Safety check 2: it must still look like the dashboard (has the expected data blocks).
if ! grep -q 'id="repo-data"' index.html || ! grep -q 'id="repo-meta"' index.html; then
  echo "$(date): ABORTED - index.html is missing repo-data/repo-meta blocks. Not committing/pushing." >> "$LOG"
  exit 1
fi

# Safety check 3: refuse to commit a drastic shrink vs. the last committed version
# (catches truncation/corruption, not just outright deletion).
if git rev-parse --verify HEAD:index.html >/dev/null 2>&1; then
  PREV_LINES=$(git show HEAD:index.html | wc -l)
  CUR_LINES=$(wc -l < index.html)
  if [ "$CUR_LINES" -lt "$((PREV_LINES / 2))" ]; then
    echo "$(date): ABORTED - index.html shrank from $PREV_LINES to $CUR_LINES lines. Not committing/pushing." >> "$LOG"
    exit 1
  fi
fi

git add -A

if git diff --cached --quiet; then
  echo "$(date): No changes to push." >> "$LOG"
  exit 0
fi

if ! git commit -m "Automated weekly guidance update"; then
  echo "$(date): ABORTED - git commit failed." >> "$LOG"
  exit 1
fi

if git push; then
  echo "$(date): Pushed update ($(git rev-parse --short HEAD))." >> "$LOG"
else
  echo "$(date): ERROR - git push failed. Commit $(git rev-parse --short HEAD) is local-only; run 'git push' manually." >> "$LOG"
  exit 1
fi
