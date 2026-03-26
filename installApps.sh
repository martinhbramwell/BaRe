#!/usr/bin/env bash
#
# installApps.sh — run as adm from ~/frappe-bench-T1LAB
#
# Prepares the bench for a production database restore:
#   1. pip-installs the three bespoke apps (ce_sri, returnable, route_planner)
#   2. Updates sites/apps.txt
#   3. Runs bench migrate to create DocTables for the new apps (pre-restore)
#   4. Places ddlViews.sql from apps/ce_sri/example_srvr_files/views.ddl
#
# The apps must already be rsynced into bench/apps/ before this script runs.
# Run handleRestore.sh after this script completes.
#
set -euo pipefail

source /opt/ce_sri/envars.sh

BENCH_DIR="${HOME}/${TARGET_BENCH_NAME}"
SITE="${ERPNEXT_SITE_URL}"
APPS_TXT="${BENCH_DIR}/sites/apps.txt"
PRIVATE_FILES="${BENCH_DIR}/sites/${SITE}/private/files"

cd "${BENCH_DIR}"

echo "=== installApps.sh: pip-installing bespoke apps ==="
for app in ce_sri returnable route_planner; do
    if [ -d "apps/${app}" ]; then
        echo "  pip install -e apps/${app}"
        env/bin/pip install -e "apps/${app}" --quiet
    else
        echo "  WARNING: apps/${app} not found — skipping (rsync it first)"
    fi
done

echo ""
echo "=== Updating sites/apps.txt ==="
for app in ce_sri returnable route_planner; do
    grep -qxF "${app}" "${APPS_TXT}" || echo "${app}" >> "${APPS_TXT}"
done
echo "  apps.txt: $(tr '\n' ' ' < ${APPS_TXT})"

echo ""
echo "=== bench migrate — creating DocTables for new apps (pre-restore) ==="
bench --site "${SITE}" migrate 2>&1 \
    | grep -E "^(Migrating|Executing|Success|Failed|Updating|Building)" | tail -10
echo "  ... migrate done"

echo ""
echo "=== Placing ddlViews.sql ==="
mkdir -p "${PRIVATE_FILES}"
if [[ -f "apps/ce_sri/example_srvr_files/views.ddl" ]]; then
    cp "apps/ce_sri/example_srvr_files/views.ddl" "${PRIVATE_FILES}/ddlViews.sql"
    echo "  ... placed from apps/ce_sri/example_srvr_files/views.ddl"
elif [[ -f "${PRIVATE_FILES}/ddlViews.sql" ]]; then
    echo "  ... ddlViews.sql already present at ${PRIVATE_FILES}/ddlViews.sql (pre-placed by controller)"
else
    echo "ERROR: ddlViews.sql not found — pre-place it via the controller provision script" >&2
    exit 1
fi

echo ""
echo "=== installApps.sh complete ==="
echo "    Next: ensure BKP/BACKUP.txt and BKP/<backup>.tgz are present, then run:"
echo "    bash BaRe/handleRestore.sh"
