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
    local max_workers=${MAX_WORKERS:-20}
    FIFO=$(mktemp -u) && mkfifo "$FIFO"
    exec 3<>"$FIFO" && rm "$FIFO"
    for ((i = 0; i < max_workers; i++)); do echo >&3; done
}

# Default max retries (can be overridden via MAX_RETRIES env var)
MAX_RETRIES=${MAX_RETRIES:-3}
FAILED_FILE=$(mktemp)
RUNNING_DIR=$(mktemp -d)

# Run a command asynchronously with retry logic
# Usage: run_async <task_desc> <command> [args...]
# Commands are executed with up to MAX_RETRIES attempts and exponential backoff
run_async() {
    local task_desc="$1"
    shift
    read -r -u 3
    {
        local task_file="$RUNNING_DIR/$$"
        echo "$task_desc" >"$task_file"

        local max_attempts=$MAX_RETRIES
        local attempt=1
        local output=""
        local exit_code=0

        while [ "$attempt" -le "$max_attempts" ]; do
            output=$("$@" 2>&1)
            exit_code=$?
            if [ "$exit_code" -eq 0 ]; then
                break
            fi
            attempt=$((attempt + 1))
            if [ "$attempt" -le "$max_attempts" ]; then
                # Exponential backoff: base + jitter (30%-100% of base)
                local base_delay=$((2 ** attempt))
                local jitter=$(((RANDOM % 71 + 30) * base_delay / 100))
                sleep $((base_delay + jitter))
            fi
        done

        rm -f "$task_file"

        if [ "$exit_code" -ne 0 ]; then
            local msg
            printf -v msg 'FAILED: %s\nCommand: %s\nExit code: %d\nOutput:\n%s\n-----------------------------------------' \
                "$task_desc" "$*" "$exit_code" "$output"
            echo -e "\033[31mFAILED: $task_desc (exit $exit_code)\033[0m" >&2
            echo "$msg" >>"$FAILED_FILE"
        fi
        echo >&3
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
                local count size running
                count=$(find "$dir" -type f -name '*.tar' 2>/dev/null | wc -l)
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                running=$(head -1 "$RUNNING_DIR"/* 2>/dev/null | head -1)
                if [ -n "$running" ]; then
                    echo "[$(date '+%H:%M:%S')] $count files, $size | $running" >&2
                else
                    echo "[$(date '+%H:%M:%S')] $count files, $size" >&2
                fi
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
    rm -rf "$RUNNING_DIR" 2>/dev/null || true
    kill 0 2>/dev/null || true
}
trap cleanup EXIT INT TERM
