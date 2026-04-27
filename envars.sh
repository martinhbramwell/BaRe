#!/usr/bin/env bash
#
# BaRe default environment variables.
#
# Minimum surface required by handleRestore.sh and utils.sh. Deployers
# (ESACP Stage 6 generic mode, ce_sri install scripts, production master
# deploy) override this file by replacing it or by pointing a symlink at
# a customer-specific envars.sh. See utils.sh sourcing logic.
#
# Other BaRe scripts (installApps.sh, ros.sh, rSYNC.sh, trimLog.sh)
# reference additional variables not declared here — extend as their own
# usage gates require.

# Restore-behaviour flags (safe defaults).
export RESTORE_SITE_CONFIG="no"
export KEEP_SITE_PASSWORD="yes"

# Optional API keys for /private/files/apikey.sh recreation post-restore.
# handleRestore.sh guards reads with ${KEYS:-}, so an empty default is fine.
export KEYS=""

# Site/bench/db identity. Deployer MUST populate before handleRestore.sh runs;
# missing values will fail loudly inside handleRestore.sh.
export ERPNEXT_SITE_URL=""
export TARGET_BENCH=""
export MYPWD=""
