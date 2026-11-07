#!/bin/bash

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

mode="${1:-}"
if [[ -n "$mode" && "$mode" != "--verify" ]]; then
    echo "usage: $0 [--verify]" >&2
    exit 2
fi

root="$(cd "$(dirname "$0")/../.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cp -R "$root/charts/akp-installer/." "$tmp/"
rm -f "$tmp/.DS_Store"
yq -y --indentless -i '.name = "ace-installer" | .description = "ACE Installer" | .annotations["charts.openshift.io/name"] = "ace-installer"' "$tmp/Chart.yaml"
yq -y --indentless -i '.project.name = "ACE Installer" | .project.shortName = "ACE Installer" | .project.description = "ACE Installer" | .chart.name = "ace-installer" | .release.name = "ace-installer"' "$tmp/doc.yaml"
mv "$tmp/akp-installer.sample.yaml" "$tmp/ace-installer.sample.yaml"

if [[ "$mode" == "--verify" ]]; then
    if ! diff -qr --exclude='.DS_Store' --exclude='README.md' --exclude='charts' "$tmp" "$root/charts/ace-installer"; then
        echo "charts/ace-installer is out of sync with charts/akp-installer; run make update-legacy-chart" >&2
        exit 1
    fi

    akp_charts="$tmp/charts"
    ace_charts="$root/charts/ace-installer/charts"
    if [[ -d "$akp_charts" && ! -d "$ace_charts" ]] || [[ ! -d "$akp_charts" && -d "$ace_charts" ]]; then
        echo "charts/ace-installer dependency charts are out of sync with charts/akp-installer" >&2
        exit 1
    fi
    if [[ -d "$akp_charts" ]]; then
        find "$akp_charts" -maxdepth 1 -type f -name '*.tgz' -exec basename {} \; | LC_ALL=C sort >"$tmp/akp-archives"
        find "$ace_charts" -maxdepth 1 -type f -name '*.tgz' -exec basename {} \; | LC_ALL=C sort >"$tmp/ace-archives"
        if ! diff -u "$tmp/akp-archives" "$tmp/ace-archives"; then
            echo "charts/ace-installer dependency archives differ from charts/akp-installer" >&2
            exit 1
        fi

        while IFS= read -r archive; do
            [[ -n "$archive" ]] || continue
            tar -tzf "$akp_charts/$archive" | LC_ALL=C sort >"$tmp/akp-members"
            tar -tzf "$ace_charts/$archive" | LC_ALL=C sort >"$tmp/ace-members"
            if ! diff -u "$tmp/akp-members" "$tmp/ace-members"; then
                echo "dependency archive member lists differ: $archive" >&2
                exit 1
            fi

            while IFS= read -r member; do
                [[ -n "$member" ]] || continue
                tar -xOzf "$akp_charts/$archive" "$member" >"$tmp/akp-member"
                tar -xOzf "$ace_charts/$archive" "$member" >"$tmp/ace-member"
                if ! cmp -s "$tmp/akp-member" "$tmp/ace-member"; then
                    echo "dependency archive contents differ: $archive ($member)" >&2
                    exit 1
                fi
            done <"$tmp/akp-members"
        done <"$tmp/akp-archives"
    fi

    echo "charts/ace-installer source files and dependency contents are in sync with charts/akp-installer"
    exit 0
fi

mkdir -p "$root/charts/ace-installer"
rsync -a --delete --exclude='.DS_Store' "$tmp/" "$root/charts/ace-installer/"
