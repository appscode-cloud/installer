# Dashboard Porting Instructions

## Overview
Port UI changes from `hack/dashboard_clean.json` into `charts/platform-grafana-dashboards/dashboards/b3/dashboard.json` while preserving Helm templating.

## CURRENT STATUS (Updated 2025-01-01)

### Completed
1. **Fixed Helm template escaping** - Changed all `{{ "{{" }}var{{ "}}" }}` patterns to `` {{`{{var}}`}} `` (raw string syntax)
2. **Fixed conditional comma issue** - License section conditional now has correct comma placement
3. **Helm template now compiles successfully**
4. **Removed major duplicate panels** - Duplicate rows and most duplicate panels removed
5. **All panel IDs are now unique** - 67 panels without license, 74 with license
6. **Fixed Cluster Routes row y-position** - Changed from y=101 to y=157
7. **Added missing Cluster Proxy panels** - Proxy Request Rate (ID 12), Proxy Error Rate (ID 61), Proxy Latency Percentiles (ID 13)
8. **Added missing Cluster Routes Error Rate panel (ID 72)**
9. **Fixed License section y-positions** - Row at y=182, panels at y=183 and y=191
10. **Fixed Blob Storage and Platform Statistics y-positions** - Sequential after License section

### How Conditional License Section Works
The License section is wrapped in `{{- if .Values.dashboard.b3.showLicenseMetrics }}`. The sections after License (Blob Storage, Platform Statistics) have y-positions that **intentionally overshoot** to account for the License section height.

**When License is enabled:**
- Cluster Routes ends at y=182
- License occupies y=182-199
- Blob Storage starts at y=199 (seamless flow)

**When License is disabled:**
- Cluster Routes ends at y=182
- Gap from y=182 to y=199 (License removed from JSON)
- Blob Storage at y=199
- **Grafana automatically collapses the gap** and shifts panels up

This avoids needing Helm conditionals for every panel's y-position after License.

### Current Section Layout

| Section | Row ID | Row y | Panels y range | Ends at |
|---------|--------|-------|----------------|---------|
| HTTP Overview | 1 | 0 | 1-32 | 32 |
| Authentication & Authorization | 100 | 32 | 33-74 | 74 |
| Database | 200 | 74 | 75-99 | 99 |
| NATS Messaging | 300 | 99 | 100-132 | 132 |
| Cluster Proxy | 400 | 132 | 133-157 | 157 |
| Cluster Routes | 600 | 157 | 158-182 | 182 |
| License (conditional) | 700 | 182 | 183-199 | 199 |
| Blob Storage | 800 | 199 | 200-221 | 221 |
| Platform Statistics | 500 | 221 | 222-236 | 236 |

## NEXT STEPS / TODO

### License Section Redesign (HIGH PRIORITY)
The current License panels show **rates** which are not useful since license operations are infrequent. Need to replace with **running totals** and **time series**.

**Current panels (to replace):**
- License Issuance Rate (ID 80)
- Issuance by Type (ID 81)
- Failed Issuance Rate (ID 83)
- License Validation Rate (ID 84)
- Validation by Type (ID 85)
- Failed Validation Rate (ID 87)

**New panel design:**

| Panel | ID | gridPos | Query | Type |
|-------|-----|---------|-------|------|
| Total Licenses Issued | 80 | 0,183,8,8 | `sum(b3_license_issuances_total{namespace="$namespace", pod=~"$pod"})` | stat |
| Licenses Issued Over Time | 81 | 8,183,16,8 | `sum(b3_license_issuances_total{...})` | timeseries |
| Total Failed Issuances | 82 | 0,191,8,4 | `sum(b3_license_issuances_total{..., success="false"})` | stat |
| Issuances by Type | 83 | 8,191,8,4 | `sum by(license_type)(b3_license_issuances_total{...})` | timeseries |
| Total Validations | 84 | 0,195,8,4 | `sum(b3_license_validations_total{...})` | stat |
| Total Failed Validations | 85 | 8,195,8,4 | `sum(b3_license_validations_total{..., success="false"})` | stat |
| Validations by Type | 86 | 16,191,8,8 | `sum by(license_type)(b3_license_validations_total{...})` | timeseries |

**Key changes:**
- Use `sum()` instead of `rate()` for totals
- Add stat panels for at-a-glance totals
- Keep timeseries for trends over time
- Remove redundant "Rate" panels

## Key Rules
1. **Never edit `dashboard_clean.json` directly** - it's generated from the Helm template
2. **Preserve Helm templating** in `dashboard.json`:
   - `` {{`{{variable}}`}} `` for Grafana template variables in legendFormat (RAW STRING SYNTAX)
   - `{{- if .Values.dashboard.b3.showLicenseMetrics }}` conditionals
   - `${datasource}`, `$namespace`, `$pod` variable references
3. **Match panel IDs** when updating existing panels
4. **Update `gridPos` (x,y,w,h)** to match UI layout
5. **License section (IDs 700, 80-87) is conditional** - wrapped in `{{- if .Values.dashboard.b3.showLicenseMetrics }}`

## IMPORTANT: Helm Escaping for Grafana Variables

**CORRECT:**
```json
"legendFormat": "{{`{{http_request_method}}`}}"
```

**WRONG (causes template parsing error):**
```json
"legendFormat": "{{ \"{{\" }}http_request_method{{ \"}}\" }}"
```

The raw string syntax `` {{`...`}} `` passes content through unchanged, which is required because Helm's `tpl` function processes the dashboard twice.

## Dashboard Regeneration Commands

### Generate dashboard WITHOUT license (default)
```bash
helm template test charts/platform-grafana-dashboards --set app.name="" --set app.namespace="" > /tmp/helm_output.yaml
awk '/^  name: b3dashboard$/,/^---$/' /tmp/helm_output.yaml | \
sed -n '13,/^  overwrite:/p' | head -n -1 | sed 's/^    //' > /tmp/b3_model.yaml && \
python3 -c "import yaml, json; data = yaml.safe_load(open('/tmp/b3_model.yaml')); print(json.dumps(data, indent=2))" > hack/dashboard_clean.json
```

### Generate dashboard WITH license
```bash
helm template test charts/platform-grafana-dashboards --set app.name="" --set app.namespace="" --set dashboard.b3.showLicenseMetrics=true > /tmp/helm_output.yaml
awk '/^  name: b3dashboard$/,/^---$/' /tmp/helm_output.yaml | \
sed -n '13,/^  overwrite:/p' | head -n -1 | sed 's/^    //' > /tmp/b3_model.yaml && \
python3 -c "import yaml, json; data = yaml.safe_load(open('/tmp/b3_model.yaml')); print(json.dumps(data, indent=2))" > hack/dashboard_clean_license.json
```

## Panel Template Examples

### New Timeseries Panel (Total counter)
```json
{
  "datasource": "${datasource}",
  "fieldConfig": {
    "defaults": {
      "color": { "mode": "palette-classic" },
      "decimals": 0,
      "unit": "short"
    }
  },
  "gridPos": { "h": 8, "w": 12, "x": 0, "y": 1 },
  "id": NEW_ID,
  "targets": [{
    "datasource": "${datasource}",
    "expr": "sum(METRIC{namespace=\"$namespace\", pod=~\"$pod\"})",
    "legendFormat": "LEGEND",
    "refId": "A"
  }],
  "title": "TITLE",
  "type": "timeseries"
}
```

### Stat Panel (for totals)
```json
{
  "datasource": "${datasource}",
  "fieldConfig": {
    "defaults": {
      "decimals": 0,
      "noDataText": "No data found in response",
      "thresholds": {
        "mode": "absolute",
        "steps": [{ "color": "green", "value": null }]
      }
    }
  },
  "gridPos": { "h": 4, "w": 8, "x": 0, "y": 1 },
  "id": NEW_ID,
  "options": {
    "colorMode": "value",
    "graphMode": "area",
    "justifyMode": "center",
    "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false },
    "textMode": "auto"
  },
  "targets": [{
    "datasource": "${datasource}",
    "expr": "sum(METRIC{namespace=\"$namespace\", pod=~\"$pod\"})",
    "refId": "A"
  }],
  "title": "TITLE",
  "type": "stat"
}
```

### Table Panel with Transformations
```json
{
  "type": "table",
  "transformations": [{
    "id": "organize",
    "options": {
      "excludeByName": { "Time": true },
      "renameByName": {
        "http_route": "Route",
        "Value": "Error Count"
      }
    }
  }],
  "options": {
    "showHeader": true,
    "sortBy": [{ "desc": true, "displayName": "Error Count" }]
  }
}
```

## Files

- **Template file**: `charts/platform-grafana-dashboards/dashboards/b3/dashboard.json`
- **Generated (no license)**: `hack/dashboard_clean.json`
- **Generated (with license)**: `hack/dashboard_clean_license.json`
