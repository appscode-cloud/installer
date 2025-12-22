# B3 Metrics - Grafana Dashboard Guide

Metrics exported to Prometheus via OpenTelemetry. All dots in metric/label names become underscores.

---

## Complete Metric Reference

### HTTP Server

| Metric | Type | Description |
|--------|------|-------------|
| `b3_http_server_request_count` | Counter | Total HTTP requests |
| `b3_http_server_request_duration` | Histogram | Request latency in seconds |
| `b3_http_server_active_requests` | Gauge | Current in-flight requests |

**Labels** (all metrics except `active_requests`):

| Label | Type | Description |
|-------|------|-------------|
| `http_request_method` | string | `GET`, `POST`, `PUT`, `DELETE`, etc. |
| `http_route` | string | Raw URL path (not normalized - high cardinality) |
| `http_response_status_code` | int | HTTP status code (200, 404, 500, etc.) |

**Histogram buckets (seconds):** 0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10

---

### Authentication

| Metric | Type | Description |
|--------|------|-------------|
| `b3_auth_attempts_total` | Counter | Total authentication attempts |
| `b3_auth_failures_total` | Counter | Failed authentication attempts |

**Labels:**

| Label | Type | Values |
|-------|------|--------|
| `auth_type` | string | `ldap`, `oauth`, `openid`, `token`, `basic`, `no_type`, `u2f`, `2fa`, `pam`, `smtp`, `reverse_proxy`, `unknown` |

---

### Authorization

| Metric | Type | Description |
|--------|------|-------------|
| `b3_authz_check_count` | Counter | Total authorization checks performed |
| `b3_authz_check_allowed_count` | Counter | Authorization checks that were allowed |
| `b3_authz_check_denied_count` | Counter | Authorization checks that were denied |

**Labels:**

| Label | Type | Description |
|-------|------|-------------|
| `authz_server_error` | bool | `true` if check failed due to server error |
| `authz_action` | string | Action being authorized (optional, may be empty) |
| `authz_user` | string | User being checked (optional, may be empty) |
| `authz_object` | string | Object being accessed (optional, may be empty) |
| `authz_relation` | string | Relation being checked (optional, may be empty) |

---

### Database (XORM Client)

| Metric | Type | Description |
|--------|------|-------------|
| `b3_db_client_operation_duration` | Histogram | Query execution time in seconds |
| `b3_db_client_operation_count` | Counter | Total database operations |
| `b3_db_client_connection_error_count` | Counter | Connection errors (dial failures, timeouts, bad connections) |
| `b3_db_connections_active` | Gauge | Currently in-use connections |
| `b3_db_connections_idle` | Gauge | Idle connections in pool |
| `b3_db_connections_limit` | Gauge | Maximum pool size configured |

**Labels:**

| Label | Type | Used By | Description |
|-------|------|---------|-------------|
| `db_system` | string | all | Database type: `postgresql`, `mysql`, etc. |
| `error` | bool | `operation_count` only | `true` if operation failed |

**Histogram buckets (seconds):** 0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10

---

### NATS Messaging

| Metric | Type | Description |
|--------|------|-------------|
| `b3_messaging_publish_count` | Counter | Messages successfully published |
| `b3_messaging_publish_error_count` | Counter | Failed publish attempts |
| `b3_messaging_consume_count` | Counter | Messages consumed/received |
| `b3_messaging_process_duration` | Histogram | Time to process consumed messages (seconds) |
| `b3_messaging_connections_active` | Gauge | Current active NATS connections |
| `b3_messaging_subscription_error_count` | Counter | Subscription failures |
| `b3_messaging_reconnect_count` | Counter | Reconnection events |
| `b3_messaging_disconnect_count` | Counter | Disconnection events |

**Note:** Currently only `subscription_error`, `reconnect`, and `disconnect` are instrumented. Other metrics exist but are not yet wired to NATS operations.

**Labels:**

| Label | Type | Used By | Description |
|-------|------|---------|-------------|
| `messaging_system` | string | all | Always `nats` |
| `messaging_destination_name` | string | publish, publish_error, consume, process_duration, subscription_error | NATS subject name |
| `connection_name` | string | all | Logical connection identifier |
| `error_type` | string | publish_error, subscription_error, disconnect | Error classification (when applicable) |
| `messaging_consumer_id` | string | consume, process_duration | Consumer identifier |
| `server_address` | string | connections_active, reconnect, disconnect | NATS server address |

**Histogram buckets (seconds):** 0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10

---

### Kubernetes Proxy

| Metric | Type | Description |
|--------|------|-------------|
| `b3_proxy_request_duration` | Histogram | Proxy request latency in seconds |
| `b3_proxy_k8s_operation_total` | Counter | Total Kubernetes operations via proxy |

**Labels:**

| Label | Type | Description |
|-------|------|-------------|
| `proxy_k8s_cluster` | string | Target cluster name (may be empty) |
| `proxy_request_status_code` | int | HTTP response status code |

**Histogram buckets (seconds):** 0.1, 0.5, 1, 2, 5, 10, 30, 60, 120 (longer buckets for k8s operations)

---

### Cluster API

| Metric | Type | Description |
|--------|------|-------------|
| `b3_cluster_request_count` | Counter | Total cluster API requests |

**Labels:**

| Label | Type | Description |
|-------|------|-------------|
| `http_request_method` | string | HTTP method |
| `http_route` | string | URL path |
| `http_response_status_code` | int | HTTP status code |

---

### License

| Metric | Type | Description |
|--------|------|-------------|
| `b3_license_issuances_total` | Counter | License issuance events |
| `b3_license_validations_total` | Counter | License validation checks |

**Labels:**

| Label | Type | Description |
|-------|------|-------------|
| `license_type` | string | Type of license being issued/validated |
| `success` | bool | `true` if operation succeeded |

---

### Blob Storage

| Metric | Type | Description |
|--------|------|-------------|
| `b3_blobfs_operations_total` | Counter | Blob storage operations (excludes local filesystem) |

**Labels:**

| Label | Type | Description |
|-------|------|-------------|
| `operation` | string | Operation type (from blobfs.Operation) |
| `storage_type` | string | Storage backend type (excludes `file`) |
| `success` | bool | `true` if operation succeeded |

---

### Legacy Platform Stats (Gitea)

All gauges with no labels. These are current counts polled from the database:

| Metric | Description |
|--------|-------------|
| `b3_gitea_users` | Total users |
| `b3_gitea_organizations` | Total organizations |
| `b3_gitea_repositories` | Total repositories |
| `b3_gitea_teams` | Total teams |
| `b3_gitea_issues` | Total issues |
| `b3_gitea_comments` | Total comments |
| `b3_gitea_labels` | Total labels |
| `b3_gitea_milestones` | Total milestones |
| `b3_gitea_releases` | Total releases |
| `b3_gitea_stars` | Total stars |
| `b3_gitea_watches` | Total watches |
| `b3_gitea_follows` | Total follows |
| `b3_gitea_webhooks` | Total webhooks |
| `b3_gitea_hook_tasks` | Total hook tasks |
| `b3_gitea_mirrors` | Total mirrors |
| `b3_gitea_oauths` | Total OAuth applications |
| `b3_gitea_login_sources` | Total login sources |
| `b3_gitea_public_keys` | Total public keys |
| `b3_gitea_accesses` | Total accesses |
| `b3_gitea_actions` | Total actions |
| `b3_gitea_attachments` | Total attachments |
| `b3_gitea_update_tasks` | Total update tasks |

---

## Dashboard Design

### Row 1: HTTP Overview (Critical)

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Request Rate | Time series | `sum(rate(b3_http_server_request_count[5m]))` | Overall traffic volume |
| Request Rate by Method | Time series (stacked) | `sum by(http_request_method)(rate(b3_http_server_request_count[5m]))` | Traffic breakdown |
| Error Rate % | Stat/Gauge | `sum(rate(b3_http_server_request_count{http_response_status_code=~"4..\|5.."}[5m])) / sum(rate(b3_http_server_request_count[5m])) * 100` | Error percentage (critical health indicator) |
| Latency Percentiles | Time series | `histogram_quantile(0.50, sum(rate(b3_http_server_request_duration_bucket[5m])) by (le))` (repeat for 0.95, 0.99) | P50/P95/P99 latency |
| Active Requests | Time series | `b3_http_server_active_requests` | Concurrency/load indicator |
| Status Code Distribution | Time series (stacked) | `sum by(http_response_status_code)(rate(b3_http_server_request_count[5m]))` | Response code breakdown |
| Top Error Routes | Table | `topk(10, sum by(http_route)(rate(b3_http_server_request_count{http_response_status_code=~"4..\|5.."}[5m])))` | Identify problematic endpoints |
| Slowest Routes (P99) | Table | `topk(10, histogram_quantile(0.99, sum by(http_route, le)(rate(b3_http_server_request_duration_bucket[5m]))))` | Identify slow endpoints |

### Row 2: Authentication & Authorization (Security)

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Auth Attempts Rate | Time series | `sum(rate(b3_auth_attempts_total[5m]))` | Overall auth activity |
| Auth Attempts by Type | Time series (stacked) | `sum by(auth_type)(rate(b3_auth_attempts_total[5m]))` | Auth method usage |
| Auth Failure Rate % | Stat/Gauge | `sum(rate(b3_auth_failures_total[5m])) / sum(rate(b3_auth_attempts_total[5m])) * 100` | Security indicator |
| Auth Failures by Type | Time series | `sum by(auth_type)(rate(b3_auth_failures_total[5m]))` | Identify failing auth methods |
| Authz Check Rate | Time series | `sum(rate(b3_authz_check_count[5m]))` | Authorization activity |
| Authz Allowed vs Denied | Time series (stacked) | `sum(rate(b3_authz_check_allowed_count[5m]))` and `sum(rate(b3_authz_check_denied_count[5m]))` | Permission grant ratio |
| Authz Denial Rate % | Stat | `sum(rate(b3_authz_check_denied_count[5m])) / sum(rate(b3_authz_check_count[5m])) * 100` | Access denial rate |
| Authz Denied by Action | Table | `topk(10, sum by(authz_action)(rate(b3_authz_check_denied_count[5m])))` | Most denied actions |
| Authz Server Errors | Time series | `sum(rate(b3_authz_check_count{authz_server_error="true"}[5m]))` | Authz system health |

### Row 3: Database (Critical)

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Query Rate | Time series | `sum(rate(b3_db_client_operation_count[5m]))` | Database load |
| Query Error Rate | Time series | `sum(rate(b3_db_client_operation_count{error="true"}[5m]))` | Failed queries |
| Query Error % | Stat | `sum(rate(b3_db_client_operation_count{error="true"}[5m])) / sum(rate(b3_db_client_operation_count[5m])) * 100` | Query failure rate |
| Query Latency Percentiles | Time series | `histogram_quantile(0.50, sum(rate(b3_db_client_operation_duration_bucket[5m])) by (le))` (repeat for 0.95, 0.99) | P50/P95/P99 query time |
| Connection Pool Utilization % | Gauge | `b3_db_connections_active / b3_db_connections_limit * 100` | Pool saturation (critical) |
| Connection Pool State | Time series (stacked) | `b3_db_connections_active` and `b3_db_connections_idle` | Active vs idle connections |
| Max Connections | Stat | `b3_db_connections_limit` | Pool limit reference |
| Connection Errors | Time series | `sum(rate(b3_db_client_connection_error_count[5m]))` | Network/connection issues |

### Row 4: NATS Messaging

**Note:** Only `subscription_error`, `reconnect`, and `disconnect` are currently instrumented. Other metrics exist but are not yet wired to NATS operations.

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Reconnections | Time series | `sum(rate(b3_messaging_reconnect_count[5m]))` | Connection instability |
| Disconnections | Time series | `sum(rate(b3_messaging_disconnect_count[5m]))` | Connection failures |
| Disconnections by Error | Time series | `sum by(error_type)(rate(b3_messaging_disconnect_count[5m]))` | Disconnect reasons |
| Subscription Errors | Time series | `sum(rate(b3_messaging_subscription_error_count[5m]))` | Subscription failures |

### Row 5: Kubernetes Proxy

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Proxy Request Rate | Time series | `sum(rate(b3_proxy_k8s_operation_total[5m]))` | K8s proxy traffic |
| Proxy Rate by Cluster | Time series | `sum by(proxy_k8s_cluster)(rate(b3_proxy_k8s_operation_total[5m]))` | Per-cluster breakdown |
| Proxy Error Rate | Time series | `sum(rate(b3_proxy_k8s_operation_total{proxy_request_status_code=~"4..\|5.."}[5m]))` | Failed proxy requests |
| Proxy Error % | Stat | `sum(rate(b3_proxy_k8s_operation_total{proxy_request_status_code=~"4..\|5.."}[5m])) / sum(rate(b3_proxy_k8s_operation_total[5m])) * 100` | Proxy failure rate |
| Proxy Latency Percentiles | Time series | `histogram_quantile(0.50, sum(rate(b3_proxy_request_duration_bucket[5m])) by (le))` (repeat for 0.95, 0.99) | P50/P95/P99 proxy latency |
| Proxy Latency by Cluster | Time series | `histogram_quantile(0.95, sum by(proxy_k8s_cluster, le)(rate(b3_proxy_request_duration_bucket[5m])))` | Per-cluster latency |
| Status Code Distribution | Time series (stacked) | `sum by(proxy_request_status_code)(rate(b3_proxy_k8s_operation_total[5m]))` | Response breakdown |

### Row 6: Cluster API

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Cluster API Request Rate | Time series | `sum(rate(b3_cluster_request_count[5m]))` | Cluster API traffic |
| Cluster API by Method | Time series | `sum by(http_request_method)(rate(b3_cluster_request_count[5m]))` | Method breakdown |
| Cluster API Errors | Time series | `sum(rate(b3_cluster_request_count{http_response_status_code=~"4..\|5.."}[5m]))` | API errors |
| Cluster API Error % | Stat | `sum(rate(b3_cluster_request_count{http_response_status_code=~"4..\|5.."}[5m])) / sum(rate(b3_cluster_request_count[5m])) * 100` | Error rate |
| Top Error Routes | Table | `topk(10, sum by(http_route)(rate(b3_cluster_request_count{http_response_status_code=~"4..\|5.."}[5m])))` | Problematic endpoints |

### Row 7: License

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| License Issuance Rate | Time series | `sum(rate(b3_license_issuances_total[5m]))` | License creation activity |
| Issuance by Type | Time series | `sum by(license_type)(rate(b3_license_issuances_total[5m]))` | Per-type breakdown |
| Issuance Success Rate % | Stat | `sum(rate(b3_license_issuances_total{success="true"}[5m])) / sum(rate(b3_license_issuances_total[5m])) * 100` | Issuance health |
| License Validation Rate | Time series | `sum(rate(b3_license_validations_total[5m]))` | Validation activity |
| Validation by Type | Time series | `sum by(license_type)(rate(b3_license_validations_total[5m]))` | Per-type breakdown |
| Validation Success Rate % | Stat | `sum(rate(b3_license_validations_total{success="true"}[5m])) / sum(rate(b3_license_validations_total[5m])) * 100` | Validation health |
| Failed Issuances | Time series | `sum(rate(b3_license_issuances_total{success="false"}[5m]))` | Issuance failures |
| Failed Validations | Time series | `sum(rate(b3_license_validations_total{success="false"}[5m]))` | Validation failures |

### Row 8: Blob Storage

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| BlobFS Operation Rate | Time series | `sum(rate(b3_blobfs_operations_total[5m]))` | Storage activity |
| Operations by Type | Time series | `sum by(operation)(rate(b3_blobfs_operations_total[5m]))` | Operation breakdown |
| Operations by Storage | Time series | `sum by(storage_type)(rate(b3_blobfs_operations_total[5m]))` | Backend breakdown |
| BlobFS Errors | Time series | `sum(rate(b3_blobfs_operations_total{success="false"}[5m]))` | Storage failures |
| BlobFS Error Rate % | Stat | `sum(rate(b3_blobfs_operations_total{success="false"}[5m])) / sum(rate(b3_blobfs_operations_total[5m])) * 100` | Failure rate |
| Errors by Operation | Time series | `sum by(operation)(rate(b3_blobfs_operations_total{success="false"}[5m]))` | Which ops are failing |

### Row 9: Platform Statistics

| Panel | Type | Query | Purpose |
|-------|------|-------|---------|
| Total Users | Stat | `b3_gitea_users` | User count |
| Total Organizations | Stat | `b3_gitea_organizations` | Org count |
| Total Repositories | Stat | `b3_gitea_repositories` | Repo count |
| Total Teams | Stat | `b3_gitea_teams` | Team count |
| Users Over Time | Time series | `b3_gitea_users` | User growth |
| Repos Over Time | Time series | `b3_gitea_repositories` | Repo growth |
| Issues & Comments | Stat | `b3_gitea_issues` and `b3_gitea_comments` | Activity metrics |
| Webhooks & Hook Tasks | Stat | `b3_gitea_webhooks` and `b3_gitea_hook_tasks` | Integration metrics |
| Stars & Watches | Stat | `b3_gitea_stars` and `b3_gitea_watches` | Engagement metrics |

---

## Notes

- Boolean labels are strings in Prometheus: use `{success="true"}` not `{success=true}`
- `http_route` is raw paths without normalization - expect high cardinality; use `topk()` for tables
- BlobFS metrics exclude local filesystem operations (`storage_type` will never be `file`)
- All NATS metrics include `messaging_system="nats"` label
- Histogram metrics create `_bucket`, `_sum`, `_count` suffixes in Prometheus
- For percentiles, use `histogram_quantile(percentile, sum(rate(metric_bucket[interval])) by (le))`
