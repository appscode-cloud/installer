#!/usr/bin/env bash

# Copyright AppsCode Inc. and Contributors
#
# Licensed under the AppsCode Community License 1.0.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://github.com/appscode/licenses/raw/1.0.0/AppsCode-Community-1.0.0.md
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

MAX_WORKERS=${MAX_WORKERS:-8}
MAX_RETRIES=${MAX_RETRIES:-3}
TIMEOUT=${TIMEOUT:-300}
FAIL_LOG=$(mktemp)

cleanup() {
    trap - EXIT INT TERM
    kill 0 2>/dev/null || true
    rm -f "$FAIL_LOG"
}
trap cleanup EXIT INT TERM

# Usage: run_async "description" command [args...]
run_async() {
    local desc="$1"
    shift
    while [[ $(jobs -r | wc -l) -ge $MAX_WORKERS ]]; do wait -n || true; done

    (
        local out exit_code attempt=1
        while [[ $attempt -le $MAX_RETRIES ]]; do
            out=$(timeout "$TIMEOUT" "$@" 2>&1) && {
                printf '\033[32m✓ %s\033[0m\n' "$desc" >&2
                exit 0
            }
            exit_code=$?
            ((attempt++))
            [[ $attempt -gt $MAX_RETRIES ]] && break
            printf '\033[38;5;208m⚠ %s (attempt %d/%d, exit %d)\n%s\033[0m\n' "$desc" "$attempt" "$MAX_RETRIES" "$exit_code" "$out" >&2
            sleep $((attempt * 2 + RANDOM % 3))
        done
        printf '\033[31m✗ %s (failed, exit %d)\n%s\033[0m\n' "$desc" "$exit_code" "$out" >&2
        {
            flock 200
            printf '%s\nexit=%d\n%s\n---\n' "$desc" "$exit_code" "$out" >&200
        } 200>>"$FAIL_LOG"
        exit 1
    ) &
}

# Wait for all jobs, print summary, return 1 if any failed
wait_all() {
    wait
    echo "---" >&2
    if [[ -s "$FAIL_LOG" ]]; then
        printf '\033[31mFailed tasks:\033[0m\n' >&2
        cat "$FAIL_LOG" >&2
        return 1
    fi
    printf '\033[32mAll tasks completed successfully\033[0m\n' >&2
}
