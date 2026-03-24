# Request: Add Query Guidance to the NR MCP Server

## Problem

The NR MCP server provides ~50 tools but almost no guidance on how to actually query New Relic data. An LLM connecting to the server for the first time gets:

- **One NRQL example** across all tool descriptions: `SELECT count(*) FROM Transaction WHERE appName = 'MyApp' SINCE 1 hour ago`
- **Zero MCP resources** (the server exposes none)
- **Minimal server instructions** (just "use JSON for array params")
- **No data model context** — no event types, no attribute names, no metric vs event distinction

The result: the LLM can call tools but can't construct effective queries without extensive external context. In practice, users end up building that context manually (custom instructions files, memory notes, learned patterns from trial and error). The `natural_language_to_nrql_query` tool helps for simple cases but is a black box — you can't debug or iterate on its output.

For comparison, the `create_alert_condition` tool description is excellent — it explains aggregation methods, threshold operators, timing constraints, and when to use each option. That level of guidance is missing from the query-facing tools.

## What the MCP Protocol Already Supports

MCP has mechanisms designed for exactly this problem that the server isn't using:

1. **Resources** — static or dynamic reference content the LLM can read
2. **Server instructions** — a block of context loaded with the server connection
3. **Richer tool descriptions** — more examples and usage patterns in each tool's description field

## Proposed Changes

### 1. Add a NRQL syntax resource

A static resource (`resource://nrql-reference` or similar) covering:

- Core clauses: SELECT, FROM, WHERE, FACET, TIMESERIES, LIMIT, SINCE/UNTIL, COMPARE WITH
- Aggregation functions: count, sum, average, max, min, latest, uniqueCount, percentile, rate, filter
- Key distinctions: Metric type queries vs Event queries (FROM Metric WHERE metricName = '...' with sum/average vs FROM Transaction with count/latest)
- Subquery syntax and the LIMIT MAX requirement
- JOIN / lookup table syntax
- Common patterns (error rate, throughput, percentiles, time comparisons)

This doesn't need to be exhaustive — even 50 lines of the most common patterns would be a massive improvement.

### 2. Add dynamic data discovery resources

These would let the LLM explore what's actually queryable in a given account:

| Resource | Returns |
|---|---|
| `resource://event-types/{accountId}` | Available event types (equivalent to `SHOW EVENT TYPES`) |
| `resource://attributes/{accountId}/{eventType}` | Attributes on a given event type (equivalent to `SELECT keyset() FROM EventType`) |

This is the highest-impact change. Right now the LLM has to guess what event types and attributes exist — or the user has to tell it. Dynamic discovery closes that gap entirely.

### 3. Expand the server instructions block

The current server instructions are:
> "This server provides tools to interact with the New Relic platform. When making function calls using tools that accept array or object parameters ensure those are structured using JSON."

This could include:
- A 10-line NRQL quick reference (SELECT/FROM/WHERE/FACET/TIMESERIES/LIMIT/SINCE)
- The Metric vs Event distinction (3 lines)
- Common time range syntax (SINCE 1 hour ago, SINCE 1 day ago, SINCE 1 week ago UNTIL 1 day ago)
- A note about query timeouts and how to handle them (async patterns, narrowing time ranges)

Server instructions are always loaded into context, so this should be concise — a cheat sheet, not a manual.

### 4. Add examples to query tool descriptions

`execute_nrql_query` currently has one example. Adding 4-5 more would cover the major query shapes:

```
Examples:
- Throughput:  SELECT rate(count(*), 1 minute) FROM Transaction SINCE 1 hour ago
- Error rate:  SELECT percentage(count(*), WHERE error IS true) FROM Transaction SINCE 1 hour ago
- Metrics:     SELECT average(apm.service.transaction.duration) FROM Metric WHERE appName = 'MyApp' SINCE 1 hour ago
- Logs:        SELECT * FROM Log WHERE message LIKE '%error%' SINCE 30 minutes ago LIMIT 20
- Faceted:     SELECT count(*) FROM Transaction FACET appName SINCE 1 day ago LIMIT 50
- Time series: SELECT average(duration) FROM Transaction TIMESERIES 1 hour SINCE 1 day ago
```

Similarly, `run_nerdgraph_query` could show a NRQL-via-NerdGraph example and a mutation example, since the current example only shows a simple account name lookup.

### 5. Improve error responses

When queries fail, include actionable guidance in the response:
- Timeout → suggest narrowing time range, adding LIMIT, or using async
- Unknown attribute → list available attributes on that event type
- Unknown event type → list available event types in the account
- Syntax error → point to the specific clause that failed

## Priority Suggestion

If I had to pick one thing: **dynamic data discovery** (proposal #2). Everything else is static context that can be worked around with user-provided instructions. But "what data exists in this account?" is unknowable without querying, and it's the first thing any LLM needs to know before it can construct a useful query.

## Context

I'm a PM at New Relic and a heavy user of the MCP server for operational queries (PrivateLink analysis, cloud routing, COGS, traffic engineering). Over months of use I've built up ~200 lines of learned query patterns, attribute mappings, timeout workarounds, and account-specific context in instruction files. Most of that knowledge could be eliminated or reduced if the server itself provided better guidance through the mechanisms MCP already supports.

---

*Written March 2026*
