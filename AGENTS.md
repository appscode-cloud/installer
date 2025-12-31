# Agent Handover: Grafana Dashboard Refinement

## Context & Goals
We are refining the **Grafana B3 Dashboard** to improve visibility into minor/rare errors and provide a polished UX for "No Data" states.

## Key Principles & Preferences
1. **No Data UX:**
   - Always show **"No data found in response"** instead of `0` for error tracking or counts.
   - Remove `or vector(0)` from Prometheus queries to allow true "No Data" states.
   - Set `noDataText: "No data found in response"` in `fieldConfig.defaults`.
2. **Absolute Counts over Rates:**
   - Distribution charts (e.g., Status Code) use `increase(...[$__range])` instead of `rate()`.
   - Use the pattern `(increase(metric[$__range]) or metric)` to capture 0-to-1 jumps (Prometheus `increase` needs 2 points; this fallback ensures single events show up).
3. **Precision:**
   - **Counts/Distributions:** Set `decimals: 0` to avoid extrapolation artifacts (e.g., "2.01").
   - **Error Rates:** Set `decimals: 2` to ensure minor errors (e.g., 0.01%) aren't rounded to 0%.
4. **Layout (24-unit grid):**
   - Tables with long strings (like Routes) should span the full width (`w: 24`).
   - Small metrics should be grouped on single rows (e.g., Widths 4, 4, 16).

## Current State of Files
- **`charts/platform-grafana-dashboards/dashboards/b3/dashboard.json`**: Helm template. Modified queries, layout, and field configs.
- **`hack/dashboard_clean.json`**: Pure JSON reference. **NEVER edit this file directly.** It must be generated from the Helm template to ensure consistency.

## Dashboard Synchronization (Syncing `dashboard.json` to `dashboard_clean.json`)
To regenerate the clean JSON from the Helm template, run the following commands from the project root:
```bash
# 1. Generate the full Helm output
helm template test charts/platform-grafana-dashboards --set app.name="" --set app.namespace="" > /tmp/helm_output.yaml

# 2. Extract the spec.model section for b3 dashboard and convert to JSON
awk '/^  name: b3dashboard$/,/^---$/' /tmp/helm_output.yaml | \
sed -n '13,/^  overwrite:/p' | head -n -1 | sed 's/^    //' > /tmp/b3_model.yaml && \
python3 -c "import yaml, json; data = yaml.safe_load(open('/tmp/b3_model.yaml')); print(json.dumps(data, indent=2))" > hack/dashboard_clean.json
```

## Knowledge Gathered
- **Manual Edits:** Direct edits to `hack/dashboard_clean.json` will be lost. Always modify `charts/platform-grafana-dashboards/dashboards/b3/dashboard.json` first.
- **Random Walk Issue:** If a panel query (`target`) lacks a `datasource` property, Grafana ignores the panel-level datasource and generates random data. Always verify `target.datasource` in `dashboard.json`.
- **Prometheus Increase:** `increase()` extrapolates and returns `NaN` for single-point series. The `(increase(...) or metric)` pattern is the workaround for absolute counters.
- **Table Bug:** If a Table panel shows "cannot read properties of undefined (reading 'calcs')", ensure `options.sortBy` matches the actual field name (or the name after an `organize` transformation).
