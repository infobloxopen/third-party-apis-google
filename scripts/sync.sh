#!/usr/bin/env bash
set -euo pipefail

# Syncs Google API core protos from googleapis/googleapis upstream.
# Only syncs the commonly-needed protos, not every GCP service definition.

UPSTREAM="https://raw.githubusercontent.com/googleapis/googleapis/master"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Core google/api protos that services commonly import.
API_PROTOS=(
    annotations.proto
    client.proto
    field_behavior.proto
    field_info.proto
    http.proto
    httpbody.proto
    launch_stage.proto
    resource.proto
    routing.proto
    visibility.proto
)

# Core google/rpc protos.
RPC_PROTOS=(
    code.proto
    error_details.proto
    status.proto
)

echo "==> Syncing google/api/ core protos..."
mkdir -p "${REPO_ROOT}/google/api"
for f in "${API_PROTOS[@]}"; do
    if curl -sfL "${UPSTREAM}/google/api/${f}" -o "${REPO_ROOT}/google/api/${f}"; then
        echo "  ✓ ${f}"
    else
        echo "  - ${f} (not found upstream, skipping)"
        rm -f "${REPO_ROOT}/google/api/${f}"
    fi
done

echo "==> Syncing google/rpc/ core protos..."
mkdir -p "${REPO_ROOT}/google/rpc"
for f in "${RPC_PROTOS[@]}"; do
    if curl -sfL "${UPSTREAM}/google/rpc/${f}" -o "${REPO_ROOT}/google/rpc/${f}"; then
        echo "  ✓ ${f}"
    else
        echo "  - ${f} (not found upstream, skipping)"
        rm -f "${REPO_ROOT}/google/rpc/${f}"
    fi
done

echo "==> Done."
