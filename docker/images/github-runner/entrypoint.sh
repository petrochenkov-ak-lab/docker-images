#!/usr/bin/env bash
set -euo pipefail

RUNNER_DIR="/actions-runner"
WORK_DIR="${RUNNER_DIR}/_work"
ORG_URL="https://github.com/petrochenkov-ak-lab"

# --- Validate required environment variables, fail fast if anything is missing ---
require_env() {
    local name="$1"
    if [[ -z "${!name:-}" ]]; then
        echo "ERROR: environment variable '${name}' is required but not set" >&2
        exit 1
    fi
}

require_env RUNNER_TOKEN
require_env RUNNER_NAME
require_env RUNNER_LABELS
require_env RUNNER_EPHEMERAL

case "${RUNNER_EPHEMERAL}" in
    true|false) ;;
    *)
        echo "ERROR: RUNNER_EPHEMERAL must be 'true' or 'false', got: '${RUNNER_EPHEMERAL}'" >&2
        exit 1
        ;;
esac

cd "${RUNNER_DIR}"

# Remove stale registration left over from a previous container run
if [[ -f ".runner" ]]; then
    echo "Existing runner registration found, removing it first"
    ./config.sh remove --token "${RUNNER_TOKEN}" || true
fi

EXTRA_ARGS=(--unattended --replace --labels "${RUNNER_LABELS}")
if [[ "${RUNNER_EPHEMERAL}" == "true" ]]; then
    EXTRA_ARGS+=(--ephemeral)
fi

./config.sh \
    --url "${ORG_URL}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --work "${WORK_DIR}" \
    "${EXTRA_ARGS[@]}"

# Deregister cleanly when the container is stopped
deregister() {
    ./config.sh remove --token "${RUNNER_TOKEN}" || true
}
trap deregister SIGINT SIGTERM

./run.sh &
RUNNER_PID=$!
wait "${RUNNER_PID}"
