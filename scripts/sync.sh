#!/usr/bin/env bash
set -euo pipefail

# Syncs Google API protos from googleapis/googleapis upstream.
# Designed to be run by CI (sync-upstream.yml) or manually.

UPSTREAM_REPO="https://github.com/googleapis/googleapis.git"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMP_DIR=$(mktemp -d)

cleanup() { rm -rf "${TEMP_DIR}"; }
trap cleanup EXIT

echo "==> Shallow cloning googleapis (sparse checkout)..."
cd "${TEMP_DIR}"
git init -q
git remote add origin "${UPSTREAM_REPO}"
git config core.sparseCheckout true

# Only fetch the directories we care about.
cat > .git/info/sparse-checkout <<'PATHS'
google/api/
google/rpc/
PATHS

git pull --depth=1 origin master -q

echo "==> Syncing google/api/..."
rm -rf "${REPO_ROOT}/google/api"
cp -r "${TEMP_DIR}/google/api" "${REPO_ROOT}/google/api"

echo "==> Syncing google/rpc/..."
rm -rf "${REPO_ROOT}/google/rpc"
cp -r "${TEMP_DIR}/google/rpc" "${REPO_ROOT}/google/rpc"

echo "==> Done. Files synced to ${REPO_ROOT}"
echo ""
echo "Changed files:"
cd "${REPO_ROOT}"
git diff --stat || true
git ls-files --others --exclude-standard || true
