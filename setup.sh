#!/bin/bash
# One-time setup for the Accounting dashboard repo. Run from Terminal on your Mac:
#   bash ~/it-audit-compliance-dashboard-accounting/setup.sh
# Prerequisite: create an EMPTY GitHub repo named it-audit-compliance-dashboard-accounting
# under duprleo (no README, no .gitignore) at https://github.com/new
set -euo pipefail
cd "$HOME/it-audit-compliance-dashboard-accounting"

if [ ! -d .git ]; then
  git init -b main
  git remote add origin https://github.com/duprleo/it-audit-compliance-dashboard-accounting.git
fi
git add -A
git commit -m "Initial Accounting dashboard (seeded Oct 21, 2026)" || echo "Nothing new to commit."
git push -u origin main

# Install the weekly auto-push job (Mondays 9:10 AM)
mkdir -p "$HOME/Library/LaunchAgents"
cp com.dewpoint.itauditaccountingpush.plist "$HOME/Library/LaunchAgents/"
launchctl unload "$HOME/Library/LaunchAgents/com.dewpoint.itauditaccountingpush.plist" 2>/dev/null || true
launchctl load "$HOME/Library/LaunchAgents/com.dewpoint.itauditaccountingpush.plist"
echo
echo "Scheduled jobs:"; launchctl list | grep dewpoint || true
echo
echo "Done. Next: in Netlify, link this repo to your site (see README.md, 'Netlify')."
