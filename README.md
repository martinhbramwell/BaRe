# BaRe — backup/restore for ERPNext bench

Single-responsibility companion app: bench backup, restore, and
replication helpers. Lives alongside the bench it operates on at
`~/frappe-bench-*/BaRe/` on the target host.

## Scripts

- `handleBackup.sh` — on-demand / cron-driven bench backup
- `handleRestore.sh` — restore a bench from a backup bundle
- `bkup_cron.sh` — cron entrypoint
- `installApps.sh` — install ERPNext apps after a restore
- `extractViewsFromMaster.sh`, `ros.sh`, `rSYNC.sh` — replication helpers
- `trimLog.sh` — bench log trim
- `utils.sh` — shared shell helpers (sourced)
- `envars.sh` — environment variable definitions (sourced; stripped default
  shipped, real file accepted — see #6)
- `WHAT_TO_DO_IF_REPLICATION_STOPS{,.sh,.txt}` — operator runbook for
  replication halts

## Architectural placement — bucket 1

BaRe belongs to **bucket 1 (ESACP-platform)** under the three-bucket
architecture decided in [`martinhbramwell/ESACP` issue #358][bucket-decision]:
universal AI-assisted ERP-maintenance infrastructure, not operating-company-
specific business logic.

BaRe keeps its own repo, tracker, and commit cadence; the bucket-1
association is institutional (governance and discovery flow through
the three-bucket framing). Companion bucket-1 surface — pipelines,
Cytoscape control plane, observability, QA verdict layer — lives in
[`martinhbramwell/ESACP`][esacp-repo].

[bucket-decision]: https://github.com/martinhbramwell/ESACP/issues/358
[esacp-repo]: https://github.com/martinhbramwell/ESACP
