# Querying New Relic from Claude Code: Setup & Reference Guide

> A guide for querying New Relic data, triaging incidents, analyzing performance, managing alerts, and searching docs from Claude Code.

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

---

## Quick Start

1. **Ensure NR MCP server is configured** in your Claude Code setup

2. **Trigger authentication** by asking Claude Code anything that needs NR data:
   ```
   "List my NR accounts"
   ```
   A browser window opens. Log in with your New Relic credentials.

3. **Start querying:**
   ```
   "Show me error rates for my app in the last hour"
   ```

That's it. The MCP server handles auth, routing, and tool selection.

---

## NR MCP Server Tools

The NR MCP server gives Claude Code direct access to 50+ tools.

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

### Checking Product Health

```
"What's the error rate across all apps in my account in the last hour?"
→ execute_nrql_query

"Show me the golden metrics for service X since yesterday"
→ analyze_golden_metrics

"What are the top deviating entities right now?"
→ fetch_top_deviation

"How much CCU did we consume this month?"
→ fetch_ccu_usage
```

### Triaging an Incident

```
"Show me all open issues in my account"
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

### Debugging Performance

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
"Generate a Grok pattern for this log line: 2026-03-18 ERROR [main] com.example.App - Failed to process request id=12345 in 234ms"
→ generate_log_parsing_rule

"Test this Grok pattern against my sample log"
→ test_log_parsing_rule

"Create a parsing rule to extract request IDs from my app logs"
→ create_log_parsing_rule
```

---

## Decision Matrix

| I need to... | Use | Why |
|---|---|---|
| Query NRQL | MCP: `execute_nrql_query` | Direct, no shell needed |
| Convert English to NRQL | MCP: `natural_language_to_nrql_query` | AI translates and executes |
| Look up an entity | MCP: `lookup_entity` or `get_entity` | Fast fuzzy search |
| Read a dashboard | MCP: `get_dashboard` | Returns widgets, queries, config |
| Check recent alerts | MCP: `list_recent_issues` | Built-in, last 24h |
| Triage an incident | MCP: `generate_alert_insights_report` | AI analysis with root cause |
| Analyze app performance | MCP: `analyze_golden_metrics` | Throughput, errors, response time |
| Debug slow transactions | MCP: `list_top_transactions` + `analyze_transactions` | Traces and error distributions |
| Pull and analyze logs | MCP: `list_recent_logs` + `analyze_entity_logs` | Fetch then pattern analysis |
| Create alert conditions | MCP: `create_alert_condition` | Full condition config |
| Check deployment impact | MCP: `analyze_deployment_impact` | Before/after comparison |
| Search NR documentation | MCP: `search_new_relic_documentation` | Official docs search |

---

## Troubleshooting

### "No data returned for my query"

- **Check the account ID.** Different data lives in different accounts. Ask Claude Code to list your accounts and pick the right one.
- **Check the time window.** Default is often "last hour." Try expanding to "last 24 hours" or "last 7 days."
- **Check the event type.** Ask: `"Show me what event types exist in account X in the last hour"` -- this runs `SHOW EVENT TYPES SINCE 1 hour ago`.

### "Account access denied"

Some accounts are billing-restricted or require specific roles. Try a different account, or check your permissions in NR.

### "The MCP tools aren't showing up"

Ensure the NR MCP server is properly configured in your Claude Code settings. Restart Claude Code after configuration changes.
