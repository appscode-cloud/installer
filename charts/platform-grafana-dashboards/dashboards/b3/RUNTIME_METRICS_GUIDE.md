# Go Runtime & Process Metrics Guide

This document explains how CPU, memory, and Go runtime metrics are automatically exposed via OpenTelemetry/Prometheus, how to replicate this in future projects, and which metrics to monitor with recommended Grafana dashboard panels.

---

## Part 1: How It Works

### The Mechanism

The `go_*` and `process_*` metrics you see are **automatically exposed** through a chain of components:

```
prometheus.DefaultRegisterer (with GoCollector + ProcessCollector)
        ↓
OTel Prometheus Exporter registers as a collector
        ↓
promhttp.Handler() serves /metrics endpoint
        ↓
Prometheus scrapes the endpoint
```

### Key Code Locations

1. **Prometheus Default Registry** (`github.com/prometheus/client_golang/prometheus/registry.go`):
   ```go
   func init() {
       MustRegister(NewProcessCollector(ProcessCollectorOpts{}))
       MustRegister(NewGoCollector())
   }
   ```
   The Prometheus client library automatically registers `GoCollector` and `ProcessCollector` to the `DefaultRegisterer` on package import.

2. **OTel Prometheus Exporter** (`go.opentelemetry.io/otel/exporters/prometheus/config.go`):
   ```go
   func newConfig(opts ...Option) config {
       // ...
       if cfg.registerer == nil {
           cfg.registerer = prometheus.DefaultRegisterer  // Uses default!
       }
       return cfg
   }
   ```
   When you create an OTel Prometheus exporter without specifying a custom registerer, it registers itself with `prometheus.DefaultRegisterer`.

3. **B3 Telemetry Init** (`modules/telemetry/telemetry.go:122-129`):
   ```go
   if enablePrometheus {
       promExporter, err := prometheus.New(
           prometheus.WithTranslationStrategy(otlptranslator.UnderscoreEscapingWithoutSuffixes),
       )
       // ...
       meterProviderOpts = append(meterProviderOpts, sdkmetric.WithReader(promExporter))
   }
   ```

4. **Metrics Endpoint** (`cmd/api.go:138-140`):
   ```go
   if setting.Metrics.PrometheusEnabled {
       m.Get("/metrics", promhttp.Handler())
   }
   ```
   `promhttp.Handler()` uses `prometheus.DefaultGatherer` which gathers from `DefaultRegisterer`.

### Why This Works

The key insight is that **both** the OTel Prometheus exporter and the default Go/Process collectors are registered to the same `prometheus.DefaultRegisterer`. When `promhttp.Handler()` serves `/metrics`, it gathers from all registered collectors:

- `GoCollector` → `go_*` metrics
- `ProcessCollector` → `process_*` metrics  
- OTel Prometheus Exporter → `b3_*` metrics (your custom OTel metrics)

---

## Part 2: Replicating in Future Projects

### Minimal Setup (Recommended)

```go
package main

import (
    "net/http"
    
    "github.com/prometheus/client_golang/prometheus/promhttp"
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/prometheus"
    sdkmetric "go.opentelemetry.io/otel/sdk/metric"
)

func initMetrics() error {
    // Create OTel Prometheus exporter
    // This automatically registers with prometheus.DefaultRegisterer
    promExporter, err := prometheus.New()
    if err != nil {
        return err
    }
    
    // Create meter provider with the exporter
    meterProvider := sdkmetric.NewMeterProvider(
        sdkmetric.WithReader(promExporter),
    )
    
    // Set as global meter provider
    otel.SetMeterProvider(meterProvider)
    
    return nil
}

func main() {
    if err := initMetrics(); err != nil {
        panic(err)
    }
    
    // Serve metrics endpoint
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":8080", nil)
}
```

That's it. You get:
- All `go_*` metrics (goroutines, memory, GC, etc.)
- All `process_*` metrics (CPU, memory, file descriptors)
- Your custom OTel metrics

### Dependencies

```
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promhttp
go get go.opentelemetry.io/otel
go get go.opentelemetry.io/otel/exporters/prometheus
go get go.opentelemetry.io/otel/sdk/metric
```

### Using a Custom Registry (If Needed)

If you need isolation from other code that might register metrics:

```go
import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/collectors"
    "github.com/prometheus/client_golang/prometheus/promhttp"
    otelprometheus "go.opentelemetry.io/otel/exporters/prometheus"
)

func initMetricsWithCustomRegistry() (*prometheus.Registry, error) {
    reg := prometheus.NewRegistry()
    
    // Manually register Go and Process collectors
    reg.MustRegister(collectors.NewGoCollector())
    reg.MustRegister(collectors.NewProcessCollector(collectors.ProcessCollectorOpts{}))
    
    // Create OTel exporter with custom registry
    promExporter, err := otelprometheus.New(
        otelprometheus.WithRegisterer(reg),
    )
    if err != nil {
        return nil, err
    }
    
    meterProvider := sdkmetric.NewMeterProvider(
        sdkmetric.WithReader(promExporter),
    )
    otel.SetMeterProvider(meterProvider)
    
    return reg, nil
}

func main() {
    reg, err := initMetricsWithCustomRegistry()
    if err != nil {
        panic(err)
    }
    
    // Use custom handler for the custom registry
    http.Handle("/metrics", promhttp.HandlerFor(reg, promhttp.HandlerOpts{}))
    http.ListenAndServe(":8080", nil)
}
```

---

## Part 3: Metrics Reference

### Process Metrics (`process_*`)

| Metric | Type | Description |
|--------|------|-------------|
| `process_cpu_seconds_total` | Counter | Total user and system CPU time spent in seconds |
| `process_resident_memory_bytes` | Gauge | Resident memory size (RSS) in bytes |
| `process_virtual_memory_bytes` | Gauge | Virtual memory size in bytes |
| `process_virtual_memory_max_bytes` | Gauge | Maximum virtual memory available |
| `process_open_fds` | Gauge | Number of open file descriptors |
| `process_max_fds` | Gauge | Maximum number of open file descriptors |
| `process_start_time_seconds` | Gauge | Start time of the process (Unix timestamp) |
| `process_network_receive_bytes_total` | Counter | Total bytes received over network |
| `process_network_transmit_bytes_total` | Counter | Total bytes transmitted over network |

### Go Runtime Metrics (`go_*`)

#### Memory Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `go_memstats_alloc_bytes` | Gauge | Bytes allocated and currently in use |
| `go_memstats_alloc_bytes_total` | Counter | Total bytes allocated (even if freed) |
| `go_memstats_sys_bytes` | Gauge | Total bytes obtained from system |
| `go_memstats_heap_alloc_bytes` | Gauge | Heap bytes allocated and in use |
| `go_memstats_heap_sys_bytes` | Gauge | Heap bytes obtained from system |
| `go_memstats_heap_idle_bytes` | Gauge | Heap bytes waiting to be used |
| `go_memstats_heap_inuse_bytes` | Gauge | Heap bytes in use |
| `go_memstats_heap_released_bytes` | Gauge | Heap bytes released to OS |
| `go_memstats_heap_objects` | Gauge | Number of allocated heap objects |
| `go_memstats_stack_inuse_bytes` | Gauge | Stack bytes in use |
| `go_memstats_stack_sys_bytes` | Gauge | Stack bytes obtained from system |
| `go_memstats_mspan_inuse_bytes` | Gauge | Memory span structures in use |
| `go_memstats_mcache_inuse_bytes` | Gauge | Memory cache structures in use |
| `go_memstats_buck_hash_sys_bytes` | Gauge | Profiling bucket hash table memory |
| `go_memstats_gc_sys_bytes` | Gauge | GC metadata memory |
| `go_memstats_other_sys_bytes` | Gauge | Other system allocations |
| `go_memstats_next_gc_bytes` | Gauge | Target heap size for next GC |
| `go_memstats_last_gc_time_seconds` | Gauge | Last GC time (Unix timestamp) |

#### GC Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `go_gc_duration_seconds` | Summary | GC pause duration distribution |
| `go_gc_gogc_percent` | Gauge | GOGC setting (default 100) |
| `go_gc_gomemlimit_bytes` | Gauge | GOMEMLIMIT setting |

#### Runtime Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `go_goroutines` | Gauge | Number of goroutines |
| `go_threads` | Gauge | Number of OS threads |
| `go_info` | Gauge | Go version info (label: `version`) |
| `go_memstats_mallocs_total` | Counter | Total heap object allocations |
| `go_memstats_frees_total` | Counter | Total heap object frees |

---

## Part 4: What to Monitor and Why

### Critical Metrics (Alert-Worthy)

#### 1. CPU Usage
```promql
# CPU usage rate (cores)
rate(process_cpu_seconds_total{job="your-app"}[5m])

# CPU usage percentage (assuming you know the limit)
rate(process_cpu_seconds_total{job="your-app"}[5m]) / <cpu_limit> * 100
```
**Why:** High CPU indicates computational bottlenecks. Sustained high CPU can lead to increased latency and eventual request timeouts.

**Alert thresholds:**
- Warning: > 70% for 5 minutes
- Critical: > 90% for 2 minutes

#### 2. Memory Usage
```promql
# Resident memory (what the process actually uses)
process_resident_memory_bytes{job="your-app"}

# Heap memory in use
go_memstats_heap_inuse_bytes{job="your-app"}

# Memory usage percentage (if you know the limit)
process_resident_memory_bytes{job="your-app"} / <memory_limit> * 100
```
**Why:** Memory leaks cause OOMKills. Monitoring trends helps catch leaks before they crash the process.

**Alert thresholds:**
- Warning: > 80% of limit for 10 minutes
- Critical: > 95% of limit for 2 minutes

#### 3. Goroutine Count
```promql
go_goroutines{job="your-app"}

# Rate of change (spike detection)
deriv(go_goroutines{job="your-app"}[5m])
```
**Why:** Goroutine leaks are a common Go issue. A steadily increasing count without corresponding load increase indicates a leak.

**Alert thresholds:**
- Warning: > 10,000 goroutines
- Critical: > 50,000 goroutines or > 100% increase in 10 minutes

#### 4. GC Pause Duration
```promql
# P99 GC pause time
go_gc_duration_seconds{job="your-app", quantile="1"}

# Average GC pause
rate(go_gc_duration_seconds_sum{job="your-app"}[5m]) / rate(go_gc_duration_seconds_count{job="your-app"}[5m])
```
**Why:** Long GC pauses cause latency spikes. Stop-the-world pauses affect all requests.

**Alert thresholds:**
- Warning: P99 > 100ms
- Critical: P99 > 500ms

### Important Metrics (Dashboard-Worthy)

#### 5. File Descriptors
```promql
# Current open FDs
process_open_fds{job="your-app"}

# FD usage percentage
process_open_fds{job="your-app"} / process_max_fds{job="your-app"} * 100
```
**Why:** Running out of file descriptors breaks network connections and file operations. Usually indicates connection leaks.

#### 6. Heap Growth Rate
```promql
# Heap allocation rate (bytes/sec)
rate(go_memstats_alloc_bytes_total{job="your-app"}[5m])

# Object allocation rate
rate(go_memstats_mallocs_total{job="your-app"}[5m])
```
**Why:** High allocation rates cause more GC pressure. Useful for identifying allocation-heavy code paths.

#### 7. Thread Count
```promql
go_threads{job="your-app"}
```
**Why:** OS thread count should be relatively stable. Unexpected growth may indicate blocking syscalls or CGO issues.

#### 8. Process Uptime
```promql
time() - process_start_time_seconds{job="your-app"}
```
**Why:** Useful for correlating metrics with restarts. Also helps identify frequent crash loops.

---

## Part 5: Grafana Dashboard Design

### Recommended Dashboard Layout

#### Row 1: Overview (4 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| CPU Usage | Gauge | `rate(process_cpu_seconds_total[5m])` | Current CPU load |
| Memory Usage | Gauge | `process_resident_memory_bytes / <limit> * 100` | Memory pressure |
| Goroutines | Stat | `go_goroutines` | Concurrency indicator |
| Uptime | Stat | `time() - process_start_time_seconds` | Process stability |

#### Row 2: CPU Deep Dive (3 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| CPU Over Time | Time series | `rate(process_cpu_seconds_total[5m])` | CPU trend |
| CPU by Instance | Time series (stacked) | `rate(process_cpu_seconds_total[5m]) by (instance)` | Per-pod breakdown |
| Thread Count | Time series | `go_threads` | OS thread trend |

#### Row 3: Memory Deep Dive (4 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| RSS Memory | Time series | `process_resident_memory_bytes` | Actual memory usage |
| Heap Breakdown | Time series (stacked) | `go_memstats_heap_inuse_bytes`, `go_memstats_heap_idle_bytes` | Heap utilization |
| Heap Objects | Time series | `go_memstats_heap_objects` | Object count trend |
| Allocation Rate | Time series | `rate(go_memstats_alloc_bytes_total[5m])` | Allocation pressure |

#### Row 4: GC Performance (3 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| GC Pause Percentiles | Time series | `go_gc_duration_seconds{quantile="0.5"}`, `{quantile="0.9"}`, `{quantile="1"}` | Pause distribution |
| GC Frequency | Time series | `rate(go_gc_duration_seconds_count[5m])` | GC rate |
| Next GC Target | Time series | `go_memstats_next_gc_bytes` | GC trigger threshold |

#### Row 5: Goroutines & Threads (3 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| Goroutine Count | Time series | `go_goroutines` | Concurrency trend |
| Goroutine Rate of Change | Time series | `deriv(go_goroutines[5m])` | Leak detection |
| Goroutines by Instance | Time series | `go_goroutines by (instance)` | Per-pod breakdown |

#### Row 6: File Descriptors & Network (4 panels)

| Panel | Visualization | Query | Purpose |
|-------|---------------|-------|---------|
| Open FDs | Gauge | `process_open_fds / process_max_fds * 100` | FD saturation |
| FD Trend | Time series | `process_open_fds` | FD usage over time |
| Network RX | Time series | `rate(process_network_receive_bytes_total[5m])` | Inbound bandwidth |
| Network TX | Time series | `rate(process_network_transmit_bytes_total[5m])` | Outbound bandwidth |

### Example PromQL Queries for Alerting

```yaml
# AlertManager rules example
groups:
  - name: go-runtime
    rules:
      - alert: HighMemoryUsage
        expr: process_resident_memory_bytes / <memory_limit> > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage (> 90%)"
          
      - alert: GoroutineLeak
        expr: go_goroutines > 10000
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Possible goroutine leak (> 10k goroutines)"
          
      - alert: HighGCPauseTime
        expr: go_gc_duration_seconds{quantile="1"} > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High GC pause time (> 500ms)"
          
      - alert: FileDescriptorExhaustion
        expr: process_open_fds / process_max_fds > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Running low on file descriptors (> 80%)"
```

---

## Part 6: Best Practices

### 1. Memory Monitoring Strategy

- **Watch `heap_inuse` not just `alloc`**: `alloc_bytes` includes freed memory waiting for GC
- **Compare RSS vs Heap**: Large gap indicates non-heap memory (CGO, mmap, etc.)
- **Track `heap_released`**: Shows how well Go returns memory to OS

### 2. GC Tuning Indicators

- **High GC frequency + short pauses**: Consider increasing GOGC
- **Low GC frequency + long pauses**: Consider decreasing GOGC or heap size
- **`next_gc_bytes` growing unbounded**: Possible memory leak

### 3. Goroutine Debugging

- **Steady-state baseline**: Know your normal goroutine count under typical load
- **Correlate with requests**: `goroutines / request_rate` should be relatively stable
- **Use pprof**: When goroutine count is high, use `/debug/pprof/goroutine` to identify leaks

### 4. CPU Analysis

- **Compare with GC time**: If `rate(process_cpu_seconds_total)` correlates with GC, tune GC
- **User vs System time**: High system time may indicate I/O or syscall issues (not exposed by default, use cAdvisor for container-level breakdown)

---

## Summary

The `go_*` and `process_*` metrics are automatically exposed because:

1. `prometheus.DefaultRegisterer` auto-registers `GoCollector` and `ProcessCollector` on import
2. OTel Prometheus exporter uses `DefaultRegisterer` by default
3. `promhttp.Handler()` gathers from `DefaultGatherer` which includes all registered collectors

For new projects, simply:
1. Create an OTel Prometheus exporter (no custom registerer needed)
2. Expose `/metrics` with `promhttp.Handler()`
3. You automatically get all runtime metrics

Monitor these metrics because:
- **CPU**: Detects computational bottlenecks
- **Memory**: Catches leaks before OOMKill
- **Goroutines**: Identifies concurrency issues
- **GC**: Explains latency spikes
- **FDs**: Prevents connection exhaustion
