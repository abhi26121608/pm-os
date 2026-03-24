# Querying New Relic from Claude Code: Setup & Reference Guide

> A self-contained guide for NR employees who want Claude Code to query New Relic data, triage incidents, analyze performance, manage alerts, and search docs, all from the terminal.
>
> Based on reference docs by Paul Frazier (Traffic Engineering). Last updated: March 2026.

---

## What This Gets You

Once set up, you can talk to Claude Code in plain English and it queries NR for you. No need to remember NRQL syntax, NerdGraph schemas, or which account has what data.

**Performance & Troubleshooting:**
- "What's the error rate for my app in the last hour?"
- "Show me the slowest transactions for service X"
- "Analyze thread metrics for this Java app"
- "Are there any GC issues affecting performance?"

**Incident Triage:**
- "Show me all open issues in the last 24 hours"
- "Generate a root cause analysis for this alert"
- "What's the user impact of this incident?"
- "Acknowledge this issue and mark it as investigating"

**Alerts & Monitoring:**
- "List all alert policies for this account"
- "Create an alert condition for high error rate on app X"
- "What alert conditions are recommended for this entity?"
- "Show me synthetic monitor results"

**Logs & Parsing:**
- "Pull recent logs for this service"
- "Analyze error patterns in the last hour of logs"
- "Generate a Grok pattern for this log format"
- "Create a log parsing rule for my app"

**Deployments & Change Tracking:**
- "What changed in the last 48 hours for this app?"
- "Analyze the performance impact of the last deployment"
- "Show me deployment history for this entity"

**Dashboards & Entities:**
- "List all dashboards in this account"
- "Show me the widgets on dashboard X"
- "Look up the entity for service Y"
- "What entities are related to this service?"

**Usage & Costs:**
- "What's our CCU consumption this month?"
- "Show me data retention policies for this account"
- "What are the top deviating entities right now?"

**Documentation & Knowledge:**
- "Search NR docs for TIMESERIES syntax"
- "How do I set up drop rules?"

Without these tools, Claude Code can read and write code but can't touch live NR data. With them, it becomes an operational copilot.

---

## Quick Start (5 Minutes)

If you just want to get going fast:

1. **Install the `nr` plugin** (if you don't have it):
   ```
   /plugin marketplace add claude-plugin-marketplace
   /plugin install nr
   ```

2. **Restart Claude Code** (new session needed after plugin install)

3. **Trigger authentication** by asking Claude Code anything that needs NR data:
   ```
   "List my NR accounts"
   ```
   A browser window opens. Log in with your NR Okta SSO credentials.

4. **Start querying:**
   ```
   "Show me error rates for my app in the last hour"
   ```

That's it. The MCP server handles auth, routing, and tool selection. If you also need **production** data (ingest volume, billing, NrConsumption), continue to Setup 2 below for the CLI.

---

## Setup 1: NR MCP Server (Recommended Start)

### What it is

An MCP (Model Context Protocol) server that gives Claude Code direct access to 50+ NR tools: run NRQL, look up entities, read dashboards, manage alerts, analyze logs, triage incidents, and more. It connects to the NR staging environment.

### Why staging matters

A lot of NR's internal operational telemetry lives in staging accounts:
- Edge telemetry (`vortex.monitoring.account.*`) is in staging account 10043281
- CCI cost data (`CloudCost`, `KubernetesCost`) is in staging account 1
- UDS export data (`ExportSendResult`) is in staging account 1025650

### Install the `nr` plugin

```bash
/plugin marketplace add claude-plugin-marketplace
/plugin install nr
```

This installs the `nr` plugin (v1.2.0, by NOVA Team), which configures four MCP servers:

| MCP Server | What it does |
|---|---|
| **nr-mcp-server** | 50+ tools for querying, entities, alerts, logs, dashboards, incidents, deployments |
| **bedrock-retrieval** | Knowledge base search via Amazon Bedrock |
| **google-search** | Web search and page fetching |
| **atlassian** | Jira/Confluence integration |

### Authenticating the MCP server

The NR MCP server uses OAuth. Here's the flow:

1. **Start a fresh Claude Code session** after installing the plugin
2. **Ask Claude Code to use any NR tool**, e.g.: `"List my NR accounts"`
3. **A browser window opens** with the NR login page
4. **Log in with your NR Okta SSO credentials** (staging environment)
5. **Return to Claude Code**. The session is now authenticated.

Authentication persists for the session. If you start a new session, you may need to re-authenticate.

### Verify it works

Ask Claude Code:
```
"List my available New Relic accounts"
```

If you get a list of accounts with IDs and names, you're connected.

### No staging API key needed

Unlike the direct curl approach, the MCP server handles auth via OAuth. You do NOT need to manually create or manage a staging API key.

### Important: the MCP server talks to staging, not production

For production queries (ingest volume, billing, NrConsumption on prod account 1 or 1815717), you need the CLI (Setup 2) or direct curl (Setup 3).

---

## Setup 2: New Relic CLI (Production Data)

### What it is

A command-line tool that runs NRQL queries against production NR accounts. Claude Code uses it via Bash commands.

### Install

```bash
brew install newrelic-cli
```

### Create a Production API Key

1. Go to [one.newrelic.com](https://one.newrelic.com)
2. Click your profile icon (bottom-left) > **API Keys**
3. Click **Create a key**
4. Key type: **User**
5. Account: pick any account you have access to (this does NOT limit which accounts you can query. You specify `--accountId` per query)
6. Name it something like "Claude Code CLI"
7. Copy the key (starts with `NRAK-`)

**Important:** This must be a **User key**, not an Ingest or License key. User keys query data out. Ingest keys send data in.

### Add the profile

```bash
newrelic profile add --profile prod --apiKey NRAK-XXXXXXXXXXXXXXXXXXXX --region US --accountId 1 -y
```

Note: the flag is `--profile`, not `--name`. The `-y` flag skips the interactive license key prompt.

### Test it

```bash
newrelic --profile prod nrql query --accountId 1 --query "SELECT count(*) FROM Metric SINCE 1 hour ago"
```

If you get results back, you're good.

### Key production accounts

| Account ID | What lives there |
|---|---|
| **1** | `vortex.bytes` (ingest volume metrics, enriched by Load Knitter) |
| **1815717** | `NrConsumption`, `NrComputeUsage` (usage, billing, CCU) |

### CLI syntax

```bash
newrelic --profile prod nrql query --accountId <ACCOUNT_ID> --query "<NRQL>"
```

### CLI gotchas

- Always use the `--query` flag (it's required, not positional)
- CLI can't handle `TIMESERIES` + `FACET` together. It throws a JSON unmarshal error. Run separate queries instead.
- For EU accounts, add `--region EU` or create a second profile

---

## Setup 3: Staging API Key for Direct curl (Optional)

### When you need this

Only if you don't have the MCP server set up, or you need to run NerdGraph mutations that the MCP server doesn't support.

### How to use it

Save your staging key somewhere safe, then use curl:

```bash
curl -s -X POST 'https://staging-api.newrelic.com/graphql' \
  -H 'Content-Type: application/json' \
  -H 'API-Key: NRAK-XXXXXXXXXXXXXXXXXXXX' \
  -d '{"query":"{ actor { account(id: 10043281) { nrql(query: \"SELECT count(*) FROM Metric SINCE 1 hour ago\") { results } } } }"}'
```

### Escaping warning

NRQL inside NerdGraph JSON requires double-escaping. Single quotes become `\\u0027`. Avoid single quotes in NRQL when possible, or write the JSON payload to a temp file and use `curl -d @/tmp/payload.json`.

---

## Full MCP Tool Catalog (53 Tools)

All tools below are available through the `nr-mcp-server` once authenticated.

### Account & Entity Discovery

| Tool | What it does |
|---|---|
| `list_available_new_relic_accounts` | List all accounts you can access (ID + name) |
| `get_entity` | Fetch entity by GUID, or search by name/domain/type |
| `list_entity_types` | List all entity types in NR (domain, type, metric definitions) |
| `lookup_entity` | Fuzzy search for entities by name, tag, or ID |
| `search_entity_with_tag` | Find entities by tag key/value pairs |
| `list_related_entities` | Get entities one relationship hop away from a given entity |

### Querying & Data

| Tool | What it does |
|---|---|
| `execute_nrql_query` | Run raw NRQL against any account |
| `natural_language_to_nrql_query` | Describe what you want in English, get NRQL + results |
| `run_nerdgraph_query` | Run arbitrary NerdGraph (GraphQL) queries |
| `convert_time_period_to_epoch_ms` | Convert "yesterday at 3pm" or "2 hours ago" to epoch ms |
| `get_current_time` | Get current server time |

### Performance Analysis

| Tool | What it does |
|---|---|
| `analyze_golden_metrics` | Throughput, response time, error rate for an entity in a time window |
| `analyze_transactions` | Find slow/error-prone transactions with traces and error distributions |
| `list_top_transactions` | Top transactions by time consumed, response time, error rate, throughput, or apdex |
| `analyze_threads` | Thread state, CPU, memory metrics (Java, Go, etc.) |
| `analyze_kafka_metrics` | Consumer lag, producer throughput, message latency, partition balance |
| `list_garbage_collection_metrics` | GC pause times, memory usage |
| `list_entity_error_groups` | Error groups from Errors Inbox, prioritized by user impact |
| `fetch_top_deviation` | Top deviating entities in your system right now |
| `get_distributed_trace_details` | Full distributed trace by trace ID |

### Alerts & Incidents

| Tool | What it does |
|---|---|
| `list_recent_issues` | All issues in the last 24 hours for an account |
| `change_issue_state` | Acknowledge, unacknowledge, mark as investigating, or resolve an issue |
| `search_incident` | Search alert incidents by issue ID, entity, policy, or condition |
| `list_alert_policies` | List alert policies (with optional name filter) |
| `list_alert_conditions` | List conditions within a specific policy |
| `create_alert_policy` | Create a new policy with incident preference |
| `create_alert_condition` | Create an NRQL alert condition in a policy |
| `fetch_alert_condition_recommendations` | AI-recommended alert conditions for an entity |
| `alert_condition_recommendation_tool` | Recommend conditions by entity domain/type |
| `generate_alert_intelligence_report` | AI root cause analysis for an alert incident |
| `generate_alert_insights_report` | Alert intelligence analysis for a specific issue |

### Logs

| Tool | What it does |
|---|---|
| `list_recent_logs` | Fetch recent logs for an entity in a time window |
| `analyze_entity_logs` | Identify error patterns and anomalies in logs |
| `create_log_parsing_rule` | Create a Grok pattern parsing rule |
| `update_log_parsing_rule` | Update an existing parsing rule |
| `delete_log_parsing_rule` | Delete a parsing rule |
| `list_log_parsing_rules` | List all parsing rules for an account |
| `generate_log_parsing_rule` | AI-generate a Grok pattern from a sample log |
| `test_log_parsing_rule` | Validate a Grok pattern against a sample log |

### Dashboards

| Tool | What it does |
|---|---|
| `list_dashboards` | List all dashboards for an account (GUID, name, owner, permalink) |
| `get_dashboard` | Get full dashboard detail: pages, widgets, queries, config |

### Deployments & Change Tracking

| Tool | What it does |
|---|---|
| `list_change_events` | Change events (deployments, config changes) for an entity |
| `analyze_deployment_impact` | Compare metrics before/after a deployment |
| `entity_deployments` | Stream real-time deployment updates for an entity |
| `generate_user_impact_report` | Quantify end-user impact of an issue (affected users, degraded services) |

### Synthetic Monitoring

| Tool | What it does |
|---|---|
| `list_synthetic_monitors` | List synthetic monitors for an account |
| `get_synthetic_monitor_result` | Get monitor run details and permalink |

### Usage & Configuration

| Tool | What it does |
|---|---|
| `fetch_ccu_usage` | Compute Unit consumption data (natural language query) |
| `get_retention_policy_and_namespaces` | Data retention policies for all namespaces in an account |

### Documentation & Diagnostics

| Tool | What it does |
|---|---|
| `search_new_relic_documentation` | Search official NR docs |
| `run_diagnostics_cli` | Run NR Diagnostics CLI to detect agent configuration and connectivity issues |
| `user_id_lookup` | Look up your own NR user ID |
| `support_cases_lookup` | Check status of support tickets |

---

## Use Cases & Example Prompts

These are real prompts you can give Claude Code. It picks the right tools automatically.

### PM Checking Product Health

```
"What's the error rate across all apps in account 13087905 in the last hour?"
→ execute_nrql_query

"Show me the golden metrics for service X since yesterday"
→ analyze_golden_metrics

"What are the top deviating entities right now?"
→ fetch_top_deviation

"How much CCU did we consume this month?"
→ fetch_ccu_usage
```

### SRE Triaging an Incident

```
"Show me all open issues in account 13087905"
→ list_recent_issues

"Generate a root cause analysis for issue XYZ"
→ generate_alert_insights_report

"What's the user impact of this issue on entity ABC?"
→ generate_user_impact_report

"Acknowledge this issue and mark it as investigating"
→ change_issue_state

"Pull the last 50 error logs for this service in the last 30 minutes"
→ list_recent_logs

"Analyze error patterns in the logs for entity ABC since the incident started"
→ analyze_entity_logs
```

### Engineer Debugging Performance

```
"What are the slowest transactions for this app in the last hour?"
→ list_top_transactions

"Show me the distributed trace for trace ID xyz123"
→ get_distributed_trace_details

"Are there GC issues affecting this Java app?"
→ list_garbage_collection_metrics

"Analyze thread metrics for this service"
→ analyze_threads

"What error groups are showing up in Errors Inbox for this entity?"
→ list_entity_error_groups
```

### Checking Deployments

```
"What deployments happened in the last 48 hours for this app?"
→ list_change_events

"Analyze the performance impact of the deployment at 2pm yesterday"
→ analyze_deployment_impact

"Did the last deploy cause a regression in response time?"
→ analyze_deployment_impact + analyze_golden_metrics
```

### Managing Alerts

```
"List all alert policies in this account"
→ list_alert_policies

"What conditions are in the 'Production Alerts' policy?"
→ list_alert_conditions

"Create an alert for error rate above 5% on app X"
→ create_alert_condition

"What alert conditions does NR recommend for this entity?"
→ fetch_alert_condition_recommendations
```

### Working with Logs

```
"Generate a Grok pattern for this log line: 2026-03-18 ERROR [main] com.nr.App - Failed to process request id=12345 in 234ms"
→ generate_log_parsing_rule

"Test this Grok pattern against my sample log"
→ test_log_parsing_rule

"Create a parsing rule to extract request IDs from my app logs"
→ create_log_parsing_rule
```

---

## Which Tool for What: Decision Matrix

| I need to... | Use | Why |
|---|---|---|
| Query **staging** NRQL | MCP: `execute_nrql_query` | Direct, no shell needed |
| Query **production** NRQL | CLI: `newrelic --profile prod nrql query ...` | MCP server talks to staging only |
| Convert English to NRQL | MCP: `natural_language_to_nrql_query` | AI translates and executes |
| Look up an entity | MCP: `lookup_entity` or `get_entity` | Fast fuzzy search |
| Read a dashboard | MCP: `get_dashboard` | Returns widgets, queries, config |
| **Edit** a dashboard | Curl NerdGraph mutation | MCP doesn't support dashboard mutations |
| Check recent alerts | MCP: `list_recent_issues` | Built-in, last 24h |
| Triage an incident | MCP: `generate_alert_insights_report` | AI analysis with root cause |
| Analyze app performance | MCP: `analyze_golden_metrics` | Throughput, errors, response time |
| Debug slow transactions | MCP: `list_top_transactions` + `analyze_transactions` | Traces and error distributions |
| Pull and analyze logs | MCP: `list_recent_logs` + `analyze_entity_logs` | Fetch then pattern analysis |
| Create alert conditions | MCP: `create_alert_condition` | Full condition config |
| Check deployment impact | MCP: `analyze_deployment_impact` | Before/after comparison |
| Search NR documentation | MCP: `search_new_relic_documentation` | Official docs search |
| Run NerdGraph mutations | Curl or MCP: `run_nerdgraph_query` | Mutations need careful variable handling |

---

## Reference Docs

These docs provide deep NRQL syntax, NerdGraph patterns, and ingest-specific knowledge. If you're doing serious querying, clone them into your workspace.

**Paul Frazier's reference docs** (Traffic Engineering):

| File | What it covers |
|---|---|
| `new-relic-querying-guide-claude.md` | NRQL syntax, NerdGraph, dashboards, lookup tables, billing/usage, pipeline control, entitlements, workflow automation, NR1 app dev, Jira, AWS pricing |
| `ingest-traffic-engineering-claude-reference.md` | Ingest architecture, PrivateLink vs CDN, FlexCloud routing, CCI costs, UDS streaming export, customer triage runbook |
| `mcp-server-query-guidance-request.md` | Paul's proposal for improving the NR MCP server (better NRQL resources, dynamic data discovery) |

To clone them:
```bash
GH_HOST=source.datanerd.us gh repo clone pfrazier/paul-makes-claude-md-files ~/paul-claude-refs
```

To pull updates:
```bash
cd ~/paul-claude-refs && git pull
```

**Dan Young's CLI skill** (optional, complementary):

A Claude Code skill that provides NRQL reference docs and CLI command guides. Repo: `source.datanerd.us/dyoung/dyoung-marketplace`. Not required for querying, but useful if you want Claude Code to have deep CLI syntax knowledge.

---

## Troubleshooting

### "MCP server says Needs authentication"

Start a fresh Claude Code session and try using any NR MCP tool (e.g., "List my NR accounts"). The OAuth flow should trigger automatically and open a browser window. Log in with NR Okta SSO.

### "No data returned for my query"

- **Check the account ID.** Different data lives in different accounts. Ask Claude Code to list your accounts and pick the right one.
- **Check the time window.** Default is often "last hour." Try expanding to "last 24 hours" or "last 7 days."
- **Check the event type.** Ask: `"Show me what event types exist in account X in the last hour"` -- this runs `SHOW EVENT TYPES SINCE 1 hour ago`.
- **Staging vs production.** The MCP server queries staging. Production data (ingest volume, billing) needs the CLI.

### "CLI throws JSON unmarshal error"

The NR CLI can't handle `TIMESERIES` + `FACET` together. Split into separate queries:
```bash
# Instead of TIMESERIES ... FACET ... do:
newrelic --profile prod nrql query --accountId 1 --query "SELECT count(*) FROM Metric FACET appName SINCE 1 hour ago"
newrelic --profile prod nrql query --accountId 1 --query "SELECT count(*) FROM Metric TIMESERIES SINCE 1 hour ago"
```

### "Account access denied"

Some accounts are billing-restricted or require specific roles. Try a different account, or check your permissions in NR.

### "The MCP tools aren't showing up"

Make sure the `nr` plugin is installed:
```
/plugin list
```

If it's not there, install it:
```
/plugin marketplace add claude-plugin-marketplace
/plugin install nr
```

Then restart Claude Code (new session required).

### CLI staging profile doesn't work

Known issue. The NR CLI's staging profile has a region mismatch (the key targets staging but the CLI hits `api.newrelic.com`). Use the MCP server or direct curl for staging data. Don't waste time trying to make `--profile staging` work.

### Rotating your API key

If you need to rotate your production CLI key:
1. Create a new User key in [one.newrelic.com](https://one.newrelic.com) > API Keys
2. Update the CLI profile:
   ```bash
   newrelic profile add --profile prod --apiKey NRAK-NEWKEYHERE --region US --accountId 1 -y
   ```
3. Delete the old key in the NR UI

The MCP server uses OAuth tokens, so no manual key rotation is needed there.

---

## Credits

Reference docs by Paul Frazier (Traffic Engineering). NR MCP server by the NOVA Team. CLI plugin by Dan Young. Guide assembled March 2026, updated March 2026.
