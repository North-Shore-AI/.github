# .github

Shared automation, profile generation, and workflow templates for North Shore AI.

## Site Sync

`nshkrdotcom.github.io` now publishes repo logos under content-hash paths such as `/logos/{repo}-{sha12}.svg`, so downstream logo URLs are versioned by design.

This repo includes:
- `.github/workflows/reusable-site-sync-dispatch.yml` for reusable cross-repo site sync dispatches
- `.github/workflow-templates/nshkr-site-sync-dispatch.yml` so org repos can opt into immediate site refreshes when README or logo assets change

Even without a cross-repo token, `nshkrdotcom.github.io` now polls recent source-repo changes on a short schedule and automatically refreshes itself when README or logo assets move.

If the default `GITHUB_TOKEN` cannot dispatch to `nshkrdotcom/nshkrdotcom.github.io`, configure `NSHKR_SITE_SYNC_TOKEN` as an org or repo secret with access to that target repo.
