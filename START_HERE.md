# Start Here

If you're reading this because Leon DuPree is no longer available to maintain this project, start here, then read `README.md`. This is a sibling of `it-audit-guidance-dashboard-banking` and `it-audit-compliance-dashboard-healthcare`; their docs cover the shared architecture in more depth.

## What this is, in one sentence

An automated weekly tracker of new IT-audit-relevant guidance for accounting and tax firms (FTC Safeguards Rule, IRS, AICPA, NIST, CISA, Michigan), published as a live dashboard, with each entry framed as both an internal audit-program consideration and a "here's what to tell the client" advisory.

## What you need to keep it running

1. **Access to the GitHub repo:** https://github.com/duprleo/it-audit-compliance-dashboard-accounting
2. **Access to the Netlify site** linked to that repo (team member + Git Contributor).
3. **Access to the Claude account** that runs the weekly scheduled task `It audit guidance agent accounting weekly` (Mondays ~8:35 AM ET). This does the research and updates `index.html`. Without it the dashboard goes stale.
4. **A local copy of this repo** on the Mac that runs `auto_push.sh`, or push updates manually each week.

## If you just want the dashboard to keep existing

Do nothing. The last published version stays live on Netlify. It just stops receiving new entries.
