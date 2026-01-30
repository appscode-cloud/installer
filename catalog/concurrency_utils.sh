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

# Concurrency and retry utilities for parallel task execution

# Initialize concurrency control
# Usage: init_concurrency
# Sets up FIFO for worker pool
init_concurrency() {
    local max_workers=${MAX_WORKERS:-8}
    FIFO=$(mktemp -u) && mkfifo "$FIFO"
    exec 3<>"$FIFO" && rm "$FIFO"
    for ((i = 0; i < max_workers; i++)); do echo >&3; done
}

# Default max retries (can be overridden via MAX_RETRIES env var)
MAX_RETRIES=${MAX_RETRIES:-3}
FAILED_FILE=$(mktemp)

# Run a command asynchronously with retry logic
# Usage: run_async <command> [args...]
# Commands are executed with up to MAX_RETRIES attempts and exponential backoff
run_async() {
    read -r -u 3
    {
        trap 'echo >&3' EXIT
        local max_attempts=$MAX_RETRIES
        local attempt=1
        local output=""
        local exit_code=0

        while [ "$attempt" -le "$max_attempts" ]; do
            output=$("$@" 2>&1)
            exit_code=$?
            if [ "$exit_code" -eq 0 ]; then
                echo -e "\033[32mCompleted: $*\033[0m" >&2
                break
            fi
            attempt=$((attempt + 1))
            if [ "$attempt" -le "$max_attempts" ]; then
                local retry_msg
                printf -v retry_msg '\033[33mAttempt %d failed for \047%s\047 (exit %d)\033[0m\nOutput: %s\n\033[33mRetrying...\033[0m' \
                    $((attempt - 1)) "$*" "$exit_code" "$output"
                echo -e "$retry_msg" >&2
                # Linear backoff: 2s, 4s, 6s... + small jitter (0-2s)
                local base_delay=$((attempt * 2))
                local jitter=$((RANDOM % 3))
                sleep $((base_delay + jitter))
            fi
        done

        if [ "$exit_code" -ne 0 ]; then
            local msg
            printf -v msg 'FAILED: %s\nExit code: %d\nOutput:\n%s\n-----------------------------------------' \
                "$*" "$exit_code" "$output"
            echo -e "\033[31mFAILED: $1 (exit $exit_code)\033[0m" >&2
            echo "$msg" >>"$FAILED_FILE"
        fi
    } &
}

# Check for failed tasks and print summary
# Usage: check_failed_tasks <operation_name>
# operation_name: description like "IMPORTS" or "EXPORTS"
check_failed_tasks() {
    local operation_name="${1:-OPERATIONS}"
    echo "" >&2
    if [ -s "$FAILED_FILE" ]; then
        echo "========================================" >&2
        echo "=== FAILED $operation_name ===" >&2
        echo "========================================" >&2
        cat "$FAILED_FILE" >&2
        rm -f "$FAILED_FILE"
        exit 1
    else
        echo "All $operation_name completed successfully." >&2
    fi
    rm -f "$FAILED_FILE"
}

# Wait for all async tasks to complete
# Usage: wait_async
wait_async() {
    wait
    exec 3>&-
}

# Start a background progress reporter
# Usage: start_progress_reporter <directory> <interval_seconds>
# Prints size and file count every interval
PROGRESS_PID=""
start_progress_reporter() {
    local dir="$1"
    local interval="${2:-10}"
    (
        while true; do
            sleep "$interval"
            if [ -d "$dir" ]; then
                local count size
                count=$(find "$dir" -type f -name '*.tar' 2>/dev/null | wc -l)
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                echo "[$(date '+%H:%M:%S')] $count files, $size" >&2
            fi
        done
    ) &
    PROGRESS_PID=$!
}

# Stop the background progress reporter
stop_progress_reporter() {
    if [ -n "$PROGRESS_PID" ]; then
        kill "$PROGRESS_PID" 2>/dev/null || true
        wait "$PROGRESS_PID" 2>/dev/null || true
        PROGRESS_PID=""
    fi
}

# Cleanup handler to kill all child processes on exit/interrupt
cleanup() {
    trap - EXIT INT TERM
    stop_progress_reporter
    kill 0 2>/dev/null || true
}
trap cleanup EXIT INT TERM
