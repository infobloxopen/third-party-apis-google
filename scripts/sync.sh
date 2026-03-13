#!/usr/bin/env bash
set -euo pipefail

# Syncs Google API protos from googleapis/googleapis upstream.
# Run this when you want to pull in new upstream changes.

UPSTREAM="https://raw.githubusercontent.com/googleapis/googleapis/master"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Syncing google/api/ protos..."
for f in annotations.proto http.proto client.proto field_behavior.proto resource.proto launch_stage.proto; do
    echo "  ${f}"
    curl -sfL "${UPSTREAM}/google/api/${f}" -o "${REPO_ROOT}/google/api/${f}" 2>/dev/null || echo "  (not found, skipping)"
done

echo "Syncing google/rpc/ protos..."
for f in status.proto error_details.proto code.proto; do
    echo "  ${f}"
    curl -sfL "${UPSTREAM}/google/rpc/${f}" -o "${REPO_ROOT}/google/rpc/${f}" 2>/dev/null || echo "  (not found, skipping)"
done

echo "Done. Review changes with 'git diff' and commit if satisfied."
