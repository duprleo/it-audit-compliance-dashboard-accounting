# IT Audit-Compliance Guidance Dashboard — Accounting

Live regulatory/cybersecurity guidance tracker for Dewpoint's accounting and tax IT audit and advisory practice. Monitors the FTC and IRS (regulatory) plus AICPA, NIST, CISA, and Michigan state sources for new or revised guidance affecting CPA firms, tax preparers, and bookkeepers.

Same three-angle format as the healthcare dashboard: every entry has an impact assessment, a suggested internal IT audit-program change, and a client-readiness advisory. The anchor framework is the FTC Safeguards Rule (16 CFR Part 314), which treats tax preparers and accounting firms as financial institutions and requires a written information security plan (WISP), plus IRS Publications 4557 and 5708.

**Live site:** https://it-audit-compliance-dashboard-account.netlify.app
**GitHub repo:** https://github.com/duprleo/it-audit-compliance-dashboard-accounting
**Siblings:** `it-audit-guidance-dashboard-banking`, `it-audit-compliance-dashboard-healthcare`

## How this repo works

- `index.html` is the entire dashboard: a self-contained static page with the guidance data embedded as JSON (`#repo-data` and `#repo-meta` script blocks). Built from the healthcare dashboard's template; only colors (plum/amber), text, and data differ.
- Netlify auto-deploys on every push to `main`. No build step; publish directory is the repo root.
- A weekly Claude scheduled task (`It audit guidance agent accounting weekly`, Mondays ~8:35 AM ET) researches new guidance and rewrites `index.html` in this folder. It does not push.
- `auto_push.sh` (Mondays 9:10 AM via launchd) commits and pushes any change, so the site updates without manual steps.

## One-time setup

1. Create an **empty** repo at https://github.com/new named `it-audit-compliance-dashboard-accounting` (no README or .gitignore).
2. In Terminal: `bash ~/it-audit-compliance-dashboard-accounting/setup.sh`
   This initializes git, makes the first commit, pushes to GitHub, and installs the weekly auto-push job.

## Netlify

- **Existing site (`it-audit-compliance-dashboard-account`, created with Netlify Drop):** Site configuration → Build & deploy → Continuous deployment → Link repository → GitHub → `duprleo/it-audit-compliance-dashboard-accounting`, branch `main`, build command empty, publish directory empty (repo root).
- **If not:** Add new project → Import an existing project → GitHub → pick the repo → same settings → rename the site to `it-audit-compliance-dashboard-account`.
- If Netlify blocks a build with "Unrecognized Git contributor," approve the committer under Team settings → Git Contributors (same fix the banking site needed).

## Publishing an update manually

```bash
cd ~/it-audit-compliance-dashboard-accounting
git add -A && git commit -m "Weekly guidance update" && git push
```

## Automated commit + push

- **Scheduler:** `~/Library/LaunchAgents/com.dewpoint.itauditaccountingpush.plist`, Mondays **9:10 AM**, after the accounting weekly task (~8:35 AM) and after the healthcare push (8:50 AM), so jobs don't collide.
- **Check it's registered:** `launchctl list | grep dewpoint` — you should see `com.dewpoint.itauditpush`, `com.dewpoint.itaudithealthcarepush`, and `com.dewpoint.itauditaccountingpush`.
- **Test now:** `launchctl start com.dewpoint.itauditaccountingpush && cat ~/it-audit-compliance-dashboard-accounting/auto_push.log`
- **Safety checks** (same as healthcare): aborts if `index.html` is missing/empty, lacks the `repo-data`/`repo-meta` blocks, or shrank by more than half since the last commit.
- **Caveat:** relies on git pushing non-interactively with your stored GitHub credentials. If they expire, the push fails silently — check `auto_push.log`.
- **Disable:** `launchctl unload ~/Library/LaunchAgents/com.dewpoint.itauditaccountingpush.plist && rm ~/Library/LaunchAgents/com.dewpoint.itauditaccountingpush.plist`

## Data format

```json
{
  "id": "kebab-case-unique-slug",
  "dateFound": "YYYY-MM-DD",
  "publishedDate": "...",
  "source": "FTC | IRS | AICPA | NIST | CISA | Michigan",
  "category": "Regulatory | Cybersecurity",
  "guidanceType": "New Guidance | Revised Guidance | Advisory | Rule Change | Rule Change (pending) | Status Update | Framework Guidance | Framework Change | Enforcement Action",
  "title": "...",
  "url": "specific source page, never a generic index",
  "relevance": "High | Medium | Low",
  "affectedAuditAreas": ["..."],
  "impactAssessment": "...",
  "suggestedAuditProgramChanges": "...",
  "clientReadinessAdvisory": "1-3 sentences, clear about legal requirement vs. good practice"
}
```

## Notes

- Every entry is AI-drafted. Treat it as a starting point for team review, not something to forward to a client verbatim.
- The initial seed (Oct 21, 2026) is mostly background requirements still in force, not new releases. Weekly runs add genuinely new items.
- A Netlify site is public by default. Consider password protection or SSO before sharing outside the firm.
