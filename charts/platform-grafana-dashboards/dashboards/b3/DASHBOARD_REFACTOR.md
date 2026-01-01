# B3 Dashboard Refactoring - Handover Document

## Quick Start for New Session

**Files:**
- **Helm Template (EDIT THIS)**: `charts/platform-grafana-dashboards/dashboards/b3/dashboard.json`
- **Clean JSON (GENERATED)**: `hack/dashboard_clean.json` - NEVER edit directly, always regenerate

**Regenerate Command:**
```bash
helm template test charts/platform-grafana-dashboards --set app.name="" --set app.namespace="" --set dashboard.b3.showLicenseMetrics=true > /tmp/helm_output.yaml && \
awk '/^  name: b3dashboard$/,/^---$/' /tmp/helm_output.yaml | \
sed -n '13,/^  overwrite:/p' | head -n -1 | sed 's/^    //' > /tmp/b3_model.yaml && \
python3 -c "import yaml, json; data = yaml.safe_load(open('/tmp/b3_model.yaml')); print(json.dumps(data, indent=2))" > hack/dashboard_clean.json
```

---

## Section Order (COMPLETED)

Sections have been reordered by importance. The new order is:

| # | Section | Row ID | y-pos | Panel Count | Notes |
|---|---------|--------|-------|-------------|-------|
| 1 | Go Runtime & Process | 900 | 0 | 7 panels | expanded |
| 2 | Platform Statistics | 500 | 17 | 4 panels | **collapsed by default** |
| 3 | HTTP Overview | 1 | 32 | 8 panels | expanded |
| 4 | Database | 200 | 65 | 5 panels | expanded |
| 5 | Blob Storage | 800 | 82 | 5 panels | expanded |
| 6 | NATS Messaging | 300 | 99 | 4 panels | expanded |
| 7 | Authentication & Authorization | 100 | 116 | 6 panels | expanded |
| 8 | License (conditional) | 700 | 141 | 7 panels | conditional |

**Rationale:** CPU/runtime metrics first, then platform stats (business KPIs - collapsed as secondary info), then infrastructure layers (HTTP → DB → storage → messaging → auth).

---

## Completed Work Summary

### Query Fixes (All Done):
All counter metrics now use `increase(metric[$__rate_interval])` pattern:
- HTTP Overview section
- Authentication & Authorization section  
- Database section
- NATS Messaging section
- Blob Storage section

### Removed Sections:
- Cluster Proxy - removed entirely
- Cluster Routes - removed entirely

### Panel Title Cleanup (All Done):
Removed unnecessary "Over Time" suffix from 21 panels. Convention: only use "Over Time" when there's a corresponding stat panel.

**Panels renamed:**
- `Authn Attempts by Type Over Time` → `Authn Attempts by Type`
- `Authn Failures Over Time` → `Authn Failures`
- `Authn Failures by Type Over Time` → `Authn Failures by Type`
- `Authz Checks Over Time` → `Authz Checks`
- `Authz Server Errors Over Time` → `Authz Server Errors`
- `DB Operations Over Time` → `DB Operations`
- `Query Latency Percentiles Over Time` → `Query Latency Percentiles`
- `Query Errors Over Time` → `Query Errors`
- `Connections Over Time` → `DB Connections`
- `Connection Errors Over Time` → `Connection Errors`
- `Reconnections Over Time` → `Reconnections`
- `Disconnections Over Time` → `Disconnections`
- `Disconnections by Error Over Time` → `Disconnections by Error`
- `Subscription Errors Over Time` → `Subscription Errors`
- `BlobFS Operations Over Time` → `BlobFS Operations`
- `BlobFS Operations by Type Over Time` → `BlobFS Operations by Type`
- `BlobFS Operations by Storage Over Time` → `BlobFS Operations by Storage`
- `BlobFS Errors Over Time` → `BlobFS Errors`
- `BlobFS Errors by Operation Over Time` → `BlobFS Errors by Operation`
- `Issuances by Type Over Time` → `Issuances by Type`
- `Validations by Type Over Time` → `Validations by Type`

**Panels that KEEP "Over Time" suffix (have stat counterparts):**
- `CPU Usage Over Time (Cores)` - has "Current CPU (Cores)" stat
- `Memory Over Time (RSS)` - has memory breakdown
- `Licenses Issued Over Time` - has "Total Licenses Issued" stat
- `Users Over Time` - has "Total Users" stat

---

## Key Design Decisions

### 1. Counter vs Gauge Metrics
| Metric Type | Query Pattern | Example |
|-------------|---------------|---------|
| Counter | `increase(metric[$__rate_interval])` | `b3_http_server_request_count` |
| Gauge | `metric` (direct) | `go_goroutines`, `b3_db_connections_active` |
| Histogram | `histogram_quantile(0.99, rate(bucket[5m]))` | `b3_http_server_request_duration_bucket` |

### 2. License Section Exception
License panels use **raw counters** (not `increase()`) because:
- Business needs exact cumulative totals ("Total Licenses Issued")
- `increase()` can produce fractional values due to extrapolation
- Timeseries shows growth trajectory, not rate

### 3. Legend Calcs Strategy
| Panel Type | Legend Calcs |
|------------|--------------|
| Error/count panels | `["sum"]` |
| Categorical breakdowns | `[]` (empty) |
| Continuous metrics | `["mean", "max"]` |

### 4. No Data Handling
All panels should have:
```json
"noValue": "No data found in response"
```

### 5. Decimals
- Counts/distributions: `decimals: 0`
- Error rates: `decimals: 2`

---

## Metric Reference

### Counters (use increase()):
- `b3_http_server_request_count` - HTTP requests
- `b3_auth_attempts_total` - Auth attempts
- `b3_auth_failures_total` - Auth failures
- `b3_authz_check_count` - Authz checks
- `b3_db_client_operation_count` - DB operations
- `b3_db_client_connection_error_count` - DB connection errors
- `b3_messaging_reconnect_count` - NATS reconnections
- `b3_messaging_disconnect_count` - NATS disconnections
- `b3_messaging_subscription_error_count` - NATS subscription errors
- `b3_blobfs_operations_total` - BlobFS operations

### Gauges (use directly):
- `go_goroutines` - Current goroutine count
- `go_threads` - Current thread count
- `process_open_fds` - Current open file descriptors
- `process_resident_memory_bytes` - Current memory
- `go_memstats_*` - Memory stats
- `b3_http_server_active_requests` - Current active requests
- `b3_db_connections_active` - Current active DB connections
- `b3_db_connections_idle` - Current idle DB connections

### Histograms (use histogram_quantile + rate):
- `b3_http_server_request_duration_bucket` - HTTP latency
- `b3_db_client_operation_duration_bucket` - DB latency
- `go_gc_duration_seconds` - GC pause duration

---

## Progress Tracker

- [x] Go Runtime & Process - correct (uses gauges/rate)
- [x] HTTP Overview - queries fixed
- [x] Authentication & Authorization - queries fixed
- [x] Database - queries fixed
- [x] NATS Messaging - queries fixed
- [x] Blob Storage - queries fixed
- [x] License - intentionally uses raw counters
- [x] Platform Statistics - correct (uses gauges)
- [x] Cluster Proxy - REMOVED
- [x] Cluster Routes - REMOVED
- [x] Panel title cleanup - 21 panels renamed
- [x] Clean JSON regenerated
- [x] **Reorder sections by importance - COMPLETED**

---

## Section Details (Current State)

### 1. Go Runtime & Process (id=900, y=0) - DO NOT MODIFY
- Process Uptime (stat)
- CPU Usage Over Time (Cores) (timeseries)
- Memory Over Time (RSS) (timeseries)
- Current CPU (Cores) (stat)
- Goroutines (timeseries)
- GC Pause Duration (timeseries)
- File Descriptors (timeseries)

### 2. Platform Statistics (id=500, y=17) - COLLAPSED BY DEFAULT
- Total Users (stat)
- Total Teams (stat)
- Total Organizations (stat)
- Users Over Time (timeseries)

### 3. HTTP Overview (id=1, y=32)
- HTTP Requests (timeseries)
- HTTP Requests by Method (timeseries)
- HTTP Errors (timeseries)
- Top HTTP Error Routes (table)
- HTTP Status Code Distribution (bargauge)
- Active HTTP Requests (timeseries)
- HTTP Request Latency Percentiles (timeseries)
- Slowest HTTP Routes (P99) (table)

### 4. Database (id=200, y=65)
- DB Operations (timeseries)
- Query Latency Percentiles (timeseries)
- Query Errors (timeseries)
- DB Connections (timeseries)
- Connection Errors (timeseries)

### 5. Blob Storage (id=800, y=82)
- BlobFS Operations (timeseries)
- BlobFS Operations by Type (timeseries)
- BlobFS Operations by Storage (timeseries)
- BlobFS Errors (timeseries)
- BlobFS Errors by Operation (timeseries)

### 6. NATS Messaging (id=300, y=99)
- Reconnections (timeseries)
- Disconnections (timeseries)
- Disconnections by Error (timeseries)
- Subscription Errors (timeseries)

### 7. Authentication & Authorization (id=100, y=116)
- Authn Attempts (timeseries)
- Authn Attempts by Type (timeseries)
- Authn Failures (timeseries)
- Authn Failures by Type (timeseries)
- Authz Checks (timeseries)
- Authz Server Errors (timeseries)

### 8. License (id=700, y=141) - CONDITIONAL
- Total Licenses Issued (stat)
- Licenses Issued Over Time (timeseries)
- Total Failed Issuances (stat)
- Issuances by Type (timeseries)
- Total Validations (stat)
- Total Failed Validations (stat)
- Validations by Type (timeseries)
