# New Relic Querying & Platform Guide — Claude Code Reference

> **Purpose**: General-purpose guide for querying New Relic data, editing dashboards, navigating the platform, and avoiding common pitfalls. Complements the ingest/traffic-engineering-specific reference.
>
> Last updated: 2026-03-11

---

## Table of Contents

1. [Tool Selection — MCP vs CLI vs curl](#1-tool-selection)
2. [NRQL Deep Reference](#2-nrql-deep-reference)
3. [NerdGraph (GraphQL API)](#3-nerdgraph-graphql-api)
4. [Dashboard Editing via API](#4-dashboard-editing-via-api)
5. [Lookup Tables](#5-lookup-tables)
6. [Usage, Billing & Compute (NrConsumption / CCU / aCCU)](#6-usage-billing--compute)
7. [Pipeline Control (Cloud Drop Rules & Gateway)](#7-pipeline-control)
8. [Entitlements & Account Structure](#8-entitlements--account-structure)
9. [Workflow Automation](#9-workflow-automation)
10. [Nerdlet (NR1 App) Development](#10-nerdlet-development)
11. [Jira Integration Patterns](#11-jira-integration-patterns)
12. [AWS Pricing API](#12-aws-pricing-api)
13. [Common Event Types & Where They Live](#13-common-event-types)

---

## 1. Tool Selection

When querying NR from Claude Code, you have several tools. Picking the wrong one is the #1 source of wasted time.

### Decision Matrix

| I need to... | Use | Why |
|---|---|---|
| Query **staging** NRQL (simple, < 1 week) | MCP `execute_nrql_query` | Direct, no shell needed |
| Query **staging** NRQL (heavy, 1 month+) | MCP `run_nerdgraph_query` with `timeout: 540` or async submit/poll | Blocking (`timeout: 540`) is simplest; async poll is better when you need to do other work while waiting (see [Async Queries](#async-nrql-queries)) |
| Query **production** NRQL | **Bash** with `newrelic --profile prod nrql query ...` | MCP server talks to staging only |
| Read a dashboard's widgets | MCP `get_dashboard` | Returns widget titles, queries, config |
| Get dashboard **layout** (column/row/width/height) | **Bash curl** NerdGraph entity query | `get_dashboard` doesn't return layout data |
| **Edit** a dashboard (add/update/remove widgets) | **Bash curl** NerdGraph mutation | Must use GraphQL variables in JSON payload |
| Look up an entity by name/GUID | MCP `lookup_entity` or `get_entity` | Fast fuzzy search |
| Run a NerdGraph mutation | **Bash curl** or MCP `run_nerdgraph_query` | Mutations need careful variable handling |
| Check recent alerts/issues | MCP `list_recent_issues` | Built-in, returns last 24h |
| Search NR documentation | MCP `search_new_relic_documentation` | Official docs search |

### Staging NerdGraph via curl

The `newrelic` CLI staging profile doesn't work (region mismatch — key is for staging but CLI hits `api.newrelic.com`). Always use curl for staging:

```bash
curl -s -X POST 'https://staging-api.newrelic.com/graphql' \
  -H 'Content-Type: application/json' \
  -H 'API-Key: <YOUR_STAGING_API_KEY>' \
  -d '{"query":"{ actor { nrql(accounts: 10043281, query: \"SELECT count(*) FROM Metric SINCE 1 hour ago\") { results } } }"}'
```

For heavy queries, use async submit/poll pattern (see [Async Queries](#async-nrql-queries-submit--poll) section).

### Prod CLI Syntax

```bash
newrelic --profile prod nrql query --accountId 1815717 --query "SELECT count(*) FROM NrConsumption SINCE 1 day ago"
```

Key details:
- `--query` flag is **required** (not positional)
- `--accountId` sets the query account
- `--profile prod` selects the production API key
- **CLI can't handle TIMESERIES + FACET** — throws `json: cannot unmarshal array`. Use separate queries for different time windows instead

### Prod NerdGraph via curl

For mutations or complex queries against production:

```bash
curl -s -X POST 'https://api.newrelic.com/graphql' \
  -H 'Content-Type: application/json' \
  -H 'API-Key: <YOUR_PROD_API_KEY>' \
  -d @/tmp/payload.json
```

Write JSON payload to a file, reference with `curl -d @file`. Avoids shell escaping nightmares.

### Escaping Rules for NRQL in NerdGraph JSON

NRQL inside NerdGraph JSON is double-escaped. Common issues:

| Character | In raw NRQL | In NerdGraph JSON string |
|---|---|---|
| Single quote | `'value'` | `\\u0027value\\u0027` or avoid entirely |
| Double quote | N/A (not used in NRQL) | `\"` |
| Backslash | `\` | `\\\\` |

**Best practice**: avoid single quotes in NRQL when possible. Use `IN (numeric_values)` or structure queries to not need string literals. If you must use strings, `\\u0027` is the safest escape.

---

## 2. NRQL Deep Reference

### Syntax Rules & Gotchas

| Rule | Detail |
|---|---|
| **No `HAVING`** | NRQL doesn't support it. Use WHERE filters or subqueries |
| **No `UNION`** | Can't combine queries. Run separately and merge results |
| **`LIMIT` default is 10** for FACET queries | Always set `LIMIT 20` / `LIMIT 100` / `LIMIT MAX` explicitly |
| **`LIMIT MAX`** | Returns up to 5000 results for FACET queries |
| **Subquery default limit is small** | Always add `LIMIT MAX` to subqueries or IN/NOT IN lists get silently truncated |
| **2-level nested subqueries** | `WHERE x IN (SELECT ... WHERE y IN (SELECT ... LIMIT MAX) LIMIT MAX)` — works |
| **3-level nesting** | Does NOT work |
| **`FACET ... IN`** | Constrains output to known values: `FACET edge.provider IN ('fastly','cloudflare')` |
| **`FACET IN` + multi-facet** | Syntax error — `FACET x IN (...), y` fails. Use plain `FACET x, y` |
| **`LIKE` + long time range** | `LIKE '%foo%'` with `SINCE 1 month ago` often causes `NRDB:1102004`. Use exact `=` or `IN` |
| **`TIMESERIES` + `FACET`** | Works in dashboards/NerdGraph. **CLI throws `json: cannot unmarshal array`** |
| **Metric queries** | Use `FROM Metric` with `SELECT sum(metricName)` or `WHERE metricName = '...'` |

### Useful Functions

```sql
-- Rate (throughput per time unit)
rate(sum(vortex.monitoring.account.requests), 1 minute) AS RPM

-- Percentage
percentage(count(*), WHERE error IS true) AS 'Error %'

-- Byte formatting (manual — NRQL has no built-in)
sum(bytes)/1e9 AS 'GB'
sum(bytes)/1e12 AS 'TB'
sum(bytes)/1e15 AS 'PB'

-- Unique count vs uniques list
uniqueCount(account.id) AS 'Distinct Accounts'
uniques(account.id, 500) AS 'Account List'    -- returns array, limit 500

-- Latest value (useful for resolving names)
latest(orgName)

-- Conditional aggregation with FILTER
filter(sum(bytes), WHERE type = 'logs') AS 'Log Bytes'
filter(count(*), WHERE error IS true) AS 'Errors'

-- FACET CASES (bucketing)
FACET CASES(
  WHERE status < 200 AS 'Informational',
  WHERE status < 300 AS 'Success',
  WHERE status < 400 AS 'Redirect',
  WHERE status < 500 AS 'Client Error',
  WHERE status >= 500 AS 'Server Error'
)

-- Time window comparison
SELECT count(*) FROM Transaction SINCE 1 day ago COMPARE WITH 1 week ago
```

### Subquery Patterns

```sql
-- Find accounts that appear in one set but not another
SELECT count(*) FROM EventA
WHERE accountId NOT IN (
  SELECT uniques(accountId, 5000) FROM EventB
  WHERE condition = 'x'
  SINCE 1 week ago
  LIMIT MAX    -- CRITICAL: without this, list is silently truncated
)
SINCE 1 week ago

-- 2-level nesting
SELECT sum(bytes) FROM Metric
WHERE account IN (
  SELECT uniques(consumingAccountId, 500) FROM NrConsumption
  WHERE customerId IN (
    SELECT uniques(customerId, 100) FROM NrConsumption
    WHERE organizationId = 'some-guid'
    LIMIT MAX
  )
  LIMIT MAX
)
SINCE 1 day ago
```

### Timeout Rules — When to Use Async

| Data Source | Time Range | Needs async? |
|---|---|---|
| Most event types | 1 hour – 1 week | No |
| Most event types | 1 month | Sometimes |
| `vortex.bytes` (prod 1) | 1 week | No |
| `vortex.bytes` (prod 1) | 1 month | **Timeout even with async** — use 1 week max |
| `vortex.monitoring.account.*` (staging 10043281) | 1 month | **Yes** |
| `CloudCost` (staging 1) | 7 days | Usually no |
| `CloudCost` (staging 1) | 1 month | **Yes** |
| `CloudCost` (staging 1) | < 48 hours | **Error** — 48hr data delay |
| `NrConsumption` (prod 1815717) | 1 month | Usually OK |
| `NrConsumption` (prod 1815717) | 3 months | **Yes** |

### Async NRQL Queries

Two approaches for heavy queries (both tested and working on staging MCP + prod CLI as of Mar 11, 2026):

#### Option A — Blocking with `timeout: 540` (simplest)

Just add `timeout: 540` (9 minutes) to the `nrql()` call. NerdGraph holds the connection open until results are ready:

```graphql
{
  actor {
    account(id: YOUR_ACCOUNT_ID) {
      nrql(query: "SELECT sum(...) FROM Metric SINCE 1 month ago", timeout: 540) {
        results
      }
    }
  }
}
```

One call, results inline. Best when you're just waiting for a single heavy query.

#### Option B — Async Submit/Poll (for parallel work)

Per the [NerdGraph async tutorial](https://docs.newrelic.com/docs/apis/nerdgraph/examples/async-queries-nrql-tutorial/), submit the query, get a `queryId`, then poll separately. Best when you want to fire off a query and do other work while it runs.

**Step 1 — Submit** with `async: true`:

```graphql
{
  actor {
    account(id: YOUR_ACCOUNT_ID) {
      nrql(query: "SELECT sum(...) FROM Metric SINCE 1 month ago", async: true) {
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

If the query finishes within ~5 seconds, you get `results` directly. Otherwise you get `completed: false` and a **`queryId`**.

**Step 2 — Poll** using the `queryId` (repeat every 10-30s until `completed: true`):

```graphql
{
  actor {
    account(id: YOUR_ACCOUNT_ID) {
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

**Step 3 (optional) — Cancel** a running query:

```graphql
mutation {
  nrqlCancelQuery(queryId: "YOUR_QUERY_ID") {
    queryId
    requestStatus
    rejectionReason
  }
}
```

**Key details**:
- The `account` argument in step 2 must match step 1
- `retryAfter` tells you when to poll next (in seconds)
- `resultExpiration` tells you when the cached result expires
- **Data Plus required** for async queries with up to 10-minute max duration
- Works identically via MCP or curl — the queryId-based polling means no tool call needs to block

#### When to use which

| Scenario | Use |
|---|---|
| Single heavy query, just waiting for results | **Option A** (`timeout: 540`) — simplest |
| Heavy query + other work to do in parallel | **Option B** (async submit/poll) — fire and forget |
| Multiple heavy queries at once | Either — can fire multiple blocking calls in parallel, or submit all async and poll later |

### Common NRQL Patterns

```sql
-- Top N with "Other" bucket suppressed
SELECT sum(bytes) FROM Metric FACET accountName SINCE 1 day ago LIMIT 20

-- Time-bucketed trends
SELECT sum(bytes)/1e12 AS TB FROM Metric TIMESERIES 1 day SINCE 1 month ago

-- Week-over-week comparison
SELECT average(duration) FROM Transaction SINCE 1 week ago COMPARE WITH 1 week ago

-- Percentile analysis
SELECT percentile(duration, 50, 90, 95, 99) FROM Transaction SINCE 1 hour ago

-- Event-to-metric correlation
SELECT count(*) FROM Transaction SINCE 1 hour ago
WHERE appName IN (SELECT uniques(appName) FROM TransactionError SINCE 1 hour ago LIMIT MAX)

-- Count distinct then filter by count (workaround for no HAVING)
SELECT uniqueCount(userId) FROM PageView
WHERE session IN (
  SELECT uniques(session) FROM PageView
  WHERE pageUrl LIKE '%checkout%'
  SINCE 1 day ago LIMIT MAX
)
SINCE 1 day ago
```

---

## 3. NerdGraph (GraphQL API)

NerdGraph is NR's GraphQL API. Two endpoints:
- **Production**: `https://api.newrelic.com/graphql`
- **Staging**: `https://staging-api.newrelic.com/graphql`
- **EU Production**: `https://api.eu.newrelic.com/graphql`

### Common Query Patterns

```graphql
# NRQL query
{
  actor {
    nrql(accounts: 10043281, query: "SELECT count(*) FROM Metric SINCE 1 hour ago") {
      results
    }
  }
}

# NRQL with async (step 1: submit)
{
  actor {
    account(id: 10043281) {
      nrql(query: "SELECT sum(bytes) FROM Metric SINCE 1 month ago", async: true) {
        results
        queryProgress { queryId completed retryAfter retryDeadline resultExpiration }
      }
    }
  }
}

# NRQL with async (step 2: poll with queryId — repeat until completed: true)
{
  actor {
    account(id: 10043281) {
      nrqlQueryProgress(queryId: "YOUR_QUERY_ID") {
        results
        queryProgress { queryId completed retryAfter retryDeadline }
      }
    }
  }
}

# Entity lookup by GUID
{
  actor {
    entity(guid: "MTAwNDMyODF8VklafERBU0hCT0FSRHxkYToxMDMxMDg") {
      name
      entityType
      domain
      ... on DashboardEntity {
        pages { guid name widgets { id title layout { column row width height } rawConfiguration } }
      }
    }
  }
}

# Entity search by name
{
  actor {
    entitySearch(query: "name LIKE '%switchboard%'") {
      results { entities { guid name entityType domain accountId } }
    }
  }
}
```

### Mutation Pattern — Always Use Variables

**WRONG** — inline JSON causes syntax errors:
```graphql
mutation { dashboardCreate(accountId: 123, dashboard: {"name": "..."}) }
```

**CORRECT** — use variables:
```json
{
  "query": "mutation Create($accountId: Int!, $dashboard: DashboardInput!) { dashboardCreate(accountId: $accountId, dashboard: $dashboard) { entityResult { guid name } errors { description type } } }",
  "variables": {
    "accountId": 10043281,
    "dashboard": { "name": "My Dashboard", "permissions": "PUBLIC_READ_WRITE", "pages": [...] }
  }
}
```

Write the full JSON to a file (`/tmp/payload.json`) and use `curl -d @/tmp/payload.json`.

### Key NerdGraph Types

| Type | Use |
|---|---|
| `DashboardInput` | Create/update dashboards |
| `DashboardWidgetInput` | Widget definition (title, viz, layout, rawConfiguration) |
| `EntityGuid` | String GUID for any NR entity |
| `Nrql` | NRQL query string type |
| `Int!` | Required integer (e.g. accountId) |

---

## 4. Dashboard Editing via API

### Mutations Cheat Sheet

| Action | Mutation | Notes |
|---|---|---|
| Create dashboard | `dashboardCreate(accountId, dashboard)` | Returns `entityResult { guid }` |
| Update dashboard | `dashboardUpdate(guid, dashboard)` | Use for EVERYTHING — pages, widgets, variables |
| Add widgets to page | `dashboardAddWidgetsToPage(guid, widgets)` | Only send new widgets — existing ones preserved |
| Remove widgets | `dashboardUpdatePage` | Must re-send ALL remaining widgets with exact layout |
| Delete dashboard | `dashboardDelete(guid)` | Permanent |

### Critical Rules

1. **Always use GraphQL variables** — inline JSON in the mutation string causes syntax errors
2. **`dashboardUpdate` for everything** — adding pages, updating widget queries, preserving existing pages. `dashboardUpdatePage` rejects `nrqlQueries` in rawConfiguration
3. **`rawConfiguration` must be an object**, not a JSON string — `rawConfiguration: { nrqlQueries: [...] }` not `rawConfiguration: "{...}"`
4. **Always re-query live state before mutations** — if someone edited the dashboard via UI, your local vars are stale (widget IDs, layout, queries may differ)
5. **`dashboardUpdate` via CLI returns `{}`** on success — this is normal. Verify by re-querying the entity
6. **Include widget `id`** for existing widgets in `dashboardUpdate` — this updates them in-place rather than creating duplicates
7. **Grid is 12 columns wide**, rows start at 1

### Widget Structure

```json
{
  "title": "My Widget",
  "visualization": { "id": "viz.line" },
  "layout": { "column": 1, "row": 1, "height": 4, "width": 6 },
  "rawConfiguration": {
    "nrqlQueries": [{
      "accountIds": [10043281],
      "query": "SELECT count(*) FROM Transaction TIMESERIES SINCE 1 hour ago"
    }]
  }
}
```

### Visualization Types

| ID | Type |
|---|---|
| `viz.billboard` | Single big number(s) |
| `viz.line` | Line chart |
| `viz.area` | Area chart |
| `viz.bar` | Bar chart |
| `viz.stacked-bar` | Stacked bar (**not** `viz.bar` with `stacked: true`) |
| `viz.pie` | Pie chart |
| `viz.table` | Table |
| `viz.markdown` | Markdown text widget |
| `viz.json` | Raw JSON display |

### Dashboard Variables (Template Filters)

Variables go in `DashboardInput.variables` (dashboard level, not page level):

```json
{
  "name": "environment",
  "title": "Environment",
  "type": "NRQL",
  "isMultiSelection": true,
  "replacementStrategy": "DEFAULT",
  "defaultValues": [
    { "value": { "string": "us-production" } }
  ],
  "nrqlQuery": {
    "accountIds": [10043281],
    "query": "SELECT uniques(deployment.environment) FROM Metric SINCE 1 week ago"
  }
}
```

- Reference in NRQL as `{{variableName}}` — e.g. `WHERE deployment.environment IN ({{environment}})`
- `replacementStrategy: DEFAULT` wraps values in single quotes when substituted
- Multi-select substitutes as `'val1', 'val2'` — works directly in `IN ({{var}})`

---

## 5. Lookup Tables

Lookup tables let you enrich NRQL queries with external data (like mapping account IDs to customer names).

### Upload

- Upload via **Logs > Lookup tables** UI, or via the NRQL Lookups API
- CSV format, uploaded to a specific account
- Can only be queried from the account where the table was uploaded

### NRQL JOIN Syntax

```sql
FROM Transaction
JOIN (FROM lookup(myTable) SELECT accountId, customerName LIMIT 10000)
ON accountId = accountId
SELECT count(*)
FACET customerName OR accountId    -- fallback: raw attr when no match
SINCE 1 hour ago
```

Key details:
- `LIMIT 10000` on the lookup subquery — otherwise it silently truncates
- `OR` in FACET provides a fallback — shows lookup value when matched, raw attribute when not
- Cannot be used in NRQL alert conditions
- One lookup per query

### Limitations

- Max ~10K rows in a lookup table (soft limit)
- No real-time updates — must re-upload CSV to refresh
- Join performance degrades with very large tables
- Single account scope — can't query cross-account

---

## 6. Usage, Billing & Compute

### NrConsumption — Usage Snapshots

Query in **prod account 1815717** via CLI.

| Event Type | Description |
|---|---|
| `NrConsumption` | Hourly usage per account |
| `NrMTDConsumption` | Month-to-date cumulative |
| `NrCustomerConsumption` | Hourly for CCBH-migrated customers |
| `NrCustomerMTDConsumption` | MTD for CCBH-migrated customers |

**Key attributes**:
- `consumingAccountId`, `consumingAccountName` — identity
- `customerId` — CC-ID format `CC-XXXXXXXXXX` (zero-padded 10 digits)
- `organizationId` — org GUID
- `consumption`, `billableConsumption`, `freeConsumption`
- `productLine` — `DataPlatform`, `FullStackObservability`, etc.
- `metric` / `usageMetric` — `BasicBytes`, `OriginalBytes`, etc.

**Deprecated (4/01/2026)**:
- `partnershipOwningAccountId` — removed. Use `organizationId`
- `masterAccountId` — removed. Use `accountId`

### NrComputeUsage — Per-Dashboard CCU

Near real-time CCU data with per-dashboard and per-query granularity. Query in account **1815717**.

```sql
-- Total CCU for a dashboard
SELECT sum(usage) as CCU FROM NrComputeUsage
WHERE dimension_dashboardId = '<entity_guid>'
SINCE 1 day ago

-- Per-widget query breakdown (find expensive widgets)
SELECT sum(usage) as CCU FROM NrComputeUsage
WHERE dimension_dashboardId = '<entity_guid>'
FACET dimension_query
SINCE 1 day ago LIMIT 20

-- Top dashboards by CCU
SELECT sum(usage) as CCU FROM NrComputeUsage
FACET dimension_dashboardId
SINCE 1 day ago LIMIT 20

-- By user
SELECT sum(usage) as CCU FROM NrComputeUsage
FACET dimension_email
SINCE 1 day ago LIMIT 20
```

Key attributes: `dimension_dashboardId`, `dimension_email`, `dimension_productFeature`, `dimension_query` (full NRQL text), `dimension_computeType`, `usage`

**Note**: `NrConsumption` CCU metrics (`CCU`, `CoreCCU`, `AdvancedCCU`) are aggregate/billing only — no per-dashboard breakdown. Always use `NrComputeUsage` for dashboard-level analysis.

### newrelic.internal.usage — Intermediate Billing

Dimensional metric for billing analysis between `NrConsumption` (high-level) and `bytecountestimate()` (query-time). Useful for intermediate-depth cost attribution.

---

## 7. Pipeline Control

Pipeline Control includes **Cloud Drop Rules** (server-side data filtering) and **Gateway** (data routing/transformation). Both generate aCCU (Advanced Cloud Compute Units).

### Key NrConsumption Filters

```sql
-- Cloud Drop Rules aCCU
FROM NrConsumption SELECT sum(consumption) as billed_aCCU, sum(ignoredConsumption) as waived_aCCU
WHERE dimension_computeType = 'Cloud Rule processing'
  AND dimension_productCapability IN ('New Relic Control', 'Pipeline Control')
  AND dimension_productFeature NOT IN ('Cloud bytes received')
SINCE 4 weeks ago

-- Gateway aCCU
FROM NrConsumption SELECT sum(consumption) as billed_aCCU
WHERE dimension_computeType = 'Gateway processing'
  AND dimension_productCapability IN ('New Relic Control', 'Pipeline Control')
SINCE 4 weeks ago

-- Top paying orgs for Cloud Drop Rules
FROM NrConsumption SELECT sum(consumption) as aCCU
WHERE dimension_computeType = 'Cloud Rule processing'
  AND dimension_productCapability IN ('New Relic Control', 'Pipeline Control')
  AND dimension_productFeature NOT IN ('Cloud bytes received')
  AND consumption > 0
FACET organizationId, consumingAccountName
SINCE 4 weeks ago LIMIT 20
```

Key fields:
- `consumption` = billed aCCU
- `ignoredConsumption` = not billed / waived
- The vast majority of cloud drop rule aCCU is waived (non-paying orgs using free tier)

---

## 8. Entitlements & Account Structure

### Lookup Tools

| Tool | Access | Notes |
|---|---|---|
| **Entitlements Admin UI** | `one.newrelic.com/entitlements-admin` | Search by account ID, shows entitlements + history |
| **EU Entitlements Admin** | `one.eu.newrelic.com/entitlements-admin` | For EU accounts |
| **Customer Entitlements Editor** | `one.newrelic.com/entitlements-admin/customer-entitlements` | Customer structure accounts |
| **rpm-admin** | `rpm-admin.service.newrelic.com/admin/accounts` | VPN required, shows Region field |

### Account → Customer Lookup (US Only)

```sql
-- Step 1: Get CC-ID and org from an account ID (prod 1815717)
SELECT latest(customerId), latest(organizationId), latest(consumingAccountName)
FROM NrConsumption WHERE consumingAccountId = <ACCOUNT_ID>
SINCE 1 month ago

-- Step 2: Get all accounts under that customer
SELECT uniques(consumingAccountId, 500)
FROM NrConsumption WHERE customerId = 'CC-0000XXXXXX'
SINCE 1 month ago

-- Resolve account to org/customer name via vortex.bytes (prod account 1)
SELECT latest(orgName), latest(accountName)
FROM Metric WHERE metricName = 'vortex.bytes' AND account = <ACCOUNT_ID>
SINCE 1 day ago
```

### Key Patterns

- **EU accounts don't appear in US NrConsumption** (account 1815717) — absence is a signal the account is EU
- **CC-ID format**: `CC-XXXXXXXXXX` (zero-padded 10 digits)
- **`consumingAccountName`** in NrConsumption is often generic ("New Relic Account"). Better names from `vortex.bytes` `orgName` (prod account 1)
- **NerdGraph `actor.account.provisioning`** returns "Access denied" — internal Service Gateway only, not accessible from CLI/curl
- **AIS / CPS REST APIs** — internal Service Gateway only

---

## 9. Workflow Automation

NR Workflow Automation is a YAML-based automation system built into the NR UI. Requires **Advanced Compute (aCCU)** pricing plan.

### Key Facts

- Workflows are defined as YAML in the NR UI editor
- No "create via API" — but can be triggered via NerdGraph `workflowAutomationStartWorkflowRun`
- YAML indentation must be exact — copy-paste often strips it

### Step Types

| Step | Description |
|---|---|
| `newrelic.nrdb.query` | Run an NRQL query. Outputs: `results` (array), `success`, `errorMessage` |
| `newrelic.notification.sendSlack` | Send Slack message via NR notification destination (no bot token needed) |
| `slack.chat.postMessage` | Direct Slack API (needs bot token stored as secret) |

### Selectors (jq expressions)

- Give steps a `name`, reference outputs as `${{ .steps.<stepName>.outputs.<selectorName> }}`
- Safe expressions: `.results | length`, `.results | tostring`, `.results[0].fieldName`
- Complex jq (gsub, string concat, map) often causes editor errors — use `.results | tostring` as safe fallback

### Slack via NR Notification Destinations

Preferred approach — no bot token management:
1. Find existing Slack destination IDs:
   ```bash
   newrelic --profile prod nerdgraph query '{ actor { account(id: ACCT_ID) { aiNotifications { destinations(filters: {type: SLACK, active: true}) { entities { id name } } } } } }'
   ```
2. Use `newrelic.notification.sendSlack` step with destination ID
3. Channel is passed as a step input (not stored on the destination)

---

## 10. Nerdlet Development

Nerdlets are custom React apps that run inside the New Relic One platform.

### Terminology

- **Nerdpack** = top-level package (like npm). Contains Nerdlets + Launchers
- **Nerdlet** = a single UI view (React component)
- **Launcher** = the tile on the Apps page that opens a Nerdlet
- **`nr1` CLI** = separate from `newrelic` CLI. Used for scaffold/serve/publish

### Quick Start

```bash
nr1 create --type nerdpack --name my-tool
cd my-tool
nr1 nerdpack:serve    # local dev at one.newrelic.com/?nerdpacks=local
```

### Project Structure

```
my-nerdpack/
  nr1.json              # UUID, displayName
  package.json
  launchers/
    my-launcher/
      nr1.json          # rootNerdletId
      icon.png
  nerdlets/
    my-nerdlet/
      index.js          # Entry point — React component
      nr1.json          # Nerdlet config
      styles.scss
```

### SDK Components (import from 'nr1')

All UI components come from the `nr1` package (injected at runtime, NOT in node_modules):

`Select`, `SelectItem`, `TextField`, `Button`, `Table`, `TableHeader`, `TableHeaderCell`, `TableRow`, `TableRowCell`, `Card`, `CardHeader`, `CardBody`, `Grid`, `GridItem`, `Stack`, `StackItem`, `HeadingText`, `BlockText`, `Checkbox`, `Switch`, `Tabs`, `TabsItem`, `Modal`, `Toast`, `Spinner`, `Link`

### NrqlQuery Response Shape (FORMAT_TYPE.RAW)

**FACET queries**: `data.facets[]` → each row has `row.name` (facet values) and `row.results[0].sum` (aggregate). **Aliases like `AS bytes` are ignored** — key is always the function name (`sum`, `latest`, etc.)

**Non-FACET**: `data.results[]` → `row.sum`, `row.count`, etc.

**Single-dimension FACET**: `row.name` is a string, not array. Guard with: `Array.isArray(row.name) ? row.name[0] : row.name`

### Common Gotchas

| Issue | Fix |
|---|---|
| `Select.onChange` signature | `(event, value)` — not `e.target.value` |
| `Heading` not found | Use `HeadingText` — `Heading` doesn't exist in nr1 |
| `Callout` not found | Doesn't exist — use a styled `<div>` |
| `Button.VARIANT` | Doesn't exist — use `Button.TYPE` (`.PRIMARY`, `.NORMAL`, `.DESTRUCTIVE`) |
| CSS `var(--nr-*)` in inline styles | Don't work — nr1 scopes CSS. Use hardcoded hex values |
| Version conflict on publish | Bump version: `npm version patch --no-git-tag-version` before `nr1 nerdpack:publish` |
| SelectItem with mixed children | NR1 joins with commas. Use template literal: `` {`${name} (${code})`} `` |

### Lifecycle

| Step | Command |
|---|---|
| Create | `nr1 create --type nerdpack --name foo` |
| Develop | `nr1 nerdpack:serve` |
| New UUID | `nr1 nerdpack:uuid --generate --force` |
| Publish | `nr1 nerdpack:publish` |
| Subscribe | `nr1 nerdpack:subscribe` |

Can be purely client-side (no NRQL needed) — just React + state. Perfect for calculators and tools.

---

## 11. Jira Integration Patterns

### Atlassian Cloud ID

`53d56b44-5a61-439f-b394-3a02ac2db3fc` (new-relic)

### Key Projects

- **NR** = "New Relic Private" (project ID 10002) — Feature Requests live here
- **TP** = "Test Project (Issue Import Testing)" — NOT Telemetry Pipeline

### Feature Request (FR) SLA

- **10 days** in "Needs Review" status = SLA violation
- "Needs Review" is the initial status (statusCategory: "To Do")

### Custom Fields

| Field | ID | Type | Notes |
|---|---|---|---|
| Team | `customfield_10001` | team | Hierarchy: `Parent Group -> Sub-Team` |
| Product/Feature | `customfield_14938` | array | Often null |
| Level of Importance | `customfield_10041` | | |
| Account Names | `customfield_10116` | | |
| ARR | `customfield_14650` | | |

### Team Field in JQL

Team IS queryable via UUID syntax:
```sql
"team[team]" IN (uuid1, uuid2, ...)
```

Team **names** are NOT usable in JQL — must use UUIDs. To find UUIDs, fetch issues first, then extract from the team field JSON.

### Telemetry Pipelines Team UUIDs

```
091c77fe-7754-4703-845c-802602ba947b
ea229518-a006-4d09-b8c0-223a885aeff7-287
ea229518-a006-4d09-b8c0-223a885aeff7-113
ea229518-a006-4d09-b8c0-223a885aeff7-88
ea229518-a006-4d09-b8c0-223a885aeff7-175
ea229518-a006-4d09-b8c0-223a885aeff7-293
ea229518-a006-4d09-b8c0-223a885aeff7-84
```

Sub-teams under "Telemetry Pipelines": Alerts-Unassigned, Detection Configuration, Detection Evaluation, Ingest Pipeline, Unified Data Streams, Unassigned, Workflows & Notifications Platform (WIN), [Archived] Issues and Incidents Infrastructure.

**Note**: "Pipeline Control" is under **Infra+** parent group, NOT Telemetry Pipelines.

### Full JQL for TP FRs Out of SLA

```sql
project = NR AND issuetype = 'Feature Request' AND status = 'Needs Review'
AND created <= '-10d'
AND "team[team]" IN (091c77fe-7754-4703-845c-802602ba947b,
  ea229518-a006-4d09-b8c0-223a885aeff7-287,
  ea229518-a006-4d09-b8c0-223a885aeff7-113,
  ea229518-a006-4d09-b8c0-223a885aeff7-88,
  ea229518-a006-4d09-b8c0-223a885aeff7-175,
  ea229518-a006-4d09-b8c0-223a885aeff7-293,
  ea229518-a006-4d09-b8c0-223a885aeff7-84)
ORDER BY 'cf[10001]' ASC, created ASC
```

### Search Notes

- **Rovo search** returns 403 ("app not installed") — use JQL via `searchJiraIssuesUsingJql` instead
- Include fields explicitly: `["summary", "status", "created", "customfield_10001", "assignee"]`

---

## 12. AWS Pricing API

Useful for building cost calculators and COGS analysis.

### API Structure

Base URL: `https://pricing.us-east-1.amazonaws.com`

```
/offers/v1.0/aws/{service}/current/region_index.json   → per-region URL list
/offers/v1.0/aws/{service}/current/{region}/index.json  → full pricing for a region
```

### Key Services

| Service Code | Contains | File Size |
|---|---|---|
| `AWSDataTransfer` | Internet egress, inter-region transfer | Small (~few KB) |
| `AmazonEC2` | NAT Gateway, instances | **Huge** (100-400MB per region) |
| `AmazonVPC` | PrivateLink endpoints, VPC peering | Tiny (~73KB) |

### Gotchas

| Issue | Detail |
|---|---|
| **NAT Gateway is in AmazonEC2** | NOT in AmazonVPC. Filter: `group: "NGW:NatGateway"` |
| **Inter-region rates are directional** | FROM sa-east-1 TO us-east-2 = $0.138/GB. FROM us-east-2 TO sa-east-1 = $0.02/GB. For customer sending TO NR, fetch rates FROM customer's region |
| **Internet egress is tiered** | Use 10GB-10TB tier for enterprise: `beginRange = '10240'` |
| **EC2 files are enormous** | Don't pipe through jq. Use Python `json.load()` |

### PrivateLink Pricing (from AmazonVPC)

| Component | Rate |
|---|---|
| Endpoint hourly | $0.01/hr/AZ (~$7.30/mo) |
| Data processing (first 1 PB) | $0.01/GB |
| Data processing (1-5 PB) | $0.006/GB |
| Data processing (5+ PB) | $0.004/GB |

### Cross-Region PrivateLink

- Customer pays: standard PL charges + inter-region transfer
- Provider (NR) pays: $0.05/hr per active remote region (~$36.50/mo) — fixed, no per-GB
- "No premium for accessing a service in another region" — only extra cost is inter-region transfer

### Python Extraction Pattern

```python
import json, sys, urllib.request
region = sys.argv[1]
url = f"https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/{region}/index.json"
with urllib.request.urlopen(url, timeout=120) as resp:
    data = json.load(resp)
for sku, product in data.get('products', {}).items():
    attrs = product.get('attributes', {})
    # filter by group/usagetype...
    for term_type, terms in data.get('terms', {}).items():
        if sku in terms:
            for offer_id, offer in terms[sku].items():
                for dim_id, dim in offer.get('priceDimensions', {}).items():
                    price = dim.get('pricePerUnit', {}).get('USD', '?')
```

---

## 13. Common Event Types & Where They Live

Quick reference for "where do I find X?"

### Production (account 1 via CLI)

| Event/Metric | Description |
|---|---|
| `vortex.bytes` (Metric) | Enriched ingest volume by org/account/cloud routing. Best source for customer names (`orgName`) |
| `Transaction` | APM transactions |
| `TransactionError` | APM errors |
| `Span` | Distributed tracing spans |
| `Log` | Log events |
| `Metric` | Dimensional metrics (general) |
| `NrIntegrationError` | Ingest errors (rejected data) |

### Production (account 1815717 via CLI)

| Event | Description |
|---|---|
| `NrConsumption` | Hourly account usage |
| `NrMTDConsumption` | Month-to-date usage |
| `NrComputeUsage` | Per-dashboard/query CCU |
| `NrdbQuery` | Query execution metadata (note: `inspectedCount` = 0 for internal account 1) |

### Staging (account 10043281 via MCP or staging curl)

| Metric | Description |
|---|---|
| `vortex.monitoring.account.bytes` | Edge-level ingest volume with `edge.provider` (CDN vs PL) |
| `vortex.monitoring.account.requests` | Edge-level request counts (same attributes) |

### Staging (account 1 via staging curl)

| Event | Description |
|---|---|
| `CloudCost` | CCI — daily AWS/Azure cost per line item |
| `KubernetesCost` | CCI — K8s pod/node cost allocation |
| `CloudCostEstimate` | CCI — real-time cost estimates |

### Staging (account 1025650 via staging curl)

| Event/Metric | Description |
|---|---|
| `ExportSendResult` | UDS/streaming data export telemetry. ~13 month retention |
| `export.byteCount` (Metric) | UDS export volume metric |

---

## Appendix: Abbreviations

| Abbrev | Meaning |
|---|---|
| **CF** | Container Fabric (internal NR platform — Crossplane/infra) |
| **CFL** | Cloudflare (CDN) |
| **TI** | Telemetry Ingest |
| **SB** | Switchboard (java-switchboard — PL cells) |
| **TE** | Traffic Engineering (formerly Ingest Routing) |
| **PL** | PrivateLink |
| **BYOS3** | Bring Your Own S3 |
| **UDS** | Unified Data Streams (streaming data export) |
| **CCI** | Cloud Cost Intelligence (FinOps) |
| **CCBH** | Customer Contract Billing Hierarchy |
| **CC-ID** | Customer Contract ID (`CC-XXXXXXXXXX`) |
| **TAK** | Trusted Account Key (root account) |
| **SED** | Streaming Event Decorator |
| **LK** | Load Knitter |
| **CDN** | Content Delivery Network (Fastly + Cloudflare) |
| **NLB** | Network Load Balancer (AWS) |
| **NLCU** | NLB Capacity Unit |
| **CCU** | Cloud Compute Unit |
| **aCCU** | Advanced Cloud Compute Unit |
| **POA** | Partnership Owning Account (deprecated) |
| **NRDB** | New Relic Database (query engine) |
| **NRQL** | New Relic Query Language |
| **GC** | Grand Central (CI/CD) |
