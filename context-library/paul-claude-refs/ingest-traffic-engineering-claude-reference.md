# Ingest & Traffic Engineering — Claude Code Reference

> **Purpose**: Institutional knowledge for querying New Relic ingest and traffic engineering telemetry. Drop this in your CLAUDE.md or reference it from your project instructions.
>
> Last updated: 2026-03-11

---

## Table of Contents

1. [Environment Setup](#1-environment-setup)
2. [Key Metrics & Where They Live](#2-key-metrics--where-they-live)
3. [NRQL Query Patterns & Gotchas](#3-nrql-query-patterns--gotchas)
4. [Ingest Architecture](#4-ingest-architecture)
5. [PrivateLink vs CDN Analysis](#5-privatelink-vs-cdn-analysis)
6. [Cloud Routing (FlexCloud)](#6-cloud-routing-flexcloud)
7. [CCI (Cloud Cost Intelligence)](#7-cci-cloud-cost-intelligence)
8. [Streaming Data Export (UDS)](#8-streaming-data-export-uds)
9. [Usage Data & NrConsumption](#9-usage-data--nrconsumption)
10. [Customer Triage Runbook](#10-customer-triage-runbook)
11. [Dashboards & Tools](#11-dashboards--tools)
12. [Abbreviations & Glossary](#12-abbreviations--glossary)

---

## 1. Environment Setup

### Two Systems — Staging MCP vs Prod CLI

Most New Relic MCP server connections talk to **staging** (`staging-one.newrelic.com`). Production data requires the `newrelic` CLI.

| Data | Account | How to Query |
|---|---|---|
| `vortex.bytes` (prod enriched metric) | Prod account **1** | CLI: `newrelic --profile prod nrql query --accountId 1 --query "..."` |
| `NrConsumption` / usage data | Prod account **1815717** | CLI: `newrelic --profile prod nrql query --accountId 1815717 --query "..."` |
| `vortex.monitoring.account.*` (edge.provider, PL vs CDN) | Staging **10043281** | MCP `execute_nrql_query` or staging NerdGraph curl |
| CCI CloudCost / KubernetesCost | Staging account **1** | Staging NerdGraph curl |
| `ExportSendResult` (UDS/streaming export) | Staging **1025650** | Staging NerdGraph curl |

### Staging NerdGraph via curl

The CLI staging profile does NOT work (region mismatch). Use curl directly:

```bash
curl -s -X POST 'https://staging-api.newrelic.com/graphql' \
  -H 'Content-Type: application/json' \
  -H 'API-Key: <YOUR_STAGING_API_KEY>' \
  -d '{"query":"{ actor { account(id: 10043281) { nrql(query: \"YOUR NRQL HERE\") { results } } } }"}'
```

**Escaping rules**: NRQL inside NerdGraph JSON is double-escaped. Use `\\u0027` for single quotes, or avoid them entirely with `IN (...)` and numeric values.

### Prod CLI Syntax

```bash
newrelic --profile prod nrql query --accountId 1 --query "SELECT sum(vortex.bytes) FROM Metric SINCE 1 day ago"
```

Note the `--query` flag (required).

---

## 2. Key Metrics & Where They Live

### `vortex.monitoring.account.bytes` / `.requests` — Edge-Level Telemetry

- **Account**: staging 10043281
- **Type**: Metric (use `FROM Metric`)
- **Key attribute**: `edge.provider` — values: `fastly`, `cloudflare`, `java-switchboard`, `unknown`
- Other attributes: `cloud.provider`, `request.type`, `account.id`, `deployment.environment`
- Use for: CDN vs PrivateLink analysis, per-account ingest volume, triage

### `vortex.bytes` — Prod Enriched Metric (Load Knitter Output)

- **Account**: prod account 1
- **Type**: Metric (query as `SELECT sum(vortex.bytes) FROM Metric`)
- **Does NOT have** `edge.provider` — that's only on vortex.monitoring
- **Key attributes**:
  - `orgName` — organization/customer name (best for customer rollup)
  - `organizationId` — org GUID
  - `account` — account ID (numeric)
  - `trustedAccountKey` — root account key (numeric)
  - `routingType`, `requestType` — traffic classification
  - `cloudProvider` — where data physically lands (observed)
  - `cloudInstance` — where data is instructed to go: `aws`, `azure`, `any`, `unknown`
  - `entitledCloudProvider` — what cloud the account is entitled to
  - `evaluatedCloudProvider` — routing evaluation result
  - `legacyCloudProvider` — `cloud_instance` from Account DB
  - `pinned` — **string** (NOT boolean): `'No'`, `'account'`, `'tak'`
  - `isImportant` — boolean: whether account is in ir-asdf's `importantOrgs.json`
  - `cell`, `processingCell`, `fedCell`, `wrongCell` — cell routing

### Common Metric Gotchas

| Mistake | Correct Approach |
|---|---|
| Querying `vortex.bytes` for `edge.provider` | Use `vortex.monitoring.account.bytes` instead — different metric, different account |
| Using old metric name `vortex.monitoring.account.received.bytes.count` | Use `vortex.monitoring.account.bytes` |
| Querying `pinned = true` / `pinned = false` | It's a string: `pinned = 'No'` or `pinned IN ('account', 'tak')` |
| Running `vortex.bytes` with `SINCE 1 month ago` | Will timeout even with async — use 1 week max, or narrow with WHERE |

---

## 3. NRQL Query Patterns & Gotchas

### Timeout / Async Rules

| Query | Time Range | Needs async? |
|---|---|---|
| `vortex.bytes` (prod 1) | 1 week | No |
| `vortex.bytes` (prod 1) | 1 month | **Timeout even with async** — use 1 week |
| `vortex.monitoring.account.*` (staging 10043281) | 1 week | Usually no |
| `vortex.monitoring.account.*` (staging 10043281) | 1 month | **Yes** |
| `CloudCost` (staging 1) | 7 days | Usually no |
| `CloudCost` (staging 1) | 1 month | **Yes** |
| `CloudCost` (staging 1) | < 48 hours | **Will error** — 48hr data delay |

### How to Run Heavy Queries (via MCP or curl)

Two approaches — both tested and working on staging MCP + prod CLI (Mar 11, 2026):

#### Option A — Blocking with `timeout: 540` (simplest)

Add `timeout: 540` (9 minutes) to the `nrql()` call. One call, results inline:

```graphql
{
  actor {
    account(id: 10043281) {
      nrql(query: "SELECT sum(vortex.monitoring.account.bytes) FROM Metric SINCE 1 month ago", timeout: 540) {
        results
      }
    }
  }
}
```

#### Option B — Async Submit/Poll (for parallel work)

Per the [NerdGraph async docs](https://docs.newrelic.com/docs/apis/nerdgraph/examples/async-queries-nrql-tutorial/), submit the query and poll separately. Best when you need to do other work while the query runs.

**Step 1 — Submit** with `async: true` (returns in ~5s with a `queryId` if the query needs more time):

```graphql
{
  actor {
    account(id: 10043281) {
      nrql(query: "SELECT sum(vortex.monitoring.account.bytes) FROM Metric SINCE 1 month ago", async: true) {
        results
        queryProgress {
          queryId
          completed
          retryAfter
          retryDeadline
          resultExpiration
        }
      }
    }
  }
}
```

If the query finishes within ~5s, you get `results` directly. If not, you get `completed: false` and a `queryId`.

**Step 2 — Poll** using the `queryId` (repeat until `completed: true`):

```graphql
{
  actor {
    account(id: 10043281) {
      nrqlQueryProgress(queryId: "YOUR_QUERY_ID") {
        results
        queryProgress {
          queryId
          completed
          retryAfter
          retryDeadline
        }
      }
    }
  }
}
```

Option B works via **MCP `run_nerdgraph_query`** or **curl** — each call is fast (no long-blocking connection), so even queries that take 8+ minutes work fine. Just poll every 10-30 seconds until `completed: true`.

**When to use which**: Option A (`timeout: 540`) when you just need one result and can wait. Option B (async poll) when you want to fire off a query and do other work while it runs.

**Cancel** a long-running query if needed:
```graphql
mutation { nrqlCancelQuery(queryId: "YOUR_QUERY_ID") { queryId requestStatus rejectionReason } }
```

> **Data Plus required**: Async queries with up to 10-minute max duration require a Data Plus plan.

### NRQL Syntax Tips

- **No `HAVING`** — use WHERE filters or subqueries instead
- **Subquery `LIMIT MAX` is critical** — subqueries have a silent default size limit. Always add `LIMIT MAX` or results are silently truncated
- **2-level nested subqueries** work: `WHERE x IN (SELECT ... WHERE y IN (SELECT ...))`
- **`FACET ... IN`**: Constrain output when you know expected values — e.g. `FACET edge.provider IN ('fastly','cloudflare','java-switchboard')`
- **`FACET IN` + multi-facet**: Cannot combine — `FACET x IN (...), y` is a syntax error. Use plain `FACET x, y`
- **`LIKE '%foo%'` with `SINCE 1 month ago`**: Often causes `NRDB:1102004` errors. Use exact `=` or `IN (...)` instead
- **Rate/throughput**: `rate(sum(metric), 1 minute)` with `TIMESERIES 1 day` gives average RPM per day

### Resolve Account IDs to Customer Names

```sql
-- Via prod CLI, account 1 (short window to avoid timeout)
SELECT latest(orgName), latest(accountName)
FROM Metric WHERE metricName = 'vortex.bytes' AND account = <ACCOUNT_ID>
SINCE 1 day ago
```

---

## 4. Ingest Architecture

```
Customer Traffic
      |
      v
  CDN Edge (Fastly / Cloudflare)     PrivateLink
  [fastly-switchboard]                [java-switchboard]
      |                                    |
      +----------> Wayfinder <-------------+
                     |
                     v
               +-----------+
               |  Vortex   |  <-- Primary ingest endpoint
               +-----------+
                     |
                     v  (EdgeMessages on Kafka)
       +-------------+-------------+
       |             |             |
    SED       custom-event    spigot
  (events)    -consumer     (S3 ingest)
       |             |
       v             v
   event_batches   event_batches
       |             |
       v             v
     NRDB / Dirac (downstream)
```

**Traffic flow**: Agents/APIs hit CDN edge workers (Fastly/Cloudflare) or PrivateLink (java-switchboard). Edge workers query Wayfinder for cell routing, then proxy to Vortex. Vortex authenticates, serializes to EdgeMessages, publishes to Kafka. Downstream consumers process and forward to NRDB.

### Key Services

| Service | What It Does |
|---|---|
| **Vortex** | Primary telemetry ingest endpoint. Authenticates via license keys, publishes EdgeMessages to Kafka |
| **fastly-switchboard** | CDN edge routing on Fastly (Rust) and Cloudflare Workers (JS/Rust). Queries Wayfinder for routing |
| **java-switchboard** | PrivateLink routing proxy (`edge.provider = 'java-switchboard'`). Queries Wayfinder, forwards to Vortex |
| **Wayfinder** | Cell routing service — decides which Vortex cell receives a request (legacy + streaming variants) |
| **Conflux** | Aggregates auth Kafka streams into compacted topics for fast auth lookups. REST endpoints for account status |
| **ir-asdf** | Post-ingest storage routing (FlexCloud) — decides which cloud/cell data goes to for processing |
| **SED** | Streaming Event Decorator — enriches EdgeMessages, converts to Thrift, publishes to `event_batches` |
| **Arbitron** | CDN traffic-shifting automation. Monitors CDN health, manages failover between Fastly/Cloudflare |
| **Spigot** | S3 ingestion service (BYOS3). Reads customer S3 objects, converts to EdgeMessages |
| **Load Knitter** | Produces the enriched `vortex.bytes` metric in prod account 1 |
| **Sand Maker** | Traffic simulation tool |
| **Shuffle Shifter** | Traffic routing tool |

### GHE Orgs

- `source.datanerd.us/ingest` — Ingest Pipeline team (~76 active repos)
- `source.datanerd.us/ingest-routing` — Traffic Engineering (formerly Ingest Routing)
- `source.datanerd.us/traffic-routing` — Also Traffic Engineering

---

## 5. PrivateLink vs CDN Analysis

### Traffic Volumes (Feb 2026, 1 month)

| Path | TB/month | % of Total | Requests/month |
|---|---|---|---|
| **Fastly** (CDN) | 21,161 | 52.1% | 5.17T |
| **Cloudflare** (CDN) | 14,971 | 36.9% | 3.72T |
| **PrivateLink** (java-switchboard) | 4,419 | 10.9% | 0.41T |
| **Total** | ~40,572 | 100% | ~9.33T |

### PrivateLink Traffic

- **456 accounts** use PrivateLink
- PL requests are 2.7x larger than CDN average (enterprise workload profile)
- 89.5% AWS, 10.5% Azure
- Top data types: otlp_traces (25.7%), analytic_event_data (15.8%), external_event_data (13.8%), logs_data (11.7%)

### PL-Eligible Traffic

Not all traffic can use PL. Browser/mobile types are excluded:
```
browser_monitoring, mobile_apm_data, rum, insights_js_api, mobile_hex_data,
session_trace, status_check, cloud_watch_metrics, mobile_crash, browser_blob,
cloud_aws, cloud_aws_vpc, browser_event_log, mobile_errors, browser_logs,
mobile_session_replay, mobile_logs
```

PL-eligible CDN traffic = **22.2 PB/month** (the addressable migration opportunity)

### Key Queries

```sql
-- CDN vs PL traffic (staging 10043281, use async for 1-month)
SELECT sum(vortex.monitoring.account.bytes)/1e12 AS TB
FROM Metric
WHERE deployment.environment = 'us-production'
FACET edge.provider IN ('fastly','cloudflare','java-switchboard')
SINCE 1 month ago

-- PL by cloud provider
SELECT sum(vortex.monitoring.account.bytes)/1e12 AS TB
FROM Metric WHERE metricName = 'vortex.monitoring.account.bytes'
  AND edge.provider = 'java-switchboard'
FACET cloud.provider
SINCE 1 month ago

-- Top PL accounts
SELECT sum(vortex.monitoring.account.bytes)/1e12 AS TB
FROM Metric WHERE metricName = 'vortex.monitoring.account.bytes'
  AND edge.provider = 'java-switchboard'
FACET account.id
SINCE 1 month ago LIMIT 20

-- PL-eligible bytes only (exclude browser/mobile)
SELECT sum(vortex.monitoring.account.bytes)
FROM Metric
WHERE deployment.environment = 'us-production'
  AND request.type NOT IN ('browser_monitoring','mobile_apm_data','rum',
    'insights_js_api','mobile_hex_data','session_trace','status_check',
    'cloud_watch_metrics','mobile_crash','browser_blob','cloud_aws',
    'cloud_aws_vpc','browser_event_log','mobile_errors','browser_logs',
    'mobile_session_replay','mobile_logs')
FACET edge.provider IN ('fastly','cloudflare','java-switchboard')
SINCE 1 month ago
```

### COGS Comparison (Feb 2026)

| | CDN (PL-eligible) | PrivateLink | Notes |
|---|---|---|---|
| **$/GB (contract rate)** | $0.012 | $0.014 | CDN marginally cheaper |
| **$/GB (effective rate)** | $0.015 | $0.014 | Near parity |
| **$/M requests** | $0.074–$0.096 | $0.185 | CDN 2x cheaper per request |
| **Avg request size** | 6.3 KB | 13.1 KB | PL 2x larger — explains per-GB convergence |

CDN is min-commit contract ($962K/mo combined Fastly + Cloudflare). Migration savings only materialize at renewal.

### Customer-Side AWS Costs

**Without PL** (public internet):
- NAT Gateway: $0.045–$0.093/GB processing + $0.045–$0.093/hr per AZ
- Internet egress: $0.085–$0.147/GB (varies by region)

**With PL**:
- PL endpoint: $0.01/hr per AZ (~$7.30/mo/AZ)
- PL data processing: $0.01/GB (first 1PB), $0.006 (1-5PB), $0.004 (5+PB)
- Cross-region transfer (if not in us-east-2): $0.01–$0.147/GB depending on source

---

## 6. Cloud Routing (FlexCloud)

FlexCloud = post-ingest storage routing — where Vortex sends data for processing. Controlled by **ir-asdf** (`source.datanerd.us/ingest-routing/ir-asdf`). This is NOT about PrivateLink — it's downstream after ingest.

### Key Config Files in ir-asdf

- **`orgInfo.json`** — 100 orgs keyed by org GUID, each with `taks` (trusted account keys) + `account_name`. Forces those TAKs to `cloudInstance = 'aws'`. Drives 632 TB/day (54.5% of all traffic)
- **`importantOrgs.json`** — Account IDs by environment. EU list is empty (AWS-only by default). Accounts listed here get `isImportant = true`

### Routing Decision Tree (Feb 2026)

Priority-ordered, mutually exclusive buckets:

| Priority | Decision | TB/day | % |
|---|---|---|---|
| 1 | Entitled → AWS | 122.8 | 10.4% |
| 2 | Entitled → Azure | 1.9 | 0.2% |
| 3 | isImportant → AWS | 542.0 | 46.0% |
| 4 | Manual Override → AWS | 182.5 | 15.5% |
| 5 | Unrouted (stays `any`) | 329.6 | 28.0% |

### `vortex.bytes` Routing Attributes

| Attribute | What It Means |
|---|---|
| `cloudInstance` | Old directive — where account is told to go (`aws`/`azure`/`any`) |
| `entitledCloudProvider` | What the account's entitlement says |
| `evaluatedCloudProvider` | Result after evaluating entitled + legacy |
| `legacyCloudProvider` | `cloud_instance` from Account DB |
| `cloudProvider` | Where data **actually** physically lands (observed) |
| `isImportant` | Boolean — whether account is in `importantOrgs.json` |
| `pinned` | **String**: `'No'` (moveable), `'account'` (account-level pin), `'tak'` (TAK-level pin) |

### Traffic Baseline (Feb 2026, 1 day)

| Routing | TB/day | % |
|---|---|---|
| any→aws | 805 | 69.4% |
| any→any | 323 | 27.8% |
| any→azure | 32 | 2.7% |
| **Total** | **1,159** | |

Top customers by TAK: Mercado Libre (72 TB), Capital One (60 TB), Adobe (57 TB), News Corp (56 TB), Multi Media LLC (52 TB)

### Conflux — Auth Status Check

```bash
curl -s https://conflux.vip.cf.nr-ops.net/status/account/[ACCOUNT_ID] | jq '.'
```

Useful for debugging 401/403 errors.

---

## 7. CCI (Cloud Cost Intelligence)

CCI data lives in **staging account 1** (not 10043281).

### Event Types

| Type | Description | Granularity |
|---|---|---|
| `CloudCost` | AWS/Azure cost per line item | Daily |
| `KubernetesCost` | K8s pod/node cost allocation | Hourly |
| `CloudCostEstimate` | Real-time estimates | Near-realtime |

### Key CloudCost Attributes

- `engineering_cost` — **use this** (FinOps recommended, includes discounts/commits/savings plans)
- `line_item_product_code` — AWS service (`AmazonEC2`, `AmazonVPC`, `AWSELB`, etc.)
- `product_region_code` — Cloud region
- `cf_service_name` — NR enrichment: service name (e.g. `java-switchboard`)
- `cf_cell_name` — NR enrichment: cell name (e.g. `us-knobby-corn`)
- `cf_cost_attribution_category` — NR enrichment: `query`, `storage`, or `ingest`
- `cf_owning_team` — NR enrichment: team name

### Key Gotchas

- **Attribute names are lowercase underscore** (e.g. `line_item_product_code`) — docs show display names with spaces
- **48hr minimum data delay** — `SINCE 24 hours ago` throws errors. Use `SINCE 7 days ago` or older
- **KubernetesCost namespace/pod fields are currently empty** — node-level only. Use `CloudCost` with `cf_service_name` for service attribution
- **Cell names ≠ K8s cluster names**: `cf_cell_name` (e.g. `us-knobby-corn`) ≠ `cluster_name` (e.g. `us-that-paul`)
- **Cost fields**: `engineering_cost` > `net_unblended_cost` > `unblended_cost`. Use `engineering_cost` for COGS analysis

### Starter Queries

```sql
-- Total cost by product (staging account 1, needs async for 1-month)
FROM CloudCost SELECT SUM(engineering_cost)
FACET line_item_product_code
SINCE 1 month ago LIMIT 20

-- VPC/PrivateLink costs
FROM CloudCost SELECT SUM(engineering_cost)
WHERE line_item_product_code = 'AmazonVPC'
FACET product_region_code, cf_service_name
SINCE 1 month ago

-- Cost by owning team
FROM CloudCost SELECT SUM(engineering_cost)
FACET cf_owning_team
SINCE 1 month ago

-- java-switchboard infra cost by cell
FROM CloudCost SELECT SUM(engineering_cost)
WHERE cf_service_name IN ('java-switchboard', 'java-switchboard-nlb', 'java-switchboard-alb')
FACET cf_cell_name
SINCE 1 month ago
```

### Known Cell Names

| Cell | Environment | Service |
|---|---|---|
| us-knobby-corn | US prod | java-switchboard |
| us-doctor-who | US prod | java-switchboard |
| eu-juicy-citrus | EU prod | java-switchboard |
| eu-guard-llama | EU prod | java-switchboard |
| stg-cool-story | Staging | java-switchboard |
| stg-pressure-drop | Staging | java-switchboard |

---

## 8. Streaming Data Export (UDS)

- **Data source**: account **1025650** — only accessible via **staging NerdGraph curl** (not prod CLI)
- **Event type**: `ExportSendResult`
- **Key filter**: `appName LIKE 'event-exporter (%)'`
- **`account` attribute is numeric** — `WHERE account = 3172319` (NO quotes, or returns zero)
- **Retention**: ~13 months

### Key Attributes

`byteCount`, `eventCount`, `ruleId`, `account`, `payloadCompression` (`DISABLED`/`GZIP`), `cloudDestination`, `cell`, `closeReason`, `isRetry`, `appName`

### Query Pattern

```sql
FROM ExportSendResult SELECT sum(byteCount)/1e9 as gb, sum(eventCount) as events,
  latest(cloudDestination), latest(payloadCompression), latest(cell)
WHERE NOT isRetry AND account IN (acct1, acct2)
FACET account, ruleId SINCE 1 week ago LIMIT 20
```

---

## 9. Usage Data & NrConsumption

Query in **prod account 1815717** via CLI.

### Event Types

| Type | Description |
|---|---|
| `NrConsumption` | Hourly usage snapshots per account |
| `NrMTDConsumption` | Month-to-date cumulative |
| `NrCustomerConsumption` | Hourly for CCBH-migrated customers |
| `NrCustomerMTDConsumption` | MTD for CCBH-migrated customers |

### Key Attributes

- `consumingAccountId`, `consumingAccountName` — account identity
- `customerId` — CC-ID format `CC-XXXXXXXXXX`
- `organizationId` — org GUID
- `consumption`, `billableConsumption`, `freeConsumption` — usage amounts
- `productLine` — e.g. `DataPlatform`, `FullStackObservability`
- `metric` / `usageMetric` — e.g. `BasicBytes`, `OriginalBytes`

### Account → Customer Lookup (US only)

```sql
-- Step 1: Get CC-ID and org from account ID
SELECT latest(customerId), latest(organizationId)
FROM NrConsumption WHERE consumingAccountId = <ACCT_ID>
SINCE 1 month ago

-- Step 2: Get all accounts in that customer
SELECT uniques(consumingAccountId, 500)
FROM NrConsumption WHERE customerId = 'CC-...'
SINCE 1 month ago
```

EU accounts don't appear in US NrConsumption at all — absence is a signal.

### Entitlements Lookup

- **UI**: `one.newrelic.com/entitlements-admin` — search by account ID
- **EU**: `one.eu.newrelic.com/entitlements-admin`
- API access (NerdGraph `actor.account.provisioning`, AIS, CPS) is internal Service Gateway only — not accessible from CLI/curl

### CCU per Dashboard

Use `NrComputeUsage` (not `NrConsumption`) for per-dashboard CCU in account 1815717:

```sql
SELECT sum(usage) as CCU FROM NrComputeUsage
WHERE dimension_dashboardId = '<guid>'
SINCE 1 day ago

-- Per-widget breakdown
SELECT sum(usage) as CCU FROM NrComputeUsage
WHERE dimension_dashboardId = '<guid>'
FACET dimension_query
SINCE 1 day ago
```

### Deprecated Attributes (effective 4/01/2026)

- `partnershipOwningAccountId` — **removed** from NrConsumption. Use `organizationId` instead
- `masterAccountId` — **removed**. Substitute with `accountId`

---

## 10. Customer Triage Runbook

When a customer says "data isn't showing up", run through these steps. All `vortex.monitoring.account.*` queries go against **staging account 10043281**.

### Step 1 — Is total volume actually down?

```sql
FROM Metric SELECT sum(vortex.monitoring.account.requests) AS requests
WHERE account.id = <ACCOUNT_ID>
AND deployment.environment = 'us-production'
TIMESERIES 1 hour
SINCE '<start>' UNTIL '<end>'
```

- Hard drop to zero = real outage
- Gradual decline = could be normal end-of-day
- Looks normal = issue may be product-side (NRDB/query), not ingest

### Step 2 — CDN shift or real loss?

```sql
FROM Metric SELECT sum(vortex.monitoring.account.requests)
WHERE account.id = <ACCOUNT_ID>
AND deployment.environment = 'us-production'
FACET edge.provider IN ('fastly','cloudflare','java-switchboard')
TIMESERIES 1 hour
SINCE '<start>' UNTIL '<end>'
```

- One drops, another rises = CDN failover (no data lost)
- All drop together = real ingest loss
- java-switchboard drops, CDN fine = PrivateLink issue

### Step 3 — Which data type?

```sql
FROM Metric SELECT sum(vortex.monitoring.account.requests)
WHERE account.id = <ACCOUNT_ID>
AND deployment.environment = 'us-production'
FACET request.type
TIMESERIES 10 minutes
SINCE '<start>' UNTIL '<end>'
```

- One type → zero = that agent/SDK stopped sending (client-side)
- All types drop = network/routing issue
- Recovery spike after gap = client was buffering (data intact, just late)

### Step 4 — Check NrIntegrationError (prod CLI)

```bash
newrelic --profile prod nrql query --accountId 1815717 \
  --query "FROM NrIntegrationError SELECT count(*), uniques(message) WHERE accountId = <ACCOUNT_ID> FACET category, type SINCE '...' LIMIT 20"
```

### Diagnostic Conclusions

| Pattern | Conclusion |
|---|---|
| One CDN drops, total flat | CDN failover — no data loss |
| All providers drop | Real ingest loss |
| One request.type → zero | Client agent stopped sending |
| Drop + recovery spike | Client buffered — data intact, delayed |
| Drop + NrIntegrationError spike | NR rejected data — check error messages |
| Drop, no errors | Client never sent — network/config issue |
| No anomaly in vortex metrics | Ingest was fine — issue is in NRDB/query layer |

---

## 11. Dashboards & Tools

### Key Dashboards (Staging Unless Noted)

| Dashboard | GUID | Description |
|---|---|---|
| TE Start Page | `MXxWSVp8REFTSEJPQVJEfGRhOjEwOTQ3MTc` | Navigation hub for all TE dashboards |
| Mega Summary Board V3 | `MXxWSVp8REFTSEJPQVJEfGRhOjEwNDg4MQ` | Overall ingest summary |
| Telemetry Ingest Capacity | `MTE4MjU1MTR8VklafERBU0hCT0FSRHxkYToxMTAxOTI2` | Routing type throughput per cell |
| SMK Kafka Detailed | `MXxWSVp8REFTSEJPQVJEfGRhOjEwNTc0NQ` | Kafka metrics |
| Infra Lag | `MTAyNjUzMnxWSVp8REFTSEJPQVJEfGRhOjE2ODAw` | Infrastructure lag |
| Load Knitter (Staging) | `MXxWSVp8REFTSEJPQVJEfGRhOjE3OTU4NQ` | LK staging |
| Load Knitter (Prod) | `MXxWSVp8REFTSEJPQVJEfGRhOjc5MDE2MzE` | LK prod |
| Ingest Routing Classification | `MXxWSVp8REFTSEJPQVJEfGRhOjg5MzgzMTc` | Prod |
| Historical Ingest vs Billable | `MXxWSVp8REFTSEJPQVJEfGRhOjExOTg1NTg1` | Prod |
| Cell Health Events | `MTE4MjU1MTR8VklafERBU0hCT0FSRHxkYToxMTMzMzAw` | Cell-level events |
| FlexClaude (Cloud Routing) | `MXxWSVp8REFTSEJPQVJEfGRhOjEyMTU3ODUx` | Prod account 1 — cloud routing analysis |

### Dashboard Editing Patterns

- **Always use GraphQL variables** — inline JSON in mutation strings causes syntax errors
- **`dashboardUpdate` for everything** — adding pages, updating widgets. `dashboardUpdatePage` rejects `nrqlQueries` in rawConfiguration
- **Add widgets only**: use `dashboardAddWidgetsToPage` mutation
- **`rawConfiguration` must be an object**, not a JSON string
- Grid is 12 columns wide; rows start at 1
- `dashboardUpdate` via CLI returns `{}` on success — normal

### PrivateLink Savings Calculator (Nerdpack)

- **UUID**: 40e62348-f213-4fd0-ba47-92b02d0d4b49
- **Launcher**: https://onenr.io/0VRVZ4o41Ra
- Multi-region calculator, org autocomplete, 31-day PL-eligible traffic panel, top-10 accounts
- **GHE**: `source.datanerd.us/pfrazier/cloud-local-savings-calculator-claude`

---

## 12. Abbreviations & Glossary

| Abbrev | Meaning |
|---|---|
| **CF** | Container Fabric (internal NR platform team — manages Crossplane/infrastructure) |
| **CFL** | Cloudflare (the CDN) |
| **TI** | Telemetry Ingest (team/service) |
| **SB** | Switchboard (java-switchboard — PrivateLink entry point cells) |
| **TE** | Traffic Engineering (formerly Ingest Routing) |
| **PL** | PrivateLink |
| **BYOS3** | Bring Your Own S3 (customer-owned S3 ingest path) |
| **UDS** | Unified Data Streams (streaming data export) |
| **CCI** | Cloud Cost Intelligence (NR's FinOps/cost analysis product) |
| **CCBH** | Customer Contract Billing Hierarchy (new account structure) |
| **CC-ID** | Customer Contract ID — format `CC-XXXXXXXXXX` |
| **TAK** | Trusted Account Key (root account in an account hierarchy) |
| **SED** | Streaming Event Decorator |
| **ir-asdf** | Ingest Routing service controlling post-ingest storage routing |
| **LK** | Load Knitter (produces enriched `vortex.bytes` metric) |
| **CDN** | Content Delivery Network (Fastly + Cloudflare) |
| **NLB** | Network Load Balancer (AWS) |
| **NLCU** | NLB Capacity Unit (NLB billing unit) |
| **CCU** | Cloud Compute Unit (NR compute billing) |
| **aCCU** | Advanced Cloud Compute Unit |

---

## Appendix: Team Contacts

| Team | Scope | Slack |
|---|---|---|
| **Ingest Pipeline** | Vortex, SED, Kafka consumers, S3 ingest, CDN edge workers, Arbitron | #ingest-pipeline |
| **Traffic Engineering** (formerly Ingest Routing) | Post-ingest routing (ir-asdf, Wayfinder), cell routing decisions | #ingest-routing-squad |
| **Limits & Metering** | Rate limiting, usage metering | |
| **Pipeline Control** | Cloud drop rules, gateway, UDS | |
